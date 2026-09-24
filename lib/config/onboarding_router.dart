import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../config/app_routes.dart';
import '../models/usuario.dart'; // Corrected import

class OnboardingRouter {
  static const String _onboardingCompletedStepKey = 'onboarding_completed_step_';

  static Future<String> getOnboardingTargetRoute(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    if (auth.status != AuthStatus.authenticated) {
      return AppRoutes.welcome;
    }

    final String? token = auth.token;
    final String? userId = auth.user?.id;

    if (userId == null || token == null) {
      return AppRoutes.welcome;
    }

    // Force profile reload and user refresh in parallel to avoid startup race conditions
    try {
      await Future.wait([
        Provider.of<ProfileProvider>(context, listen: false).loadAll(token),
        auth.refreshUser(),
      ]);
    } catch (e) {
      debugPrint('Error reloading profile or user: $e');
      return AppRoutes.welcome;
    }

    final Usuario? user = auth.user;

    if (user == null) {
      return AppRoutes.welcome;
    }

    if (user.onboardingCompleto) {
      return AppRoutes.home;
    }

    int backendDeducedStep = 0; // Default to PARQ (Step 1)

    // Step 1: PARQ
    if (profileProvider.parqStatus != 'CLEAR' && profileProvider.parqStatus != 'WARNING') {
      backendDeducedStep = 0;
    }
    // Step 2: Profile
    else if (user.genero == null || user.genero!.isEmpty || user.ciudad == null || user.ciudad!.isEmpty) {
      backendDeducedStep = 1;
    }
    // Step 3: Fitness
    else if ((user.nivelActividad ?? '').isEmpty || user.diasEntrenamiento.isEmpty) {
      backendDeducedStep = 2;
    } else {
      // At this point, PARQ, Profile, Fitness are done. Now check Body, Test Selection, Sport, Generating.
      bool squatsTestCompleted = false;
      try {
        final response = await http.get(
          Uri.parse('https://apifitnflai.com/evaluacion/listar-resultados-tests'),
          headers: {'Authorization': 'Bearer $token'},
        ).timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          final List<dynamic> tests = json.decode(response.body);
          squatsTestCompleted = tests.any((test) => test['nombreTest'] == 'sentadillas' && (test['completado'] ?? false) == true);
        }
      } catch (e) {
        debugPrint('Error checking squats test: $e');
        // Treat as not completed if there's an error
      }
      
      final prefs = await SharedPreferences.getInstance();
      final int? localCompletedStep = prefs.getInt('$_onboardingCompletedStepKey$userId');


      // Check for Step 4 (Body) and Step 5 (Test Selection)
      // The prompt suggests if `objetivoPrincipal` or `nombreDisciplina` are empty, then it's either Step 4 or 5.
      // If those are filled, it means they are past Step 6 (Sport).
      // This implies that the body details (which are not explicitly listed in user model for checks) are considered "done" if we are at this stage.

      if (user.objetivoPrincipal == null || user.objetivoPrincipal!.isEmpty || user.nombreDisciplina == null || user.nombreDisciplina!.isEmpty) {
        // If these are empty, they are either at Step 4 (Body) or Step 5 (Test Selection)
        if (localCompletedStep != null && localCompletedStep == 4) { // This means they finished Step 4 (Body)
          backendDeducedStep = 4; // Step 5: Test Selection
        } else {
          backendDeducedStep = 3; // Step 4: Body
        }
      } else {
        // If objetivoPrincipal and nombreDisciplina are NOT empty, they are past Step 6 (Sport).
        // This means they have completed Body (Step 4) and Sport (Step 6).
        // We need to check if they completed Test Selection (Step 5).
        if (!squatsTestCompleted) {
          backendDeducedStep = 4; // Step 5: Test Selection
        } else {
          // All previous steps (PARQ, Profile, Fitness, Body, Test Selection, Sport) are done.
          // Next is Generating
          backendDeducedStep = 6; // Step 7: Generating
        }
      }
    }

    // Now reconcile with local storage to find the highest completed step
    final prefs = await SharedPreferences.getInstance();
    final int? localCompletedStep = prefs.getInt('$_onboardingCompletedStepKey$userId');

    int finalStepIndex = backendDeducedStep;
    if (localCompletedStep != null && localCompletedStep > finalStepIndex) {
      finalStepIndex = localCompletedStep;
    }
    
    // Map step index to route string (0-based to 1-based conceptual steps)
    switch (finalStepIndex) {
      case 0: return AppRoutes.parq;
      case 1: return AppRoutes.step2Profile;
      case 2: return AppRoutes.step3Fitness;
      case 3: return AppRoutes.step4Body;
      case 4: return AppRoutes.step5Test;
      case 5: return AppRoutes.step6Sport;
      case 6: return AppRoutes.generating;
      case 7: return AppRoutes.onboardingFeedback; // Step 8: Onboarding Feedback
      default: return AppRoutes.home; // Fallback if onboarding is somehow complete but flag is false, or after final step
    }
  }

  static Future<void> saveCompletedStep(String userId, int step) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_onboardingCompletedStepKey$userId', step);
  }
}
