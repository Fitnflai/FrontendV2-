// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glossary_term.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GlossaryTermImpl _$$GlossaryTermImplFromJson(Map<String, dynamic> json) =>
    _$GlossaryTermImpl(
      id: json['id'] as String,
      termino: json['termino'] as String,
      descripcionEs: json['descripcion_es'] as String,
      descripcionEn: json['descripcion_en'] as String,
    );

Map<String, dynamic> _$$GlossaryTermImplToJson(_$GlossaryTermImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'termino': instance.termino,
      'descripcion_es': instance.descripcionEs,
      'descripcion_en': instance.descripcionEn,
    };
