// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpecialistImpl _$$SpecialistImplFromJson(Map<String, dynamic> json) =>
    _$SpecialistImpl(
      id: (json['id_especialista'] as num).toInt(),
      nombre: json['nombre'] as String,
      disciplinas: (json['disciplinas'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      especialidad: json['especialidad'] as String?,
      bio: json['bio'] as String?,
      fotoUrl: json['foto_url'] as String?,
      historialLaboral: json['historial_laboral'] as List<dynamic>?,
    );

Map<String, dynamic> _$$SpecialistImplToJson(_$SpecialistImpl instance) =>
    <String, dynamic>{
      'id_especialista': instance.id,
      'nombre': instance.nombre,
      'disciplinas': instance.disciplinas,
      'especialidad': instance.especialidad,
      'bio': instance.bio,
      'foto_url': instance.fotoUrl,
      'historial_laboral': instance.historialLaboral,
    };
