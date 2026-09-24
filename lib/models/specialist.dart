
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
  }) = _Specialist;

  factory Specialist.fromJson(Map<String, dynamic> json) =>
      _$SpecialistFromJson(json);
}
