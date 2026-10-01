// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Usuario _$UsuarioFromJson(Map<String, dynamic> json) => _Usuario(
  id: json['id'] as String,
  email: json['email'] as String,
  nombre: json['nombre'] as String,
  apodo: json['apodo'] as String?,
  onboardingCompleto: json['onboardingCompleto'] as bool? ?? false,
  registroActivo: json['registroActivo'] as bool? ?? true,
  genero: json['genero'] as String?,
  ciudad: json['ciudad'] as String?,
  altitud: json['altitud'] as String?,
  nivelActividad: json['nivelActividad'] as String?,
  nombreDisciplina: json['nombreDisciplina'] as String?,
  objetivoPrincipal: json['objetivoPrincipal'] as String?,
  fechaInicioPreferida: json['fechaInicioPreferida'] as String?,
  diasEntrenamiento:
      (json['diasEntrenamiento'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  nombrePlanActivo: json['nombrePlanActivo'] as String?,
  fechaFinSuscripcion: json['fechaFinSuscripcion'] as String?,
  estadoSuscripcion: json['estadoSuscripcion'] as String?,
  tienePlanActivo: json['tienePlanActivo'] as bool? ?? false,
);

Map<String, dynamic> _$UsuarioToJson(_Usuario instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'nombre': instance.nombre,
  'apodo': instance.apodo,
  'onboardingCompleto': instance.onboardingCompleto,
  'registroActivo': instance.registroActivo,
  'genero': instance.genero,
  'ciudad': instance.ciudad,
  'altitud': instance.altitud,
  'nivelActividad': instance.nivelActividad,
  'nombreDisciplina': instance.nombreDisciplina,
  'objetivoPrincipal': instance.objetivoPrincipal,
  'fechaInicioPreferida': instance.fechaInicioPreferida,
  'diasEntrenamiento': instance.diasEntrenamiento,
  'nombrePlanActivo': instance.nombrePlanActivo,
  'fechaFinSuscripcion': instance.fechaFinSuscripcion,
  'estadoSuscripcion': instance.estadoSuscripcion,
  'tienePlanActivo': instance.tienePlanActivo,
};
