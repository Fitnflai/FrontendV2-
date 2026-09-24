// lib/models/notification.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@JsonSerializable()
@freezed
abstract class Notification with _$Notification {
  const factory Notification({
    required String id,
    required String title,
    required String body,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    required String type,
    @Default(false) bool read,
  }) = _Notification;

  // Add this private constructor for custom getters
  const Notification._();

  factory Notification.fromJson(Map<String, dynamic> json) {
    final String rawTitle = json['titulo']?.toString() ?? '';
    final String rawType = json['tipo']?.toString() ?? '';
    final String parsedTitle = rawTitle.isNotEmpty 
        ? rawTitle 
        : (rawType.isNotEmpty ? rawType : 'Notificación');

    return _$NotificationFromJson({
      'id': (json['id_notificacion'] ?? json['id'] ?? '').toString(),
      'title': parsedTitle,
      'body': json['mensaje'] ?? json['cuerpo'] ?? json['body'] ?? '',
      'type': rawType.isNotEmpty ? rawType : 'sistema',
      'created_at': json['created_at'] != null 
          ? json['created_at'].toString()
          : (json['fecha_creacion'] ?? json['fecha_envio'] ?? DateTime.now().toIso8601String()).toString(),
      'read': json['leido'] ?? json['leida'] ?? json['read'] ?? false,
    });
  }

  // Getter aliases for backward compatibility
  String get titulo => title;
  String get cuerpo => body;
  String get tipo => type;
  DateTime get fecha => createdAt;
  bool get leida => read;
}
