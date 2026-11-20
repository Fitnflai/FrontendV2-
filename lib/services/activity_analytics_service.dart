import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/activity_detail.dart';
import 'cached_http.dart';

class ActivityAnalyticsService {
  static const _baseUrl = 'https://apifitnflai.com';

  Future<ActivityDetail> getActivityAnalytics({
    required String activityId,
    String? userId,
    required String token,
  }) async {
    final query = (userId != null && userId.isNotEmpty) ? '?id_usuario=$userId' : '';
    final uri = Uri.parse('$_baseUrl/health-service-integration/activities/$activityId$query');
    debugPrint('🌐 Fetching activity analytics from: $uri');
    
    try {
      final response = await CachedHttp.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        return ActivityDetail.fromJson(decoded);
      } else {
        debugPrint('🚨 Activity Analytics API Error Body: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('🚨 Activity Analytics API Exception: $e');
    }

    // Fallback: Si el backend dio 404 o falló la red, buscar en caché local
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('activity_cache_$activityId');
      if (cached != null) {
        debugPrint('✅ Loaded activity from local cache for key: $activityId');
        final decoded = json.decode(cached) as Map<String, dynamic>;
        return ActivityDetail.fromJson(decoded);
      }
    } catch (e) {
      debugPrint('🚨 Error reading activity from cache: $e');
    }

    throw Exception('Failed to load activity analytics: 404');
  }

  Future<String> saveActivity({
    required ActivityDetail activity,
    required String token,
    String? workoutId,
  }) async {
    final uri = Uri.parse('$_baseUrl/health-service-integration/activities');
    debugPrint('🌐 Uploading activity to: $uri');

    final payload = activity.toJson();
    if (activity.id.startsWith('phone_') || activity.id.startsWith('local_')) {
      payload.remove('id');
    }
    if (workoutId != null && workoutId.isNotEmpty) {
      payload['id_entrenamiento'] = workoutId;
    }

    String finalId = activity.id;
    try {
      final response = await CachedHttp.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        finalId = decoded['id']?.toString() ?? activity.id;
      } else {
        debugPrint('🚨 Failed to upload activity: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('🚨 Error uploading activity: $e');
    }

    // Guardar siempre copia en caché local para que nunca falle la vista posterior
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = json.encode(activity.toJson());
      await prefs.setString('activity_cache_${activity.id}', jsonStr);
      await prefs.setString('activity_cache_$finalId', jsonStr);
      if (workoutId != null && workoutId.isNotEmpty) {
        await prefs.setString('activity_cache_$workoutId', jsonStr);
      }
    } catch (e) {
      debugPrint('🚨 Error saving activity to local cache: $e');
    }

    return finalId;
  }
}
