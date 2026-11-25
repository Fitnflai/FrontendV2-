import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitnflaifrontendv2/providers/health_provider.dart';
import 'package:fitnflaifrontendv2/services/health/health_repository.dart';

class MockHealthRepository extends HealthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('HealthProvider Hierarchy & Deduplication Rules', () {
    test('Rule 1: Strict Hierarchy - Garmin (Tier 1) takes precedence over Strava and Local', () async {
      final repo = MockHealthRepository();
      final provider = HealthProvider(repo);
      await Future.delayed(Duration.zero);

      provider.setExternalConnectedStatus(garmin: true, strava: true);

      // Garmin has steps 8000 and HR 135
      // Strava has distance 10 and calories 500
      // Local has steps 3000 and HR 75
      provider.updateConsolidatedData(
        localData: {
          'pasos': 3000,
          'ritmo_cardiaco_promedio': 75.0,
          'distancia_km': 2.5,
          'calorias_quemadas': 150.0,
        },
        backendSummary: {
          'fuentes': ['garmin', 'strava'],
          'garmin': {
            'pasos': 8000,
            'ritmo_cardiaco_promedio': 135.0,
            'distancia_km': 6.0,
            'calorias': 400.0,
          },
          'strava': {
            'pasos': 0,
            'ritmo_cardiaco_promedio': 145.0,
            'distancia_km': 15.0,
            'calorias': 650.0,
          },
        },
      );

      // Values must come from Garmin (Tier 1), NOT summed!
      expect(provider.steps, equals(8000));
      expect(provider.heartRate, equals(135.0));
      expect(provider.distance, equals(6.0));
      expect(provider.calories, equals(400.0));
    });

    test('Rule 2: Fallback (Coalescence) - If Tier 1 has null/0, falls back to Tier 2 (Strava)', () async {
      final repo = MockHealthRepository();
      final provider = HealthProvider(repo);
      await Future.delayed(Duration.zero);

      provider.setExternalConnectedStatus(garmin: true, strava: true);

      // Garmin has steps 5000, but HR is 0 (missing)
      // Strava has HR 140 and distance 12.0
      // Local has HR 80
      provider.updateConsolidatedData(
        localData: {
          'pasos': 2000,
          'ritmo_cardiaco_promedio': 80.0,
        },
        backendSummary: {
          'fuentes': ['garmin', 'strava'],
          'garmin': {
            'pasos': 5000,
            'ritmo_cardiaco_promedio': 0.0, // null/missing in Garmin
          },
          'strava': {
            'ritmo_cardiaco_promedio': 140.0, // Available in Strava
            'distancia_km': 12.0,
          },
        },
      );

      // Steps come from Garmin (5000)
      expect(provider.steps, equals(5000));
      // Heart rate fell back to Strava (140.0)
      expect(provider.heartRate, equals(140.0));
      // Distance fell back to Strava (12.0)
      expect(provider.distance, equals(12.0));
    });

    test('Rule 3: Fallback to Tier 3 (Local Provider) when Garmin and Strava are null/0', () async {
      final repo = MockHealthRepository();

      // Connect local provider in SharedPreferences
      SharedPreferences.setMockInitialValues({
        'health_connected_provider': 'health_connect',
      });
      final providerWithLocal = HealthProvider(repo);
      await Future.delayed(Duration.zero);

      providerWithLocal.setExternalConnectedStatus(garmin: true, strava: false);

      // Garmin has 0 steps and 0 HR today
      // Local Health Connect has 4500 steps and 72 bpm HR
      providerWithLocal.updateConsolidatedData(
        localData: {
          'pasos': 4500,
          'ritmo_cardiaco_promedio': 72.0,
          'distancia_km': 3.2,
          'calorias_quemadas': 220.0,
        },
        backendSummary: {
          'fuentes': [],
          'total_actividades': 0,
          'tiene_pasos': false,
          'pasos_dia': 0,
        },
      );

      // Should fall back to local health provider
      expect(providerWithLocal.steps, equals(4500));
      expect(providerWithLocal.heartRate, equals(72.0));
      expect(providerWithLocal.distance, equals(3.2));
      expect(providerWithLocal.calories, equals(220.0));
    });

    test('Rule 4: Flat backendSummary with Garmin daily steps takes Tier 1 priority', () async {
      final repo = MockHealthRepository();
      final provider = HealthProvider(repo);
      await Future.delayed(Duration.zero);

      provider.setExternalConnectedStatus(garmin: true, strava: false);

      // Flat summary from Garmin webhook sync
      provider.updateConsolidatedData(
        localData: {
          'pasos': 1200,
          'ritmo_cardiaco_promedio': 65.0,
        },
        backendSummary: {
          'tiene_pasos': true,
          'pasos_dia': 9500, // Garmin steps
          'distancia_total_km': 7.5,
          'frecuencia_cardiaca_promedio': 130.0,
          'calorias_actividad': 480.0,
          'fuentes': ['garmin'],
          'total_actividades': 1,
        },
      );

      // Must take Garmin's values over local
      expect(provider.steps, equals(9500));
      expect(provider.heartRate, equals(130.0));
      expect(provider.distance, equals(7.5));
      expect(provider.calories, equals(480.0));
    });

    test('Rule 5: Tolerant key extraction takes resting or most recent heart rate from Garmin/local', () async {
      final repo = MockHealthRepository();
      final provider = HealthProvider(repo);
      await Future.delayed(Duration.zero);

      provider.setExternalConnectedStatus(garmin: true, strava: false);

      // Garmin sends fc_reposo = 41 bpm without workout average
      provider.updateConsolidatedData(
        localData: {
          'pasos': 1000,
          'frecuencia_cardiaca_reposo': 56.0,
        },
        backendSummary: {
          'fuentes': ['garmin'],
          'garmin': {
            'pasos': 2887,
            'fc_reposo': 41.0,
          },
        },
      );

      // Must resolve Garmin steps and Garmin resting heart rate 41
      expect(provider.steps, equals(2887));
      expect(provider.heartRate, equals(41.0));
    });
  });
}
