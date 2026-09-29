import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:fitnflaifrontendv2/services/health/base_health_service.dart';
import 'package:fitnflaifrontendv2/services/health/health_data_model.dart';
import 'package:intl/intl.dart';

class AndroidHealthConnectService implements BaseHealthService {
  final Health _health = Health();
  bool _isConfigured = false;

  Future<void> _ensureConfigured() async {
    if (!_isConfigured) {
      try {
        await _health.configure();
        _isConfigured = true;
      } catch (e) {
        debugPrint('Error configuring Health Connect: $e');
      }
    }
  }

  final List<HealthDataType> _types = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.DISTANCE_DELTA,
  ];

  @override
  String get providerId => 'health_connect';

  @override
  Future<bool> checkAvailability() async {
    await _ensureConfigured();
    return true;
  }

  @override
  Future<bool> requestPermissions() async {
    await _ensureConfigured();
    // Health().requestAuthorization will return false if permissions are already granted and no dialog is shown.
    // It's generally good practice to check permissions first, then request only if needed.
    // For this task, we directly call requestAuthorization.
    return await _health.requestAuthorization(_types);
  }

  @override
  Future<Map<String, dynamic>?> fetchSyncData(DateTime date) async {
    try {
      await _ensureConfigured();
      final startDate = DateFormat('yyyy-MM-dd').parse(DateFormat('yyyy-MM-dd').format(date)); // Start of the day
      final endDate = startDate.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1)); // End of the day

      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        types: _types,
        startTime: startDate,
        endTime: endDate,
      );

      int pasos = 0;
      double caloriasQuemadas = 0.0;
      double distanciaKm = 0.0;

      for (var dp in healthData) {
        switch (dp.type) {
          case HealthDataType.STEPS:
            pasos += (dp.value as num).toInt();
            break;
          case HealthDataType.ACTIVE_ENERGY_BURNED:
            caloriasQuemadas += (dp.value as num).toDouble();
            break;
          case HealthDataType.DISTANCE_DELTA:
            distanciaKm += (dp.value as num).toDouble() / 1000; // Convert meters to km
            break;
          default:
            break;
        }
      }

      final normalizedData = HealthDataModel(
        fecha: DateFormat('yyyy-MM-dd').format(date),
        pasos: pasos,
        caloriasQuemadas: caloriasQuemadas,
        distanciaKm: distanciaKm,
        ritmoCardiacoPromedio: 0.0,
        ritmoCardiacoReposo: 0.0,
        pesoKg: 0.0,
        horasSueno: 0.0,
        fuente: providerId,
        fcReposo: 0.0,
        workouts: [],
      );

      return normalizedData.toMap();
    } catch (e) {
      debugPrint('Error fetching Health Connect data: $e');
      return null;
    }
  }

  @override
  Future<void> disconnect() async {
    await _health.revokePermissions();
  }
}
