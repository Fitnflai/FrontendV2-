// lib/models/glossary_term.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'glossary_term.freezed.dart';
part 'glossary_term.g.dart';

@freezed
abstract class GlossaryTerm with _$GlossaryTerm {
  const factory GlossaryTerm({
    required String id,
    required String termino,
    @JsonKey(name: 'descripcion_es') required String descripcionEs,
    @JsonKey(name: 'descripcion_en') required String descripcionEn,
  }) = _GlossaryTerm;

  factory GlossaryTerm.fromJson(Map<String, dynamic> json) => _$GlossaryTermFromJson(json);
}
