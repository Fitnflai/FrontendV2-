// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'specialist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Specialist _$SpecialistFromJson(Map<String, dynamic> json) {
  return _Specialist.fromJson(json);
}

/// @nodoc
mixin _$Specialist {
  @JsonKey(name: 'id_especialista')
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  List<String> get disciplinas => throw _privateConstructorUsedError;
  String? get especialidad => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  @JsonKey(name: 'foto_url')
  String? get fotoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'historial_laboral')
  List<dynamic>? get historialLaboral => throw _privateConstructorUsedError;

  /// Serializes this Specialist to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Specialist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpecialistCopyWith<Specialist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpecialistCopyWith<$Res> {
  factory $SpecialistCopyWith(
    Specialist value,
    $Res Function(Specialist) then,
  ) = _$SpecialistCopyWithImpl<$Res, Specialist>;
  @useResult
  $Res call({
    @JsonKey(name: 'id_especialista') int id,
    String nombre,
    List<String> disciplinas,
    String? especialidad,
    String? bio,
    @JsonKey(name: 'foto_url') String? fotoUrl,
    @JsonKey(name: 'historial_laboral') List<dynamic>? historialLaboral,
  });
}

/// @nodoc
class _$SpecialistCopyWithImpl<$Res, $Val extends Specialist>
    implements $SpecialistCopyWith<$Res> {
  _$SpecialistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Specialist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? disciplinas = null,
    Object? especialidad = freezed,
    Object? bio = freezed,
    Object? fotoUrl = freezed,
    Object? historialLaboral = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            nombre: null == nombre
                ? _value.nombre
                : nombre // ignore: cast_nullable_to_non_nullable
                      as String,
            disciplinas: null == disciplinas
                ? _value.disciplinas
                : disciplinas // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            especialidad: freezed == especialidad
                ? _value.especialidad
                : especialidad // ignore: cast_nullable_to_non_nullable
                      as String?,
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
            fotoUrl: freezed == fotoUrl
                ? _value.fotoUrl
                : fotoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            historialLaboral: freezed == historialLaboral
                ? _value.historialLaboral
                : historialLaboral // ignore: cast_nullable_to_non_nullable
                      as List<dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SpecialistImplCopyWith<$Res>
    implements $SpecialistCopyWith<$Res> {
  factory _$$SpecialistImplCopyWith(
    _$SpecialistImpl value,
    $Res Function(_$SpecialistImpl) then,
  ) = __$$SpecialistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'id_especialista') int id,
    String nombre,
    List<String> disciplinas,
    String? especialidad,
    String? bio,
    @JsonKey(name: 'foto_url') String? fotoUrl,
    @JsonKey(name: 'historial_laboral') List<dynamic>? historialLaboral,
  });
}

/// @nodoc
class __$$SpecialistImplCopyWithImpl<$Res>
    extends _$SpecialistCopyWithImpl<$Res, _$SpecialistImpl>
    implements _$$SpecialistImplCopyWith<$Res> {
  __$$SpecialistImplCopyWithImpl(
    _$SpecialistImpl _value,
    $Res Function(_$SpecialistImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Specialist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? disciplinas = null,
    Object? especialidad = freezed,
    Object? bio = freezed,
    Object? fotoUrl = freezed,
    Object? historialLaboral = freezed,
  }) {
    return _then(
      _$SpecialistImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        nombre: null == nombre
            ? _value.nombre
            : nombre // ignore: cast_nullable_to_non_nullable
                  as String,
        disciplinas: null == disciplinas
            ? _value._disciplinas
            : disciplinas // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        especialidad: freezed == especialidad
            ? _value.especialidad
            : especialidad // ignore: cast_nullable_to_non_nullable
                  as String?,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
        fotoUrl: freezed == fotoUrl
            ? _value.fotoUrl
            : fotoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        historialLaboral: freezed == historialLaboral
            ? _value._historialLaboral
            : historialLaboral // ignore: cast_nullable_to_non_nullable
                  as List<dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SpecialistImpl implements _Specialist {
  const _$SpecialistImpl({
    @JsonKey(name: 'id_especialista') required this.id,
    required this.nombre,
    required final List<String> disciplinas,
    this.especialidad,
    this.bio,
    @JsonKey(name: 'foto_url') this.fotoUrl,
    @JsonKey(name: 'historial_laboral') final List<dynamic>? historialLaboral,
  }) : _disciplinas = disciplinas,
       _historialLaboral = historialLaboral;

  factory _$SpecialistImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpecialistImplFromJson(json);

  @override
  @JsonKey(name: 'id_especialista')
  final int id;
  @override
  final String nombre;
  final List<String> _disciplinas;
  @override
  List<String> get disciplinas {
    if (_disciplinas is EqualUnmodifiableListView) return _disciplinas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_disciplinas);
  }

  @override
  final String? especialidad;
  @override
  final String? bio;
  @override
  @JsonKey(name: 'foto_url')
  final String? fotoUrl;
  final List<dynamic>? _historialLaboral;
  @override
  @JsonKey(name: 'historial_laboral')
  List<dynamic>? get historialLaboral {
    final value = _historialLaboral;
    if (value == null) return null;
    if (_historialLaboral is EqualUnmodifiableListView)
      return _historialLaboral;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Specialist(id: $id, nombre: $nombre, disciplinas: $disciplinas, especialidad: $especialidad, bio: $bio, fotoUrl: $fotoUrl, historialLaboral: $historialLaboral)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpecialistImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            const DeepCollectionEquality().equals(
              other._disciplinas,
              _disciplinas,
            ) &&
            (identical(other.especialidad, especialidad) ||
                other.especialidad == especialidad) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.fotoUrl, fotoUrl) || other.fotoUrl == fotoUrl) &&
            const DeepCollectionEquality().equals(
              other._historialLaboral,
              _historialLaboral,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    nombre,
    const DeepCollectionEquality().hash(_disciplinas),
    especialidad,
    bio,
    fotoUrl,
    const DeepCollectionEquality().hash(_historialLaboral),
  );

  /// Create a copy of Specialist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpecialistImplCopyWith<_$SpecialistImpl> get copyWith =>
      __$$SpecialistImplCopyWithImpl<_$SpecialistImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpecialistImplToJson(this);
  }
}

abstract class _Specialist implements Specialist {
  const factory _Specialist({
    @JsonKey(name: 'id_especialista') required final int id,
    required final String nombre,
    required final List<String> disciplinas,
    final String? especialidad,
    final String? bio,
    @JsonKey(name: 'foto_url') final String? fotoUrl,
    @JsonKey(name: 'historial_laboral') final List<dynamic>? historialLaboral,
  }) = _$SpecialistImpl;

  factory _Specialist.fromJson(Map<String, dynamic> json) =
      _$SpecialistImpl.fromJson;

  @override
  @JsonKey(name: 'id_especialista')
  int get id;
  @override
  String get nombre;
  @override
  List<String> get disciplinas;
  @override
  String? get especialidad;
  @override
  String? get bio;
  @override
  @JsonKey(name: 'foto_url')
  String? get fotoUrl;
  @override
  @JsonKey(name: 'historial_laboral')
  List<dynamic>? get historialLaboral;

  /// Create a copy of Specialist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpecialistImplCopyWith<_$SpecialistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
