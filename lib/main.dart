import 'package:flutter/material.dart';

import 'screens/weather_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const WeatherForecastApp());
}

class WeatherForecastApp extends StatelessWidget {
  const WeatherForecastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Forecast',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const WeatherScreen(),
    );
  }
}
