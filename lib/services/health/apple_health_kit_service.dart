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
    HealthDataType.HEART_RATE,
    HealthDataType.SLEEP_IN_BED,
    HealthDataType.WEIGHT,
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
      'ritmo_cardiaco_promedio': <double>[],
      'ritmo_cardiaco_reposo': <double>[],
      'peso_kg': 0.0,
      'horas_sueno': 0.0,
    };
    int weightCount = 0;

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
        case HealthDataType.HEART_RATE:
                    accumulatedData['ritmo_cardiaco_promedio'].add((dataPoint.value as num).toDouble());
          break;
        case HealthDataType.SLEEP_IN_BED:
          if (dataPoint.value is Duration) {
            final duration = (dataPoint.value as Duration).inMinutes;
            accumulatedData['horas_sueno'] += duration / 60;
          }
          break;
        case HealthDataType.WEIGHT:
                    accumulatedData['peso_kg'] += (dataPoint.value as num).toDouble(); // Assuming value is already in kg
          weightCount++;
          break;
        default:
          break;
      }
    }

    // Calculate averages
    if (accumulatedData['ritmo_cardiaco_promedio'].isNotEmpty) {
      double sumHeartRate = accumulatedData['ritmo_cardiaco_promedio'].fold(0.0, (prev, element) => prev + element);
      accumulatedData['ritmo_cardiaco_promedio'] = sumHeartRate / accumulatedData['ritmo_cardiaco_promedio'].length;
    } else {
      accumulatedData['ritmo_cardiaco_promedio'] = 0.0;
    }

    if (weightCount > 0) {
      accumulatedData['peso_kg'] = accumulatedData['peso_kg'] / weightCount;
    } else {
      accumulatedData['peso_kg'] = 0.0;
    }
    
    // For sleep in bed, ensure it's in hours
    // The health package returns sleep data in minutes, so convert to hours
    // If the dataPoint.value was already hours, this will over-convert.
    // It's safer to check the unit of HealthDataPoint if possible, but the `health` package usually gives minutes for sleep.
    // Assuming for now it returns in minutes and we convert it to hours.
    accumulatedData['horas_sueno'] = accumulatedData['horas_sueno'] / 60.0;


    // Create HealthDataModel instance
    final healthDataModel = HealthDataModel(
      fecha: DateFormat('yyyy-MM-dd').format(date),
      pasos: accumulatedData['pasos'],
      caloriasQuemadas: accumulatedData['calorias_quemadas'],
      distanciaKm: accumulatedData['distancia_km'],
      ritmoCardiacoPromedio: accumulatedData['ritmo_cardiaco_promedio'],
      ritmoCardiacoReposo: 0.0, // HealthKit doesn't directly provide resting heart rate easily in one go
      pesoKg: accumulatedData['peso_kg'],
      horasSueno: accumulatedData['horas_sueno'],
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
