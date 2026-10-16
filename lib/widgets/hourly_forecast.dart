
import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../theme/app_theme.dart';

class HourlyForecast extends StatefulWidget {
  final List<HourlyWeather> forecast;

  const HourlyForecast({
    super.key,
    required this.forecast,
  });

  @override
  State<HourlyForecast> createState() => _HourlyForecastState();
}

class _HourlyForecastState extends State<HourlyForecast> {
  int _selectedIndex = 0;

  @override
  void didUpdateWidget(covariant HourlyForecast oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.forecast != widget.forecast) {
      _selectedIndex = 0;
    }
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

  String _conditionForCode(int code) {
    if (code == 0) return 'Clear sky';
    if (code == 1) return 'Mainly clear';
    if (code == 2) return 'Partly cloudy';
    if (code == 3) return 'Overcast';
    if (code == 45 || code == 48) return 'Fog';
    if (code >= 51 && code <= 57) return 'Drizzle';
    if (code >= 61 && code <= 67) return 'Rain';
    if (code >= 71 && code <= 77) return 'Snow';
    if (code >= 80 && code <= 82) return 'Rain showers';
    if (code == 85 || code == 86) return 'Snow showers';
    if (code >= 95) return 'Thunderstorm';

    return 'Variable';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.forecast.isEmpty) {
      return const Text(
        'Hourly forecast is unavailable.',
        style: TextStyle(color: AppTheme.muted),
      );
    }

    final safeIndex = _selectedIndex.clamp(0, widget.forecast.length - 1);
    final selected = widget.forecast[safeIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 150,
          child: Scrollbar(
            thumbVisibility: true,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: widget.forecast.length,
              separatorBuilder: (context, index) =>
              const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = widget.forecast[index];
                final isSelected = index == safeIndex;

                return SizedBox(
                  width: 88,
                  child: Material(
                    color: isSelected
                        ? AppTheme.primary.withValues(alpha: 0.14)
                        : AppTheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primary
                                : Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              index == 0
                                  ? 'Now'
                                  : TimeOfDay.fromDateTime(item.time)
                                  .format(context),
                              style: TextStyle(
                                color: isSelected
                                    ? AppTheme.primary
                                    : AppTheme.muted,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(
                              _iconForCode(item.weatherCode),
                              color: AppTheme.primary,
                              size: 27,
                            ),
                            Text(
                              '${item.temperature.round()}°',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Icon(
                _iconForCode(selected.weatherCode),
                color: AppTheme.primary,
                size: 32,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TimeOfDay.fromDateTime(selected.time).format(context),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _conditionForCode(selected.weatherCode),
                      style: const TextStyle(
                        color: AppTheme.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${selected.temperature.round()}°',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
