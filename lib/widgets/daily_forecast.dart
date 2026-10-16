import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../theme/app_theme.dart';

class DailyForecast extends StatelessWidget {
  final List<DailyWeather> forecast;

  const DailyForecast({super.key, required this.forecast});

  String _conditionForCode(int code) {
    if (code == 0) return 'Clear';
    if (code == 1) return 'Mostly clear';
    if (code == 2) return 'Partly cloudy';
    if (code == 3) return 'Cloudy';
    if (code == 45 || code == 48) return 'Fog';
    if (code >= 51 && code <= 57) return 'Drizzle';
    if (code >= 61 && code <= 67) return 'Rain';
    if (code >= 71 && code <= 77) return 'Snow';
    if (code >= 80 && code <= 82) return 'Showers';
    if (code == 85 || code == 86) return 'Snow showers';
    if (code >= 95) return 'Thunderstorm';

    return 'Variable';
  }

  IconData _iconForCode(int code) {
    if (code == 0) return Icons.wb_sunny_rounded;
    if (code == 1 || code == 2) return Icons.wb_cloudy_rounded;
    if (code == 3) return Icons.cloud_rounded;
    if (code == 45 || code == 48) return Icons.foggy;
    if (code >= 51 && code <= 67) return Icons.water_drop_rounded;
    if (code >= 71 && code <= 86) return Icons.ac_unit_rounded;
    if (code >= 95) return Icons.thunderstorm_rounded;

    return Icons.cloud_queue_rounded;
  }

  String _dayLabel(DateTime date, int index) {
    if (index == 0) return 'Today';
    if (index == 1) return 'Tomorrow';

    return const [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ][date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    if (forecast.isEmpty) {
      return const Text(
        'Daily forecast is unavailable.',
        style: TextStyle(color: AppTheme.muted),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: List.generate(forecast.length, (index) {
          final item = forecast[index];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: Row(
                  children: [
                    SizedBox(
                      width: 76,
                      child: Text(
                        _dayLabel(item.date, index),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      _iconForCode(item.weatherCode),
                      color: AppTheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _conditionForCode(item.weatherCode),
                        style: const TextStyle(
                          color: AppTheme.muted,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      '${item.high.round()}°',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 32,
                      child: Text(
                        '${item.low.round()}°',
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: AppTheme.muted,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (index < forecast.length - 1)
                const Divider(height: 1, color: Colors.white10),
            ],
          );
        }),
      ),
    );
  }
}
