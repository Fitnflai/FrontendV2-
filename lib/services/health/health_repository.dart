
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitnflaifrontendv2/services/auth_service.dart';
import 'package:fitnflaifrontendv2/services/health/base_health_service.dart';
import 'package:fitnflaifrontendv2/services/health/android_health_connect_service.dart';
import 'package:fitnflaifrontendv2/services/health/apple_health_kit_service.dart';
import 'package:fitnflaifrontendv2/services/health/huawei_health_service.dart';
import 'package:fitnflaifrontendv2/services/cached_http.dart'; // Assuming this exists for backend communication

enum HealthProviderType {
  none,
  healthConnect,
  healthKit,
  huaweiHealth,
}

extension HealthProviderTypeExtension on HealthProviderType {
  String get id {
    switch (this) {
      case HealthProviderType.healthConnect:
        return 'health_connect';
      case HealthProviderType.healthKit:
        return 'health_kit';
      case HealthProviderType.huaweiHealth:
        return 'huawei_health';
      case HealthProviderType.none:
        return 'none';
    }
  }
}

class HealthRepository {
  BaseHealthService? _activeHealthService;
  HealthProviderType _activeProviderType = HealthProviderType.none;

  HealthProviderType get activeProviderType => _activeProviderType;

  HealthRepository() {
    _initializeActiveService();
  }

  Future<void> _initializeActiveService() async {
    final prefs = await SharedPreferences.getInstance();
    final savedProviderId = prefs.getString('health_connected_provider') ?? 'none';
    _activeProviderType = HealthProviderType.values.firstWhere(
      (e) => e.id == savedProviderId,
      orElse: () => HealthProviderType.none,
    );

    if (_activeProviderType != HealthProviderType.none) {
      debugPrint('Initializing active health service: ${_activeProviderType.id}');
      _activeHealthService = _getServiceForProvider(_activeProviderType);
    }
  }

  BaseHealthService? _getServiceForProvider(HealthProviderType providerType) {
    switch (providerType) {
      case HealthProviderType.healthConnect:
        return AndroidHealthConnectService();
      case HealthProviderType.healthKit:
        return AppleHealthKitService();
      case HealthProviderType.huaweiHealth:
        return HuaweiHealthService();
      case HealthProviderType.none:
        return null;
    }
  }

  Future<bool> checkAvailability(HealthProviderType providerType) async {
    if (providerType == HealthProviderType.none) return false;
    final service = _getServiceForProvider(providerType);
    return service?.checkAvailability() ?? Future.value(false);
  }

  Future<bool> requestPermissions(HealthProviderType providerType) async {
    if (providerType == HealthProviderType.none) return false;
    final service = _getServiceForProvider(providerType);
    final granted = await service?.requestPermissions() ?? false;
    if (granted) {
      _activeHealthService = service;
      _activeProviderType = providerType;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('health_connected_provider', providerType.id);
    }
    return granted;
  }

  Future<void> disconnect() async {
    await _activeHealthService?.disconnect();
    _activeHealthService = null;
    _activeProviderType = HealthProviderType.none;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('health_connected_provider');
  }

  // Deduplication priority: Health Connect/HealthKit > Garmin > Strava > Huawei Health
  // For this implementation, we prioritize Health Connect/HealthKit over Huawei Health
  Future<Map<String, dynamic>?> fetchAndDeduplicateData(DateTime date) async {
    if (_activeHealthService == null) {
      debugPrint('No active health service to fetch data.');
      return null;
    }

    final Map<String, dynamic>? healthData = await _activeHealthService?.fetchSyncData(date);

    if (healthData == null) {
      debugPrint('No health data fetched from active service.');
      return null;
    }

    try {
      final token = await AuthService().getToken();

      final response = await CachedHttp.post(
        Uri.parse('https://apifitnflai.com/health-service-integration/sync-health'),
        body: jsonEncode({
          'fecha': healthData['fecha'],
          'pasos': healthData['pasos'] as int? ?? 0,
          'calorias_quemadas': (healthData['calorias_quemadas'] as num?)?.toDouble() ?? 0.0,
          'distancia_km': (healthData['distancia_km'] as num?)?.toDouble() ?? 0.0,
          'ritmo_cardiaco_promedio': (healthData['ritmo_cardiaco_promedio'] as num?)?.toDouble() ?? 0.0,
          'ritmo_cardiaco_reposo': (healthData['ritmo_cardiaco_reposo'] as num?)?.toDouble() ?? 0.0,
          'peso_kg': (healthData['peso_kg'] as num?)?.toDouble() ?? 0.0,
          'horas_sueno': (healthData['horas_sueno'] as num?)?.toDouble() ?? 0.0,
          'fuente': healthData['fuente'] ?? 'none',
          'fc_reposo': (healthData['fc_reposo'] as num?)?.toDouble() ?? 0.0,
        }),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Health data successfully synced to backend.');
        return healthData;
      } else {
        debugPrint('Failed to sync health data to backend: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error syncing health data to backend: $e');
      return null;
    }
  }

  // This method will be used by the UI to initiate connection
  Future<bool> connect(HealthProviderType providerType) async {
    if (await checkAvailability(providerType)) {
      // Check for mutual exclusivity
      if (_activeProviderType != HealthProviderType.none && _activeProviderType != providerType) {
        debugPrint('Disconnecting previous health provider: ${(_activeProviderType).id} for strict mutual exclusivity.');
        await disconnect();
      }

      if (await requestPermissions(providerType)) {
        debugPrint('${providerType.id} connected successfully.');
        return true;
      } else {
        debugPrint('Permissions not granted for ${providerType.id}.');
      }
    } else {
      debugPrint('${providerType.id} not available on this device.');
    }
    return false;
  }
}
