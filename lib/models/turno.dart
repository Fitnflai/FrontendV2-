
import 'package:freezed_annotation/freezed_annotation.dart';


part 'turno.freezed.dart';
part 'turno.g.dart';

@freezed
abstract class Turno with _$Turno {
  const factory Turno({
    required int id,
    @JsonKey(name: 'id_especialista') required int idEspecialista,
    required String fecha, // YYYY-MM-DD
    @JsonKey(name: 'hora_inicio') required String horaInicio, // HH:MM:SS
    @JsonKey(name: 'hora_fin') required String horaFin, // HH:MM:SS
    required String estado, // "disponible"
  }) = _Turno;

  factory Turno.fromJson(Map<String, dynamic> json) => _$TurnoFromJson(json);
}
