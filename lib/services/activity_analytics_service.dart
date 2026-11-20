import 'dart:convert';
import 'package:flutter/foundation.dart';
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
    
    final response = await CachedHttp.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      try {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        return ActivityDetail.fromJson(decoded);
      } catch (e, stack) {
        debugPrint('🚨 Error parsing ActivityDetail JSON: $e');
        debugPrint('🚨 Stack: $stack');
        rethrow;
      }
    } else {
      debugPrint('🚨 Activity Analytics API Error Body: ${response.body}');
      throw Exception('Failed to load activity analytics: ${response.statusCode}');
    }
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
      return decoded['id']?.toString() ?? activity.id;
    } else {
      debugPrint('🚨 Failed to upload activity: ${response.statusCode} - ${response.body}');
      return activity.id; // Fallback to local activity id
    }
  }
}
