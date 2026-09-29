
import 'package:freezed_annotation/freezed_annotation.dart';

part 'specialist.freezed.dart';
part 'specialist.g.dart';

@freezed
abstract class Specialist with _$Specialist {
  const factory Specialist({
    @JsonKey(name: 'id_especialista') required int id,
    required String nombre,
    required List<String> disciplinas,
    String? especialidad,
    String? bio,
    @JsonKey(name: 'foto_url') String? fotoUrl,
    @JsonKey(name: 'historial_laboral') List<dynamic>? historialLaboral,
    String? email,
    String? ciudad,
    String? pais,
    @JsonKey(name: 'anios_experiencia') num? aniosExperiencia,
    @JsonKey(name: 'telefono_contacto') String? telefonoContacto,
    List<dynamic>? certificados,
  }) = _Specialist;

  factory Specialist.fromJson(Map<String, dynamic> json) =>
      _$SpecialistFromJson(json);
}
