class WeatherData {
  final String city;
  final String country;
  final double temperature;
  final double feelsLike;
  final double humidity;
  final double windSpeed;
  final int weatherCode;
  final double? highTemperature;
  final double? lowTemperature;
  final List<HourlyWeather> hourlyForecast;
  final List<DailyWeather> dailyForecast;

  const WeatherData({
    required this.city,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    this.highTemperature,
    this.lowTemperature,
    this.hourlyForecast = const [],
    this.dailyForecast = const [],
  });
}

class HourlyWeather {
  final DateTime time;
  final double temperature;
  final int weatherCode;

  const HourlyWeather({
    required this.time,
    required this.temperature,
    required this.weatherCode,
  });
}

class DailyWeather {
  final DateTime date;
  final double high;
  final double low;
  final int weatherCode;

  const DailyWeather({
    required this.date,
    required this.high,
    required this.low,
    required this.weatherCode,
  });
}

class CityLocation {
  final String name;
  final String country;
  final String? admin1;
  final double latitude;
  final double longitude;

  const CityLocation({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.admin1,
  });

  String get displayName {
    if (admin1 != null && admin1!.isNotEmpty) {
      return '$name, $admin1, $country';
    }
    return '$name, $country';
  }
}
