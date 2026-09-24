import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fitnflaifrontendv2/services/cached_http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NutritionProvider extends ChangeNotifier {
  final Map<String, int> _hydrationProgress = {};
  final Set<String> _checkedMeals = {};
  bool _initialized = false;
  Timer? _debounceTimer;
  final Completer<void> _initializationCompleter = Completer<void>();

  Future<void> get initializationFuture => _initializationCompleter.future;

  Map<String, int> get hydrationProgress => _hydrationProgress;
  Set<String> get checkedMeals => _checkedMeals;

  String getMealId({
    required String date,
    required String type,
    required String description,
  }) {
    final cleanDate = date.trim();
    final cleanType = type.trim().toUpperCase();
    return "${cleanDate}_${cleanType}_${description.hashCode}";
  }
  bool get initialized => _initialized;

  NutritionProvider() {
    _loadFromPrefs();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadFromPrefs() async {

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load hydration progress
      final hydrationStr = prefs.getString('nutrition_hydration_progress');
      if (hydrationStr != null) {
        final Map<String, dynamic> decoded = jsonDecode(hydrationStr);
        decoded.forEach((key, value) {
          if (value is int) {
            _hydrationProgress[key] = value;
          }
        });
      }

      // Load checked meals
      final checkedMealsListStr = prefs.getString('nutrition_checked_meals');
      if (checkedMealsListStr != null) {
        try {
          final List<dynamic> decodedList = jsonDecode(checkedMealsListStr);
          // Check if all elements are strings, if not, it's legacy data
          if (decodedList.every((item) => item is String)) {
            _checkedMeals.addAll(decodedList.cast<String>());
          } else {
            // Gracefully handle legacy integer IDs by clearing them
            debugPrint('Detected legacy integer meal IDs, clearing them.');
            _checkedMeals.clear();
          }
        } catch (e) {
          debugPrint('Error decoding checked meals from SharedPreferences: $e. Clearing data.');
          _checkedMeals.clear(); // Clear on any parsing error
        }
      }
    } catch (e) {
      debugPrint('Error loading nutrition persistence: $e');
    } finally {
      _initialized = true;
      if (!_initializationCompleter.isCompleted) {
        _initializationCompleter.complete();
      }
      notifyListeners();
    }
  }

    Future<void> updateHydration(String date, int glasses, {String? token}) async {
    _hydrationProgress[date] = glasses;
    notifyListeners();
    _saveHydrationToPrefs(); // Local persistence is immediate

    if (token != null && token.isNotEmpty) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(seconds: 2), () async {
        try {
          final url = Uri.parse('https://apifitnflai.com/users/registrar-hidratacion');
          final headers = {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          };
          final body = jsonEncode({
            "consumo_real_ml": glasses * 350,
            "fecha": date,
          });

          await CachedHttp.post(url, headers: headers, body: body);
          debugPrint('Hydration synchronized successfully for $date');
        } catch (e) {
          debugPrint('Error synchronizing hydration: $e');
        }
      });
    }
  }

  Future<void> _saveHydrationToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nutrition_hydration_progress', jsonEncode(_hydrationProgress));
    } catch (e) {
      debugPrint('Error saving hydration persistence: $e');
    }
  }

  Future<void> toggleMealCheck(String mealId, bool isChecked) async {
    if (isChecked) {
      _checkedMeals.add(mealId);
    } else {
      _checkedMeals.remove(mealId);
    }
    notifyListeners();
    _saveCheckedMealsToPrefs();
  }

  Future<void> _saveCheckedMealsToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nutrition_checked_meals', jsonEncode(_checkedMeals.toList()));
    } catch (e) {
      debugPrint('Error saving checked meals persistence: $e');
    }
  }
}