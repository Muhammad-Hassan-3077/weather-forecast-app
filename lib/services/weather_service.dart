import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherService {
  static const String _geocodingBase =
      'https://geocoding-api.open-meteo.com/v1/search';

  static const String _forecastBase = 'https://api.open-meteo.com/v1/forecast';

  final http.Client _client;

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<CityLocation>> searchCities(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.length < 2) {
      return [];
    }

    final uri = Uri.parse(_geocodingBase).replace(
      queryParameters: {
        'name': trimmedQuery,
        'count': '8',
        'language': 'en',
        'format': 'json',
      },
    );

    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('City search failed. Please try again.');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final results = json['results'] as List<dynamic>? ?? [];

    return results.map((item) {
      final city = item as Map<String, dynamic>;

      return CityLocation(
        name: city['name'] as String? ?? 'Unknown city',
        country: city['country'] as String? ?? '',
        admin1: city['admin1'] as String?,
        latitude: (city['latitude'] as num).toDouble(),
        longitude: (city['longitude'] as num).toDouble(),
      );
    }).toList();
  }

  Future<WeatherData> getWeather(CityLocation location) async {
    final uri = Uri.parse(_forecastBase).replace(
      queryParameters: {
        'latitude': location.latitude.toString(),
        'longitude': location.longitude.toString(),
        'current':
            'temperature_2m,relative_humidity_2m,apparent_temperature,'
            'is_day,precipitation,weather_code,wind_speed_10m',
        'hourly': 'temperature_2m,weather_code',
        'daily':
            'weather_code,temperature_2m_max,temperature_2m_min,'
            'sunrise,sunset',
        'timezone': 'auto',
        'forecast_days': '7',
      },
    );

    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Weather service unavailable. Please try again.');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    final current = json['current'] as Map<String, dynamic>?;
    final hourly = json['hourly'] as Map<String, dynamic>?;
    final daily = json['daily'] as Map<String, dynamic>?;

    if (current == null || hourly == null || daily == null) {
      throw Exception('Weather data is incomplete. Please try again.');
    }

    final hourlyTimes = hourly['time'] as List<dynamic>? ?? [];
    final hourlyTemps = hourly['temperature_2m'] as List<dynamic>? ?? [];
    final hourlyCodes = hourly['weather_code'] as List<dynamic>? ?? [];

    final dailyTimes = daily['time'] as List<dynamic>? ?? [];
    final dailyHighs = daily['temperature_2m_max'] as List<dynamic>? ?? [];
    final dailyLows = daily['temperature_2m_min'] as List<dynamic>? ?? [];
    final dailyCodes = daily['weather_code'] as List<dynamic>? ?? [];

    final currentTime =
        DateTime.tryParse(current['time'] as String? ?? '') ?? DateTime.now();

    final upcomingHours = <HourlyWeather>[];

    for (var i = 0; i < hourlyTimes.length; i++) {
      if (i >= hourlyTemps.length || i >= hourlyCodes.length) {
        break;
      }

      final time = DateTime.tryParse(hourlyTimes[i] as String? ?? '');

      if (time == null || time.isBefore(currentTime)) {
        continue;
      }

      upcomingHours.add(
        HourlyWeather(
          time: time,
          temperature: (hourlyTemps[i] as num).toDouble(),
          weatherCode: (hourlyCodes[i] as num).toInt(),
        ),
      );

      if (upcomingHours.length == 24) {
        break;
      }
    }

    final dailyForecast = <DailyWeather>[];

    for (var i = 0; i < dailyTimes.length; i++) {
      if (i >= dailyHighs.length ||
          i >= dailyLows.length ||
          i >= dailyCodes.length) {
        break;
      }

      final date = DateTime.tryParse(dailyTimes[i] as String? ?? '');

      if (date == null) {
        continue;
      }

      dailyForecast.add(
        DailyWeather(
          date: date,
          high: (dailyHighs[i] as num).toDouble(),
          low: (dailyLows[i] as num).toDouble(),
          weatherCode: (dailyCodes[i] as num).toInt(),
        ),
      );
    }

    return WeatherData(
      city: location.name,
      country: location.country,
      temperature: (current['temperature_2m'] as num).toDouble(),
      feelsLike: (current['apparent_temperature'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      highTemperature: dailyHighs.isNotEmpty
          ? (dailyHighs.first as num).toDouble()
          : null,
      lowTemperature: dailyLows.isNotEmpty
          ? (dailyLows.first as num).toDouble()
          : null,
      hourlyForecast: upcomingHours,
      dailyForecast: dailyForecast,
    );
  }

  void dispose() {
    _client.close();
  }
}
