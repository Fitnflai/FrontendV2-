// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usuario.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Usuario _$UsuarioFromJson(Map<String, dynamic> json) {
  return _Usuario.fromJson(json);
}

/// @nodoc
mixin _$Usuario {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  String? get apodo => throw _privateConstructorUsedError;
  bool get onboardingCompleto => throw _privateConstructorUsedError;
  bool get registroActivo => throw _privateConstructorUsedError;
  String? get genero => throw _privateConstructorUsedError;
  String? get ciudad => throw _privateConstructorUsedError;
  String? get altitud => throw _privateConstructorUsedError;
  String? get nivelActividad => throw _privateConstructorUsedError;
  String? get nombreDisciplina => throw _privateConstructorUsedError;
  String? get objetivoPrincipal => throw _privateConstructorUsedError;
  String? get fechaInicioPreferida => throw _privateConstructorUsedError;
  List<String> get diasEntrenamiento => throw _privateConstructorUsedError;
  String? get nombrePlanActivo => throw _privateConstructorUsedError;
  String? get fechaFinSuscripcion => throw _privateConstructorUsedError;
  String? get estadoSuscripcion => throw _privateConstructorUsedError;
  bool get tienePlanActivo => throw _privateConstructorUsedError;

  /// Serializes this Usuario to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Usuario
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UsuarioCopyWith<Usuario> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsuarioCopyWith<$Res> {
  factory $UsuarioCopyWith(Usuario value, $Res Function(Usuario) then) =
      _$UsuarioCopyWithImpl<$Res, Usuario>;
  @useResult
  $Res call({
    String id,
    String email,
    String nombre,
    String? apodo,
    bool onboardingCompleto,
    bool registroActivo,
    String? genero,
    String? ciudad,
    String? altitud,
    String? nivelActividad,
    String? nombreDisciplina,
    String? objetivoPrincipal,
    String? fechaInicioPreferida,
    List<String> diasEntrenamiento,
    String? nombrePlanActivo,
    String? fechaFinSuscripcion,
    String? estadoSuscripcion,
    bool tienePlanActivo,
  });
}

/// @nodoc
class _$UsuarioCopyWithImpl<$Res, $Val extends Usuario>
    implements $UsuarioCopyWith<$Res> {
  _$UsuarioCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Usuario
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? nombre = null,
    Object? apodo = freezed,
    Object? onboardingCompleto = null,
    Object? registroActivo = null,
    Object? genero = freezed,
    Object? ciudad = freezed,
    Object? altitud = freezed,
    Object? nivelActividad = freezed,
    Object? nombreDisciplina = freezed,
    Object? objetivoPrincipal = freezed,
    Object? fechaInicioPreferida = freezed,
    Object? diasEntrenamiento = null,
    Object? nombrePlanActivo = freezed,
    Object? fechaFinSuscripcion = freezed,
    Object? estadoSuscripcion = freezed,
    Object? tienePlanActivo = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            nombre: null == nombre
                ? _value.nombre
                : nombre // ignore: cast_nullable_to_non_nullable
                      as String,
            apodo: freezed == apodo
                ? _value.apodo
                : apodo // ignore: cast_nullable_to_non_nullable
                      as String?,
            onboardingCompleto: null == onboardingCompleto
                ? _value.onboardingCompleto
                : onboardingCompleto // ignore: cast_nullable_to_non_nullable
                      as bool,
            registroActivo: null == registroActivo
                ? _value.registroActivo
                : registroActivo // ignore: cast_nullable_to_non_nullable
                      as bool,
            genero: freezed == genero
                ? _value.genero
                : genero // ignore: cast_nullable_to_non_nullable
                      as String?,
            ciudad: freezed == ciudad
                ? _value.ciudad
                : ciudad // ignore: cast_nullable_to_non_nullable
                      as String?,
            altitud: freezed == altitud
                ? _value.altitud
                : altitud // ignore: cast_nullable_to_non_nullable
                      as String?,
            nivelActividad: freezed == nivelActividad
                ? _value.nivelActividad
                : nivelActividad // ignore: cast_nullable_to_non_nullable
                      as String?,
            nombreDisciplina: freezed == nombreDisciplina
                ? _value.nombreDisciplina
                : nombreDisciplina // ignore: cast_nullable_to_non_nullable
                      as String?,
            objetivoPrincipal: freezed == objetivoPrincipal
                ? _value.objetivoPrincipal
                : objetivoPrincipal // ignore: cast_nullable_to_non_nullable
                      as String?,
            fechaInicioPreferida: freezed == fechaInicioPreferida
                ? _value.fechaInicioPreferida
                : fechaInicioPreferida // ignore: cast_nullable_to_non_nullable
                      as String?,
            diasEntrenamiento: null == diasEntrenamiento
                ? _value.diasEntrenamiento
                : diasEntrenamiento // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            nombrePlanActivo: freezed == nombrePlanActivo
                ? _value.nombrePlanActivo
                : nombrePlanActivo // ignore: cast_nullable_to_non_nullable
                      as String?,
            fechaFinSuscripcion: freezed == fechaFinSuscripcion
                ? _value.fechaFinSuscripcion
                : fechaFinSuscripcion // ignore: cast_nullable_to_non_nullable
                      as String?,
            estadoSuscripcion: freezed == estadoSuscripcion
                ? _value.estadoSuscripcion
                : estadoSuscripcion // ignore: cast_nullable_to_non_nullable
                      as String?,
            tienePlanActivo: null == tienePlanActivo
                ? _value.tienePlanActivo
                : tienePlanActivo // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UsuarioImplCopyWith<$Res> implements $UsuarioCopyWith<$Res> {
  factory _$$UsuarioImplCopyWith(
    _$UsuarioImpl value,
    $Res Function(_$UsuarioImpl) then,
  ) = __$$UsuarioImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    String nombre,
    String? apodo,
    bool onboardingCompleto,
    bool registroActivo,
    String? genero,
    String? ciudad,
    String? altitud,
    String? nivelActividad,
    String? nombreDisciplina,
    String? objetivoPrincipal,
    String? fechaInicioPreferida,
    List<String> diasEntrenamiento,
    String? nombrePlanActivo,
    String? fechaFinSuscripcion,
    String? estadoSuscripcion,
    bool tienePlanActivo,
  });
}

