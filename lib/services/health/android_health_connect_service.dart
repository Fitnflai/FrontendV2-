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
    HealthDataType.HEART_RATE,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.WEIGHT,
  ];

  @override
  String get providerId => 'health_connect';

  @override
  Future<bool> checkAvailability() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }
    await _ensureConfigured();
    return true;
  }

  @override
  Future<bool> requestPermissions() async {
    await _ensureConfigured();
    final permissions = List.filled(_types.length, HealthDataAccess.READ);
    try {
      final hasPerm = await _health.hasPermissions(_types, permissions: permissions) ?? false;
      if (hasPerm) {
        debugPrint('Health Connect permissions already granted.');
        return true;
      }
    } catch (e) {
      debugPrint('Error checking Health Connect permissions: $e');
    }
    return await _health.requestAuthorization(_types, permissions: permissions);
  }

  double _getNumericValue(HealthValue value) {
    if (value is NumericHealthValue) {
      return value.numericValue.toDouble();
    }
    try {
      return (value as dynamic).numericValue.toDouble();
    } catch (_) {
      try {
        return double.parse(value.toString());
      } catch (_) {
        return 0.0;
      }
    }
  }

  @override
  Future<Map<String, dynamic>?> fetchSyncData(DateTime date) async {
    try {
      await _ensureConfigured();
      final startDate = DateFormat('yyyy-MM-dd').parse(DateFormat('yyyy-MM-dd').format(date)); // Start of the day
      final endDate = startDate.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1)); // End of the day

      List<HealthDataPoint> healthData = [];
      for (var type in _types) {
        try {
          final data = await _health.getHealthDataFromTypes(
            types: [type],
            startTime: startDate,
            endTime: endDate,
          );
          healthData.addAll(data);
        } catch (e) {
          debugPrint('Error fetching Health Connect data for type $type: $e');
        }
      }

      int pasos = 0;
      double caloriasQuemadas = 0.0;
      double distanciaKm = 0.0;
      List<double> heartRates = [];
      double pesoKg = 0.0;
      double horasSueno = 0.0;

      for (var dp in healthData) {
        switch (dp.type) {
          case HealthDataType.STEPS:
            pasos += _getNumericValue(dp.value).toInt();
            break;
          case HealthDataType.ACTIVE_ENERGY_BURNED:
            caloriasQuemadas += _getNumericValue(dp.value);
            break;
          case HealthDataType.DISTANCE_DELTA:
            distanciaKm += _getNumericValue(dp.value) / 1000; // Convert meters to km
            break;
          case HealthDataType.HEART_RATE:
            heartRates.add(_getNumericValue(dp.value));
            break;
          case HealthDataType.WEIGHT:
            pesoKg = _getNumericValue(dp.value);
            break;
          case HealthDataType.SLEEP_SESSION:
            final diff = dp.dateTo.difference(dp.dateFrom).inMinutes;
            horasSueno += diff / 60.0;
            break;
          default:
            break;
        }
      }

      double ritmoCardiacoPromedio = 0.0;
      double ritmoCardiacoReposo = 0.0;
      if (heartRates.isNotEmpty) {
        ritmoCardiacoPromedio = heartRates.reduce((a, b) => a + b) / heartRates.length;
        ritmoCardiacoReposo = heartRates.reduce((a, b) => a < b ? a : b);
      }

      final normalizedData = HealthDataModel(
        fecha: DateFormat('yyyy-MM-dd').format(date),
        pasos: pasos,
        caloriasQuemadas: caloriasQuemadas,
        distanciaKm: distanciaKm,
        ritmoCardiacoPromedio: ritmoCardiacoPromedio,
        ritmoCardiacoReposo: ritmoCardiacoReposo,
        pesoKg: pesoKg,
        horasSueno: horasSueno,
        fuente: providerId,
        fcReposo: ritmoCardiacoReposo,
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
