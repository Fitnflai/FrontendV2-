import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:fitnflaifrontendv2/services/health/base_health_service.dart';
import 'package:fitnflaifrontendv2/services/health/health_data_model.dart';
import 'package:intl/intl.dart'; // For date formatting

class AppleHealthKitService implements BaseHealthService {
  final Health _health = Health();
  bool _isConfigured = false;

  Future<void> _ensureConfigured() async {
    if (!_isConfigured) {
      try {
        await _health.configure();
        _isConfigured = true;
      } catch (e) {
        debugPrint('Error configuring HealthKit: $e');
      }
    }
  }
  
  final List<HealthDataType> _types = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.DISTANCE_DELTA,
  ];

  @override
  String get providerId => 'health_kit';

  @override
  Future<bool> checkAvailability() async {
    await _ensureConfigured();
    return true;
  }

  @override
  Future<bool> requestPermissions() async {
    await _ensureConfigured();
    return _health.requestAuthorization(_types); // Use just types for request, permissions are implied by access level
  }

  @override
  Future<Map<String, dynamic>?> fetchSyncData(DateTime date) async {
    await _ensureConfigured();
    final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    List<HealthDataPoint> healthData = [];
    try {
      healthData = await _health.getHealthDataFromTypes(
        startTime: startOfDay,
        endTime: endOfDay,
        types: _types,
      );
    } catch (e) {
      debugPrint("Error fetching HealthKit data: $e");
      return null;
    }

    // Accumulate data for normalization
    Map<String, dynamic> accumulatedData = {
      'pasos': 0,
      'calorias_quemadas': 0.0,
      'distancia_km': 0.0,
    };

    for (HealthDataPoint dataPoint in healthData) {
      switch (dataPoint.type) {
        case HealthDataType.STEPS:
          accumulatedData['pasos'] += (dataPoint.value as num).toInt();
          break;
        case HealthDataType.ACTIVE_ENERGY_BURNED:
          accumulatedData['calorias_quemadas'] += (dataPoint.value as num).toDouble();
          break;
        case HealthDataType.DISTANCE_DELTA:
          accumulatedData['distancia_km'] += (dataPoint.value as num).toDouble() / 1000; // meters to km
          break;
        default:
          break;
      }
    }


    // Create HealthDataModel instance
    final healthDataModel = HealthDataModel(
      fecha: DateFormat('yyyy-MM-dd').format(date),
      pasos: accumulatedData['pasos'],
      caloriasQuemadas: accumulatedData['calorias_quemadas'],
      distanciaKm: accumulatedData['distancia_km'],
      ritmoCardiacoPromedio: 0.0,
      ritmoCardiacoReposo: 0.0, // HealthKit doesn't directly provide resting heart rate easily in one go
      pesoKg: 0.0,
      horasSueno: 0.0,
      fuente: providerId,
      fcReposo: 0.0, // Same as above
    );

        return healthDataModel.toMap();
  }

  @override
  Future<void> disconnect() async {
    // HealthKit does not have a direct "disconnect" API like Health Connect.
    // Revoking permissions is the closest equivalent.
    // However, revokePermissions is for specific types. A full disconnect
    // would imply revoking all previously granted permissions.
    // For simplicity, we'll revoke all registered types.
    await _health.revokePermissions();
  }
}
