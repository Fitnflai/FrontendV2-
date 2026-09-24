import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitnflaifrontendv2/models/weather_data.dart';
import 'package:fitnflaifrontendv2/services/location_service.dart';
import 'package:fitnflaifrontendv2/services/cached_http.dart';

class WeatherService {
  final LocationService _locationService = LocationService();
  final String _openMeteoForecastBaseUrl = 'https://api.open-meteo.com/v1/forecast';
  final String _openMeteoGeocodingBaseUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  Future<WeatherData?> fetchWeather({String? profileCity}) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Check SharedPreferences for existing cache
    final cachedTemp = prefs.getString('weather_cache_temp');
    final cachedIcon = prefs.getString('weather_cache_icon');
    final cachedText = prefs.getString('weather_cache_text');
    final cachedTimestampStr = prefs.getString('weather_cache_time');

    if (cachedTemp != null && cachedIcon != null && cachedText != null && cachedTimestampStr != null) {
      final cachedTimestamp = DateTime.parse(cachedTimestampStr);
      final cachedData = WeatherData(
        temp: cachedTemp,
        icon: cachedIcon,
        text: cachedText,
        timestamp: cachedTimestamp,
      );
      if (!cachedData.isExpired) {
        debugPrint('Returning cached weather data.');
        return cachedData;
      }
    }

    // 2. If expired or empty cache, trigger the location fallback chain
    double? latitude;
    double? longitude;

    // Step A: Fetch GPS coordinates from LocationService
    final position = await _locationService.getCurrentPositionWithTimeout();
    if (position != null) {
      latitude = position.latitude;
      longitude = position.longitude;
      debugPrint('Using GPS coordinates: $latitude, $longitude');
    }

    // Step B: If GPS coordinates are null, check profileCity for geocoding
    if (latitude == null && longitude == null && profileCity != null && profileCity.isNotEmpty) {
      try {
        final geocodingUrl = '$_openMeteoGeocodingBaseUrl?name=$profileCity&count=1&language=es&format=json';
        final response = await CachedHttp.get(Uri.parse(geocodingUrl)).timeout(const Duration(seconds: 5));
        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          if (json['results'] != null && json['results'].isNotEmpty) {
            latitude = json['results'][0]['latitude'];
            longitude = json['results'][0]['longitude'];
            debugPrint('Using geocoded coordinates for $profileCity: $latitude, $longitude');
          }
        }
      } catch (e) {
        debugPrint('Error during geocoding for $profileCity: $e');
      }
    }

    // Step C: If both GPS and geocoding fail, fall back to hardcoded Quito coordinates
    if (latitude == null || longitude == null) {
      latitude = -0.1807;
      longitude = -78.4678;
      debugPrint('Falling back to hardcoded Quito coordinates: $latitude, $longitude');
    }

    // 3. Fetch weather from Open-Meteo forecast API
    try {
      final weatherUrl = '$_openMeteoForecastBaseUrl?latitude=$latitude&longitude=$longitude&current=temperature_2m,precipitation,weathercode&timezone=auto';
      final response = await CachedHttp.get(Uri.parse(weatherUrl)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final current = json['current'];
        if (current != null) {
          final temp = current['temperature_2m']?.toString() ?? 'N/A';
          final weatherCode = current['weathercode'] as int?;


          String icon = 'cloud'; // Default icon
          String text = 'Unknown'; // Default text

          if (weatherCode != null) {
            // Simplified mapping for weather codes
            if (weatherCode >= 0 && weatherCode <= 3) {
              icon = 'wb_sunny'; // Clear sky, mainly clear, partly cloudy, overcast
              text = 'Clear';
            } else if (weatherCode >= 45 && weatherCode <= 48) {
              icon = 'foggy'; // Fog and depositing rime fog
              text = 'Foggy';
            } else if (weatherCode >= 51 && weatherCode <= 67) {
              icon = 'rainy'; // Drizzle, rain
              text = 'Rainy';
            } else if (weatherCode >= 71 && weatherCode <= 77) {
              icon = 'ac_unit'; // Snow fall, snow grains
              text = 'Snowy';
            } else if (weatherCode >= 80 && weatherCode <= 82) {
              icon = 'thunderstorm'; // Rain showers
              text = 'Showers';
            } else if (weatherCode >= 85 && weatherCode <= 86) {
              icon = 'snowing'; // Snow showers
              text = 'Snow showers';
            } else if (weatherCode >= 95 && weatherCode <= 99) {
              icon = 'thunderstorm'; // Thunderstorm
              text = 'Thunderstorm';
            }
          }

          final weatherData = WeatherData(
            temp: temp,
            icon: icon,
            text: text,
            timestamp: DateTime.now(),
          );

          // 5. Save to SharedPreferences cache
          await prefs.setString('weather_cache_temp', weatherData.temp);
          await prefs.setString('weather_cache_icon', weatherData.icon);
          await prefs.setString('weather_cache_text', weatherData.text);
          await prefs.setString('weather_cache_time', weatherData.timestamp.toIso8601String());
          debugPrint('Weather data fetched and cached.');
          return weatherData;
        }
      }
      debugPrint('Failed to fetch weather data. Status code: ${response.statusCode}');
    } catch (e) {
      debugPrint('Error fetching weather data: $e');
    }
    return null;
  }
}
