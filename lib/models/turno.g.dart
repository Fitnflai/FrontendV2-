// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'turno.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Turno _$TurnoFromJson(Map<String, dynamic> json) => _Turno(
  id: (json['id'] as num).toInt(),
  idEspecialista: (json['id_especialista'] as num).toInt(),
  fecha: json['fecha'] as String,
  horaInicio: json['hora_inicio'] as String,
  horaFin: json['hora_fin'] as String,
  estado: json['estado'] as String,
);

Map<String, dynamic> _$TurnoToJson(_Turno instance) => <String, dynamic>{
  'id': instance.id,
  'id_especialista': instance.idEspecialista,
  'fecha': instance.fecha,
  'hora_inicio': instance.horaInicio,
  'hora_fin': instance.horaFin,
  'estado': instance.estado,
};
