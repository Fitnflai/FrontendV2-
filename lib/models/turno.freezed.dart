// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'turno.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Turno _$TurnoFromJson(Map<String, dynamic> json) {
  return _Turno.fromJson(json);
}

/// @nodoc
mixin _$Turno {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'id_especialista')
  int get idEspecialista => throw _privateConstructorUsedError;
  String get fecha => throw _privateConstructorUsedError; // YYYY-MM-DD
  @JsonKey(name: 'hora_inicio')
  String get horaInicio => throw _privateConstructorUsedError; // HH:MM:SS
  @JsonKey(name: 'hora_fin')
  String get horaFin => throw _privateConstructorUsedError; // HH:MM:SS
  String get estado => throw _privateConstructorUsedError;

  /// Serializes this Turno to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Turno
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TurnoCopyWith<Turno> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TurnoCopyWith<$Res> {
  factory $TurnoCopyWith(Turno value, $Res Function(Turno) then) =
      _$TurnoCopyWithImpl<$Res, Turno>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'id_especialista') int idEspecialista,
    String fecha,
    @JsonKey(name: 'hora_inicio') String horaInicio,
    @JsonKey(name: 'hora_fin') String horaFin,
    String estado,
  });
}

/// @nodoc
class _$TurnoCopyWithImpl<$Res, $Val extends Turno>
    implements $TurnoCopyWith<$Res> {
  _$TurnoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Turno
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idEspecialista = null,
    Object? fecha = null,
    Object? horaInicio = null,
    Object? horaFin = null,
    Object? estado = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            idEspecialista: null == idEspecialista
                ? _value.idEspecialista
                : idEspecialista // ignore: cast_nullable_to_non_nullable
                      as int,
            fecha: null == fecha
                ? _value.fecha
                : fecha // ignore: cast_nullable_to_non_nullable
                      as String,
            horaInicio: null == horaInicio
                ? _value.horaInicio
                : horaInicio // ignore: cast_nullable_to_non_nullable
                      as String,
            horaFin: null == horaFin
                ? _value.horaFin
                : horaFin // ignore: cast_nullable_to_non_nullable
                      as String,
            estado: null == estado
                ? _value.estado
                : estado // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TurnoImplCopyWith<$Res> implements $TurnoCopyWith<$Res> {
  factory _$$TurnoImplCopyWith(
    _$TurnoImpl value,
    $Res Function(_$TurnoImpl) then,
  ) = __$$TurnoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'id_especialista') int idEspecialista,
    String fecha,
    @JsonKey(name: 'hora_inicio') String horaInicio,
    @JsonKey(name: 'hora_fin') String horaFin,
    String estado,
  });
}

/// @nodoc
class __$$TurnoImplCopyWithImpl<$Res>
    extends _$TurnoCopyWithImpl<$Res, _$TurnoImpl>
    implements _$$TurnoImplCopyWith<$Res> {
  __$$TurnoImplCopyWithImpl(
    _$TurnoImpl _value,
    $Res Function(_$TurnoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Turno
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idEspecialista = null,
    Object? fecha = null,
    Object? horaInicio = null,
    Object? horaFin = null,
    Object? estado = null,
  }) {
    return _then(
      _$TurnoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        idEspecialista: null == idEspecialista
            ? _value.idEspecialista
            : idEspecialista // ignore: cast_nullable_to_non_nullable
                  as int,
        fecha: null == fecha
            ? _value.fecha
            : fecha // ignore: cast_nullable_to_non_nullable
                  as String,
        horaInicio: null == horaInicio
            ? _value.horaInicio
            : horaInicio // ignore: cast_nullable_to_non_nullable
                  as String,
        horaFin: null == horaFin
            ? _value.horaFin
            : horaFin // ignore: cast_nullable_to_non_nullable
                  as String,
        estado: null == estado
            ? _value.estado
            : estado // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TurnoImpl implements _Turno {
  const _$TurnoImpl({
    required this.id,
    @JsonKey(name: 'id_especialista') required this.idEspecialista,
    required this.fecha,
    @JsonKey(name: 'hora_inicio') required this.horaInicio,
    @JsonKey(name: 'hora_fin') required this.horaFin,
    required this.estado,
  });

  factory _$TurnoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TurnoImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'id_especialista')
  final int idEspecialista;
  @override
  final String fecha;
  // YYYY-MM-DD
  @override
  @JsonKey(name: 'hora_inicio')
  final String horaInicio;
  // HH:MM:SS
  @override
  @JsonKey(name: 'hora_fin')
  final String horaFin;
  // HH:MM:SS
  @override
  final String estado;

  @override
  String toString() {
    return 'Turno(id: $id, idEspecialista: $idEspecialista, fecha: $fecha, horaInicio: $horaInicio, horaFin: $horaFin, estado: $estado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TurnoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.idEspecialista, idEspecialista) ||
                other.idEspecialista == idEspecialista) &&
            (identical(other.fecha, fecha) || other.fecha == fecha) &&
            (identical(other.horaInicio, horaInicio) ||
                other.horaInicio == horaInicio) &&
            (identical(other.horaFin, horaFin) || other.horaFin == horaFin) &&
            (identical(other.estado, estado) || other.estado == estado));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    idEspecialista,
    fecha,
    horaInicio,
    horaFin,
    estado,
  );

  /// Create a copy of Turno
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TurnoImplCopyWith<_$TurnoImpl> get copyWith =>
      __$$TurnoImplCopyWithImpl<_$TurnoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TurnoImplToJson(this);
  }
}

abstract class _Turno implements Turno {
  const factory _Turno({
    required final int id,
    @JsonKey(name: 'id_especialista') required final int idEspecialista,
    required final String fecha,
    @JsonKey(name: 'hora_inicio') required final String horaInicio,
    @JsonKey(name: 'hora_fin') required final String horaFin,
    required final String estado,
  }) = _$TurnoImpl;

  factory _Turno.fromJson(Map<String, dynamic> json) = _$TurnoImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'id_especialista')
  int get idEspecialista;
  @override
  String get fecha; // YYYY-MM-DD
  @override
  @JsonKey(name: 'hora_inicio')
  String get horaInicio; // HH:MM:SS
  @override
  @JsonKey(name: 'hora_fin')
  String get horaFin; // HH:MM:SS
  @override
  String get estado;

  /// Create a copy of Turno
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TurnoImplCopyWith<_$TurnoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
