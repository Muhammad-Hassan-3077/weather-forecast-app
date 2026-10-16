
import 'dart:async';

import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../theme/app_theme.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/daily_forecast.dart';
import '../widgets/hourly_forecast.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _searchController = TextEditingController();

  WeatherData? _weather;
  CityLocation? _selectedLocation;
  CityLocation? _previousLocation;

  List<CityLocation> _cities = [];

  bool _isLoading = false;
  bool _isSearching = false;
  String? _error;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadDefaultCity();
  }

  Future<void> _loadDefaultCity() async {
    try {
      final cities = await _weatherService.searchCities('Lahore');

      if (!mounted) return;

      if (cities.isNotEmpty) {
        final lahore = cities.firstWhere(
              (city) => city.name.toLowerCase() == 'lahore',
          orElse: () => cities.first,
        );
        await _selectCity(lahore, rememberPrevious: false);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Unable to load weather. Check your internet connection.';
      });
    }
  }

  Future<void> _searchCity(String query) async {
    if (query.trim().length < 2) return;

    setState(() {
      _isSearching = true;
      _error = null;
      _cities = [];
    });

    try {
      final results = await _weatherService.searchCities(query);

      if (!mounted) return;

      setState(() {
        _cities = results;
        _isSearching = false;

        if (results.isEmpty) {
          _error = 'No matching city found. Try another name.';
        }
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isSearching = false;
        _error = 'City search failed. Check your internet connection.';
      });
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    setState(() {
      _cities = [];
      _error = null;
    });

    if (value.trim().length < 2) return;

    _debounce = Timer(
      const Duration(milliseconds: 500),
          () => _searchCity(value),
    );
  }

  Future<void> _selectCity(
      CityLocation city, {
        bool rememberPrevious = true,
      }) async {
    FocusScope.of(context).unfocus();

    final oldLocation = _selectedLocation;

    setState(() {
      if (rememberPrevious &&
          oldLocation != null &&
          (oldLocation.latitude != city.latitude ||
              oldLocation.longitude != city.longitude)) {
        _previousLocation = oldLocation;
      }

      _selectedLocation = city;
      _isLoading = true;
      _isSearching = false;
      _error = null;
      _cities = [];
      _searchController.text = city.name;
    });

    try {
      final result = await _weatherService.getWeather(city);

      if (!mounted) return;

      setState(() {
        _weather = result;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = 'Unable to load weather. Please try again.';
      });
    }
  }

  Future<void> _goBackToPreviousCity() async {
    final previous = _previousLocation;
    if (previous == null) return;

    final current = _selectedLocation;

    setState(() {
      _previousLocation = current;
    });

    await _selectCity(previous, rememberPrevious: false);
  }

  void _clearSearch() {
    _debounce?.cancel();
    _searchController.clear();
    FocusScope.of(context).unfocus();

    setState(() {
      _cities = [];
      _error = null;
      _isSearching = false;
    });
  }

  Future<void> _refreshWeather() async {
    final location = _selectedLocation;
    if (location == null || _isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await _weatherService.getWeather(location);

      if (!mounted) return;

      setState(() {
        _weather = result;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = 'Refresh failed. Check your connection and try again.';
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _weatherService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: _previousLocation == null
            ? null
            : IconButton(
          tooltip: 'Back to previous city',
          onPressed: _isLoading ? null : _goBackToPreviousCity,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Row(
          children: [
            Icon(Icons.cloud_rounded, color: AppTheme.primary),
            SizedBox(width: 10),
            Text(
              'Weatherly',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh weather',
            onPressed: _isLoading ? null : _refreshWeather,
            icon: _isLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    onSubmitted: _searchCity,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Search for a city...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_searchController.text.isNotEmpty)
                            IconButton(
                              tooltip: 'Clear search',
                              onPressed: _clearSearch,
                              icon: const Icon(Icons.close_rounded),
                            ),
                          IconButton(
                            tooltip: 'Search city',
                            onPressed: () =>
                                _searchCity(_searchController.text),
                            icon: const Icon(Icons.arrow_forward_rounded),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_isSearching)
                  const LinearProgressIndicator(minHeight: 2),
                if (_cities.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _cities.length,
                      itemBuilder: (context, index) {
                        final city = _cities[index];

                        return ListTile(
                          leading: const Icon(
                            Icons.location_on_outlined,
                            color: AppTheme.primary,
                          ),
                          title: Text(city.name),
                          subtitle: Text(city.displayName),
                          onTap: () => _selectCity(city),
                        );
                      },
                    ),
                  ),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading && _weather == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _weather == null) {
      return _buildError();
    }

    if (_weather == null) {
      return const Center(
        child: Text(
          'Search for a city to see its weather.',
          style: TextStyle(color: AppTheme.muted),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshWeather,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          const Text(
            'WEATHER OVERVIEW',
            style: TextStyle(
              color: AppTheme.muted,
              letterSpacing: 2,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          CurrentWeatherCard(weather: _weather!),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: const TextStyle(color: Colors.orangeAccent),
            ),
          ],
          const SizedBox(height: 28),
          const Text(
            'Hourly Forecast',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          HourlyForecast(forecast: _weather!.hourlyForecast),
          const SizedBox(height: 28),
          const Text(
            '7-Day Forecast',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          DailyForecast(forecast: _weather!.dailyForecast),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              'Weather data provided by Open-Meteo',
              style: TextStyle(color: AppTheme.muted, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 54,
              color: AppTheme.muted,
            ),
            const SizedBox(height: 16),
            Text(
              _error ?? 'Something went wrong.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.muted),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _selectedLocation == null
                  ? _loadDefaultCity()
                  : _refreshWeather(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
