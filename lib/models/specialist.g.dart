// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Specialist _$SpecialistFromJson(Map<String, dynamic> json) => _Specialist(
  id: (json['id_especialista'] as num).toInt(),
  nombre: json['nombre'] as String,
  disciplinas: (json['disciplinas'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  especialidad: json['especialidad'] as String?,
  bio: json['bio'] as String?,
  fotoUrl: json['foto_url'] as String?,
  historialLaboral: json['historial_laboral'] as List<dynamic>?,
  email: json['email'] as String?,
  ciudad: json['ciudad'] as String?,
  pais: json['pais'] as String?,
  aniosExperiencia: json['anios_experiencia'] as num?,
  telefonoContacto: json['telefono_contacto'] as String?,
  certificados: json['certificados'] as List<dynamic>?,
);

Map<String, dynamic> _$SpecialistToJson(_Specialist instance) =>
    <String, dynamic>{
      'id_especialista': instance.id,
      'nombre': instance.nombre,
      'disciplinas': instance.disciplinas,
      'especialidad': instance.especialidad,
      'bio': instance.bio,
      'foto_url': instance.fotoUrl,
      'historial_laboral': instance.historialLaboral,
      'email': instance.email,
      'ciudad': instance.ciudad,
      'pais': instance.pais,
      'anios_experiencia': instance.aniosExperiencia,
      'telefono_contacto': instance.telefonoContacto,
      'certificados': instance.certificados,
    };
