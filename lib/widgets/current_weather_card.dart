import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../theme/app_theme.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherData weather;

  const CurrentWeatherCard({super.key, required this.weather});

  String get _condition {
    final code = weather.weatherCode;

    if (code == 0) return 'Clear sky';
    if (code == 1) return 'Mainly clear';
    if (code == 2) return 'Partly cloudy';
    if (code == 3) return 'Overcast';
    if (code == 45 || code == 48) return 'Foggy';
    if (code >= 51 && code <= 57) return 'Drizzle';
    if (code >= 61 && code <= 67) return 'Rain';
    if (code >= 71 && code <= 77) return 'Snow';
    if (code >= 80 && code <= 82) return 'Rain showers';
    if (code == 85 || code == 86) return 'Snow showers';
    if (code >= 95) return 'Thunderstorm';

    return 'Weather conditions';
  }

  IconData get _weatherIcon {
    final code = weather.weatherCode;

    if (code == 0) return Icons.wb_sunny_rounded;
    if (code == 1 || code == 2) return Icons.wb_cloudy_rounded;
    if (code == 3) return Icons.cloud_rounded;
    if (code == 45 || code == 48) return Icons.foggy;
    if (code >= 51 && code <= 67) return Icons.water_drop_rounded;
    if (code >= 71 && code <= 86) return Icons.ac_unit_rounded;
    if (code >= 95) return Icons.thunderstorm_rounded;

    return Icons.cloud_queue_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF263D70), Color(0xFF172541), Color(0xFF151D33)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: AppTheme.primary,
                size: 18,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${weather.city}, ${weather.country}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.public_rounded, color: AppTheme.muted),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.temperature.round()}°',
                      style: const TextStyle(
                        fontSize: 76,
                        height: 1.05,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _condition,
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Feels like ${weather.feelsLike.round()}°',
                      style: const TextStyle(
                        color: AppTheme.muted,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(_weatherIcon, size: 100, color: AppTheme.primary),
            ],
          ),
          const SizedBox(height: 28),
          const Divider(color: Colors.white12),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _WeatherMetric(
                  icon: Icons.water_drop_outlined,
                  label: 'Humidity',
                  value: '${weather.humidity.round()}%',
                ),
              ),
              Expanded(
                child: _WeatherMetric(
                  icon: Icons.air_rounded,
                  label: 'Wind speed',
                  value: '${weather.windSpeed.round()} km/h',
                ),
              ),
              Expanded(
                child: _WeatherMetric(
                  icon: Icons.thermostat_rounded,
                  label: 'High / Low',
                  value:
                      '${weather.highTemperature?.round() ?? '--'}° / '
                      '${weather.lowTemperature?.round() ?? '--'}°',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeatherMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.primary, size: 21),
        const SizedBox(height: 9),
        Text(
          label,
          style: const TextStyle(color: AppTheme.muted, fontSize: 11),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