/// @nodoc
class __$$UsuarioImplCopyWithImpl<$Res>
    extends _$UsuarioCopyWithImpl<$Res, _$UsuarioImpl>
    implements _$$UsuarioImplCopyWith<$Res> {
  __$$UsuarioImplCopyWithImpl(
    _$UsuarioImpl _value,
    $Res Function(_$UsuarioImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Usuario
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? nombre = null,
    Object? apodo = freezed,
    Object? onboardingCompleto = null,
    Object? registroActivo = null,
    Object? genero = freezed,
    Object? ciudad = freezed,
    Object? altitud = freezed,
    Object? nivelActividad = freezed,
    Object? nombreDisciplina = freezed,
    Object? objetivoPrincipal = freezed,
    Object? fechaInicioPreferida = freezed,
    Object? diasEntrenamiento = null,
    Object? nombrePlanActivo = freezed,
    Object? fechaFinSuscripcion = freezed,
    Object? estadoSuscripcion = freezed,
    Object? tienePlanActivo = null,
  }) {
    return _then(
      _$UsuarioImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        nombre: null == nombre
            ? _value.nombre
            : nombre // ignore: cast_nullable_to_non_nullable
                  as String,
        apodo: freezed == apodo
            ? _value.apodo
            : apodo // ignore: cast_nullable_to_non_nullable
                  as String?,
        onboardingCompleto: null == onboardingCompleto
            ? _value.onboardingCompleto
            : onboardingCompleto // ignore: cast_nullable_to_non_nullable
                  as bool,
        registroActivo: null == registroActivo
            ? _value.registroActivo
            : registroActivo // ignore: cast_nullable_to_non_nullable
                  as bool,
        genero: freezed == genero
            ? _value.genero
            : genero // ignore: cast_nullable_to_non_nullable
                  as String?,
        ciudad: freezed == ciudad
            ? _value.ciudad
            : ciudad // ignore: cast_nullable_to_non_nullable
                  as String?,
        altitud: freezed == altitud
            ? _value.altitud
            : altitud // ignore: cast_nullable_to_non_nullable
                  as String?,
        nivelActividad: freezed == nivelActividad
            ? _value.nivelActividad
            : nivelActividad // ignore: cast_nullable_to_non_nullable
                  as String?,
        nombreDisciplina: freezed == nombreDisciplina
            ? _value.nombreDisciplina
            : nombreDisciplina // ignore: cast_nullable_to_non_nullable
                  as String?,
        objetivoPrincipal: freezed == objetivoPrincipal
            ? _value.objetivoPrincipal
            : objetivoPrincipal // ignore: cast_nullable_to_non_nullable
                  as String?,
        fechaInicioPreferida: freezed == fechaInicioPreferida
            ? _value.fechaInicioPreferida
            : fechaInicioPreferida // ignore: cast_nullable_to_non_nullable
                  as String?,
        diasEntrenamiento: null == diasEntrenamiento
            ? _value._diasEntrenamiento
            : diasEntrenamiento // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        nombrePlanActivo: freezed == nombrePlanActivo
            ? _value.nombrePlanActivo
            : nombrePlanActivo // ignore: cast_nullable_to_non_nullable
                  as String?,
        fechaFinSuscripcion: freezed == fechaFinSuscripcion
            ? _value.fechaFinSuscripcion
            : fechaFinSuscripcion // ignore: cast_nullable_to_non_nullable
                  as String?,
        estadoSuscripcion: freezed == estadoSuscripcion
            ? _value.estadoSuscripcion
            : estadoSuscripcion // ignore: cast_nullable_to_non_nullable
                  as String?,
        tienePlanActivo: null == tienePlanActivo
            ? _value.tienePlanActivo
            : tienePlanActivo // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UsuarioImpl extends _Usuario {
  const _$UsuarioImpl({
    required this.id,
    required this.email,
    required this.nombre,
    this.apodo,
    this.onboardingCompleto = false,
    this.registroActivo = true,
    this.genero,
    this.ciudad,
    this.altitud,
    this.nivelActividad,
    this.nombreDisciplina,
    this.objetivoPrincipal,
    this.fechaInicioPreferida,
    final List<String> diasEntrenamiento = const [],
    this.nombrePlanActivo,
    this.fechaFinSuscripcion,
    this.estadoSuscripcion,
    this.tienePlanActivo = false,
  }) : _diasEntrenamiento = diasEntrenamiento,
       super._();

  factory _$UsuarioImpl.fromJson(Map<String, dynamic> json) =>
      _$$UsuarioImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String nombre;
  @override
  final String? apodo;
  @override
  @JsonKey()
  final bool onboardingCompleto;
  @override
  @JsonKey()
  final bool registroActivo;
  @override
  final String? genero;
  @override
  final String? ciudad;
  @override
  final String? altitud;
  @override
  final String? nivelActividad;
  @override
  final String? nombreDisciplina;
  @override
  final String? objetivoPrincipal;
  @override
  final String? fechaInicioPreferida;
  final List<String> _diasEntrenamiento;
  @override
  @JsonKey()
  List<String> get diasEntrenamiento {
    if (_diasEntrenamiento is EqualUnmodifiableListView)
      return _diasEntrenamiento;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_diasEntrenamiento);
  }

  @override
  final String? nombrePlanActivo;
  @override
  final String? fechaFinSuscripcion;
  @override
  final String? estadoSuscripcion;
  @override
  @JsonKey()
  final bool tienePlanActivo;

  @override
  String toString() {
    return 'Usuario(id: $id, email: $email, nombre: $nombre, apodo: $apodo, onboardingCompleto: $onboardingCompleto, registroActivo: $registroActivo, genero: $genero, ciudad: $ciudad, altitud: $altitud, nivelActividad: $nivelActividad, nombreDisciplina: $nombreDisciplina, objetivoPrincipal: $objetivoPrincipal, fechaInicioPreferida: $fechaInicioPreferida, diasEntrenamiento: $diasEntrenamiento, nombrePlanActivo: $nombrePlanActivo, fechaFinSuscripcion: $fechaFinSuscripcion, estadoSuscripcion: $estadoSuscripcion, tienePlanActivo: $tienePlanActivo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsuarioImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.apodo, apodo) || other.apodo == apodo) &&
            (identical(other.onboardingCompleto, onboardingCompleto) ||
                other.onboardingCompleto == onboardingCompleto) &&
            (identical(other.registroActivo, registroActivo) ||
                other.registroActivo == registroActivo) &&
            (identical(other.genero, genero) || other.genero == genero) &&
            (identical(other.ciudad, ciudad) || other.ciudad == ciudad) &&
            (identical(other.altitud, altitud) || other.altitud == altitud) &&
            (identical(other.nivelActividad, nivelActividad) ||
                other.nivelActividad == nivelActividad) &&
            (identical(other.nombreDisciplina, nombreDisciplina) ||
                other.nombreDisciplina == nombreDisciplina) &&
            (identical(other.objetivoPrincipal, objetivoPrincipal) ||
                other.objetivoPrincipal == objetivoPrincipal) &&
            (identical(other.fechaInicioPreferida, fechaInicioPreferida) ||
                other.fechaInicioPreferida == fechaInicioPreferida) &&
            const DeepCollectionEquality().equals(
              other._diasEntrenamiento,
              _diasEntrenamiento,
            ) &&
            (identical(other.nombrePlanActivo, nombrePlanActivo) ||
                other.nombrePlanActivo == nombrePlanActivo) &&
            (identical(other.fechaFinSuscripcion, fechaFinSuscripcion) ||
                other.fechaFinSuscripcion == fechaFinSuscripcion) &&
            (identical(other.estadoSuscripcion, estadoSuscripcion) ||
                other.estadoSuscripcion == estadoSuscripcion) &&
            (identical(other.tienePlanActivo, tienePlanActivo) ||
                other.tienePlanActivo == tienePlanActivo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    nombre,
    apodo,
    onboardingCompleto,
    registroActivo,
    genero,
    ciudad,
    altitud,
    nivelActividad,
    nombreDisciplina,
    objetivoPrincipal,
    fechaInicioPreferida,
    const DeepCollectionEquality().hash(_diasEntrenamiento),
    nombrePlanActivo,
    fechaFinSuscripcion,
    estadoSuscripcion,
    tienePlanActivo,
  );

  /// Create a copy of Usuario
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UsuarioImplCopyWith<_$UsuarioImpl> get copyWith =>
      __$$UsuarioImplCopyWithImpl<_$UsuarioImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UsuarioImplToJson(this);
  }
}

abstract class _Usuario extends Usuario {
  const factory _Usuario({
    required final String id,
    required final String email,
    required final String nombre,
    final String? apodo,
    final bool onboardingCompleto,
    final bool registroActivo,
    final String? genero,
    final String? ciudad,
    final String? altitud,
    final String? nivelActividad,
    final String? nombreDisciplina,
    final String? objetivoPrincipal,
    final String? fechaInicioPreferida,
    final List<String> diasEntrenamiento,
    final String? nombrePlanActivo,
    final String? fechaFinSuscripcion,
    final String? estadoSuscripcion,
    final bool tienePlanActivo,
  }) = _$UsuarioImpl;
  const _Usuario._() : super._();

  factory _Usuario.fromJson(Map<String, dynamic> json) = _$UsuarioImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get nombre;
  @override
  String? get apodo;
  @override
  bool get onboardingCompleto;
  @override
  bool get registroActivo;
  @override
  String? get genero;
  @override
  String? get ciudad;
  @override
  String? get altitud;
  @override
  String? get nivelActividad;
  @override
  String? get nombreDisciplina;
  @override
  String? get objetivoPrincipal;
  @override
  String? get fechaInicioPreferida;
  @override
  List<String> get diasEntrenamiento;
  @override
  String? get nombrePlanActivo;
  @override
  String? get fechaFinSuscripcion;
  @override
  String? get estadoSuscripcion;
  @override
  bool get tienePlanActivo;

  /// Create a copy of Usuario
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UsuarioImplCopyWith<_$UsuarioImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
