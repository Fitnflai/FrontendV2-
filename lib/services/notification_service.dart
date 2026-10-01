import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import '../models/notification.dart'; // Assuming models are in a higher directory
import '../config/app_constants.dart'; // Assuming base API URL is here
import 'cached_http.dart';

class NotificationService {

  final String _baseUrl = AppConstants.baseUrl;

  Future<List<Notification>> fetchNotifications(String token) async {
    final response = await CachedHttp.get(
      Uri.parse('$_baseUrl/notifications/notificaciones'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      debugPrint('🛑 NOTIFICATIONS RAW RESPONSE: ${response.body}');
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Notification.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load notifications: ${response.statusCode}');
    }
  }

  Future<void> markNotificationAsRead(String token, String id) async {
    final response = await CachedHttp.patch(
      Uri.parse('$_baseUrl/notifications/notificaciones/$id/leida'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to mark notification as read: ${response.statusCode}');
    }
  }

  Future<String?> fetchFcmToken() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        return await FirebaseMessaging.instance.getToken();
      }
    } catch (e) {
      // Log the exception gracefully
      debugPrint('Error fetching FCM token: $e'); // Using debugPrint to follow Flutter guidelines
    }
    return null;
  }

  Future<void> updateFcmToken(String token, String fcmToken) async {
    final response = await CachedHttp.post(
      Uri.parse('$_baseUrl/notifications/update-fcm-token'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'fcm_token': fcmToken,
        'token': fcmToken,
        'fcmToken': fcmToken,
        'token_fcm': fcmToken,
        'device_token': fcmToken,
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to update FCM token on dedicated endpoint');
    }
  }

  Future<void> setSchedule(String token, String notificationTime) async {
    final response = await CachedHttp.post(
      Uri.parse('$_baseUrl/notifications/set-schedule'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'notification_time': notificationTime,
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to set workout schedule time');
    }
  }
}
