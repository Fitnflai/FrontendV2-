// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usuario.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Usuario {

 String get id; String get email; String get nombre; String? get apodo; bool get onboardingCompleto; bool get registroActivo; String? get genero; String? get ciudad; String? get altitud; String? get nivelActividad; String? get nombreDisciplina; String? get objetivoPrincipal; String? get fechaInicioPreferida; List<String> get diasEntrenamiento; String? get nombrePlanActivo; String? get fechaFinSuscripcion; String? get estadoSuscripcion; bool get tienePlanActivo;
/// Create a copy of Usuario
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsuarioCopyWith<Usuario> get copyWith => _$UsuarioCopyWithImpl<Usuario>(this as Usuario, _$identity);

  /// Serializes this Usuario to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Usuario&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.apodo, apodo) || other.apodo == apodo)&&(identical(other.onboardingCompleto, onboardingCompleto) || other.onboardingCompleto == onboardingCompleto)&&(identical(other.registroActivo, registroActivo) || other.registroActivo == registroActivo)&&(identical(other.genero, genero) || other.genero == genero)&&(identical(other.ciudad, ciudad) || other.ciudad == ciudad)&&(identical(other.altitud, altitud) || other.altitud == altitud)&&(identical(other.nivelActividad, nivelActividad) || other.nivelActividad == nivelActividad)&&(identical(other.nombreDisciplina, nombreDisciplina) || other.nombreDisciplina == nombreDisciplina)&&(identical(other.objetivoPrincipal, objetivoPrincipal) || other.objetivoPrincipal == objetivoPrincipal)&&(identical(other.fechaInicioPreferida, fechaInicioPreferida) || other.fechaInicioPreferida == fechaInicioPreferida)&&const DeepCollectionEquality().equals(other.diasEntrenamiento, diasEntrenamiento)&&(identical(other.nombrePlanActivo, nombrePlanActivo) || other.nombrePlanActivo == nombrePlanActivo)&&(identical(other.fechaFinSuscripcion, fechaFinSuscripcion) || other.fechaFinSuscripcion == fechaFinSuscripcion)&&(identical(other.estadoSuscripcion, estadoSuscripcion) || other.estadoSuscripcion == estadoSuscripcion)&&(identical(other.tienePlanActivo, tienePlanActivo) || other.tienePlanActivo == tienePlanActivo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,nombre,apodo,onboardingCompleto,registroActivo,genero,ciudad,altitud,nivelActividad,nombreDisciplina,objetivoPrincipal,fechaInicioPreferida,const DeepCollectionEquality().hash(diasEntrenamiento),nombrePlanActivo,fechaFinSuscripcion,estadoSuscripcion,tienePlanActivo);

@override
String toString() {
  return 'Usuario(id: $id, email: $email, nombre: $nombre, apodo: $apodo, onboardingCompleto: $onboardingCompleto, registroActivo: $registroActivo, genero: $genero, ciudad: $ciudad, altitud: $altitud, nivelActividad: $nivelActividad, nombreDisciplina: $nombreDisciplina, objetivoPrincipal: $objetivoPrincipal, fechaInicioPreferida: $fechaInicioPreferida, diasEntrenamiento: $diasEntrenamiento, nombrePlanActivo: $nombrePlanActivo, fechaFinSuscripcion: $fechaFinSuscripcion, estadoSuscripcion: $estadoSuscripcion, tienePlanActivo: $tienePlanActivo)';
}


}

/// @nodoc
abstract mixin class $UsuarioCopyWith<$Res>  {
  factory $UsuarioCopyWith(Usuario value, $Res Function(Usuario) _then) = _$UsuarioCopyWithImpl;
@useResult
$Res call({
 String id, String email, String nombre, String? apodo, bool onboardingCompleto, bool registroActivo, String? genero, String? ciudad, String? altitud, String? nivelActividad, String? nombreDisciplina, String? objetivoPrincipal, String? fechaInicioPreferida, List<String> diasEntrenamiento, String? nombrePlanActivo, String? fechaFinSuscripcion, String? estadoSuscripcion, bool tienePlanActivo
});




}
/// @nodoc
class _$UsuarioCopyWithImpl<$Res>
    implements $UsuarioCopyWith<$Res> {
  _$UsuarioCopyWithImpl(this._self, this._then);

  final Usuario _self;
  final $Res Function(Usuario) _then;

/// Create a copy of Usuario
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? nombre = null,Object? apodo = freezed,Object? onboardingCompleto = null,Object? registroActivo = null,Object? genero = freezed,Object? ciudad = freezed,Object? altitud = freezed,Object? nivelActividad = freezed,Object? nombreDisciplina = freezed,Object? objetivoPrincipal = freezed,Object? fechaInicioPreferida = freezed,Object? diasEntrenamiento = null,Object? nombrePlanActivo = freezed,Object? fechaFinSuscripcion = freezed,Object? estadoSuscripcion = freezed,Object? tienePlanActivo = null,}) {
  return _then(Usuario(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,apodo: freezed == apodo ? _self.apodo : apodo // ignore: cast_nullable_to_non_nullable
as String?,onboardingCompleto: null == onboardingCompleto ? _self.onboardingCompleto : onboardingCompleto // ignore: cast_nullable_to_non_nullable
as bool,registroActivo: null == registroActivo ? _self.registroActivo : registroActivo // ignore: cast_nullable_to_non_nullable
as bool,genero: freezed == genero ? _self.genero : genero // ignore: cast_nullable_to_non_nullable
as String?,ciudad: freezed == ciudad ? _self.ciudad : ciudad // ignore: cast_nullable_to_non_nullable
as String?,altitud: freezed == altitud ? _self.altitud : altitud // ignore: cast_nullable_to_non_nullable
as String?,nivelActividad: freezed == nivelActividad ? _self.nivelActividad : nivelActividad // ignore: cast_nullable_to_non_nullable
as String?,nombreDisciplina: freezed == nombreDisciplina ? _self.nombreDisciplina : nombreDisciplina // ignore: cast_nullable_to_non_nullable
as String?,objetivoPrincipal: freezed == objetivoPrincipal ? _self.objetivoPrincipal : objetivoPrincipal // ignore: cast_nullable_to_non_nullable
as String?,fechaInicioPreferida: freezed == fechaInicioPreferida ? _self.fechaInicioPreferida : fechaInicioPreferida // ignore: cast_nullable_to_non_nullable
as String?,diasEntrenamiento: null == diasEntrenamiento ? _self.diasEntrenamiento : diasEntrenamiento // ignore: cast_nullable_to_non_nullable
as List<String>,nombrePlanActivo: freezed == nombrePlanActivo ? _self.nombrePlanActivo : nombrePlanActivo // ignore: cast_nullable_to_non_nullable
as String?,fechaFinSuscripcion: freezed == fechaFinSuscripcion ? _self.fechaFinSuscripcion : fechaFinSuscripcion // ignore: cast_nullable_to_non_nullable
as String?,estadoSuscripcion: freezed == estadoSuscripcion ? _self.estadoSuscripcion : estadoSuscripcion // ignore: cast_nullable_to_non_nullable
as String?,tienePlanActivo: null == tienePlanActivo ? _self.tienePlanActivo : tienePlanActivo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Usuario].
extension UsuarioPatterns on Usuario {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Usuario value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Usuario() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Usuario value)  $default,){
final _that = this;
switch (_that) {
case _Usuario():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Usuario value)?  $default,){
final _that = this;
switch (_that) {
case _Usuario() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String nombre,  String? apodo,  bool onboardingCompleto,  bool registroActivo,  String? genero,  String? ciudad,  String? altitud,  String? nivelActividad,  String? nombreDisciplina,  String? objetivoPrincipal,  String? fechaInicioPreferida,  List<String> diasEntrenamiento,  String? nombrePlanActivo,  String? fechaFinSuscripcion,  String? estadoSuscripcion,  bool tienePlanActivo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Usuario() when $default != null:
return $default(_that.id,_that.email,_that.nombre,_that.apodo,_that.onboardingCompleto,_that.registroActivo,_that.genero,_that.ciudad,_that.altitud,_that.nivelActividad,_that.nombreDisciplina,_that.objetivoPrincipal,_that.fechaInicioPreferida,_that.diasEntrenamiento,_that.nombrePlanActivo,_that.fechaFinSuscripcion,_that.estadoSuscripcion,_that.tienePlanActivo);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String nombre,  String? apodo,  bool onboardingCompleto,  bool registroActivo,  String? genero,  String? ciudad,  String? altitud,  String? nivelActividad,  String? nombreDisciplina,  String? objetivoPrincipal,  String? fechaInicioPreferida,  List<String> diasEntrenamiento,  String? nombrePlanActivo,  String? fechaFinSuscripcion,  String? estadoSuscripcion,  bool tienePlanActivo)  $default,) {final _that = this;
switch (_that) {
case _Usuario():
return $default(_that.id,_that.email,_that.nombre,_that.apodo,_that.onboardingCompleto,_that.registroActivo,_that.genero,_that.ciudad,_that.altitud,_that.nivelActividad,_that.nombreDisciplina,_that.objetivoPrincipal,_that.fechaInicioPreferida,_that.diasEntrenamiento,_that.nombrePlanActivo,_that.fechaFinSuscripcion,_that.estadoSuscripcion,_that.tienePlanActivo);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String nombre,  String? apodo,  bool onboardingCompleto,  bool registroActivo,  String? genero,  String? ciudad,  String? altitud,  String? nivelActividad,  String? nombreDisciplina,  String? objetivoPrincipal,  String? fechaInicioPreferida,  List<String> diasEntrenamiento,  String? nombrePlanActivo,  String? fechaFinSuscripcion,  String? estadoSuscripcion,  bool tienePlanActivo)?  $default,) {final _that = this;
switch (_that) {
case _Usuario() when $default != null:
return $default(_that.id,_that.email,_that.nombre,_that.apodo,_that.onboardingCompleto,_that.registroActivo,_that.genero,_that.ciudad,_that.altitud,_that.nivelActividad,_that.nombreDisciplina,_that.objetivoPrincipal,_that.fechaInicioPreferida,_that.diasEntrenamiento,_that.nombrePlanActivo,_that.fechaFinSuscripcion,_that.estadoSuscripcion,_that.tienePlanActivo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Usuario extends Usuario {
  const _Usuario({required this.id, required this.email, required this.nombre, this.apodo, this.onboardingCompleto = false, this.registroActivo = true, this.genero, this.ciudad, this.altitud, this.nivelActividad, this.nombreDisciplina, this.objetivoPrincipal, this.fechaInicioPreferida,  List<String> diasEntrenamiento = const [], this.nombrePlanActivo, this.fechaFinSuscripcion, this.estadoSuscripcion, this.tienePlanActivo = false}): _diasEntrenamiento = diasEntrenamiento,super._();
  factory _Usuario.fromJson(Map<String, dynamic> json) => _$UsuarioFromJson(json);

@override final  String id;
@override final  String email;
@override final  String nombre;
@override final  String? apodo;
@override@JsonKey() final  bool onboardingCompleto;
@override@JsonKey() final  bool registroActivo;
@override final  String? genero;
@override final  String? ciudad;
@override final  String? altitud;
@override final  String? nivelActividad;
@override final  String? nombreDisciplina;
@override final  String? objetivoPrincipal;
@override final  String? fechaInicioPreferida;
 final  List<String> _diasEntrenamiento;
@override@JsonKey() List<String> get diasEntrenamiento {
  if (_diasEntrenamiento is EqualUnmodifiableListView) return _diasEntrenamiento;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_diasEntrenamiento);
}

@override final  String? nombrePlanActivo;
@override final  String? fechaFinSuscripcion;
@override final  String? estadoSuscripcion;
@override@JsonKey() final  bool tienePlanActivo;

/// Create a copy of Usuario
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsuarioCopyWith<_Usuario> get copyWith => __$UsuarioCopyWithImpl<_Usuario>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UsuarioToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Usuario&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.apodo, apodo) || other.apodo == apodo)&&(identical(other.onboardingCompleto, onboardingCompleto) || other.onboardingCompleto == onboardingCompleto)&&(identical(other.registroActivo, registroActivo) || other.registroActivo == registroActivo)&&(identical(other.genero, genero) || other.genero == genero)&&(identical(other.ciudad, ciudad) || other.ciudad == ciudad)&&(identical(other.altitud, altitud) || other.altitud == altitud)&&(identical(other.nivelActividad, nivelActividad) || other.nivelActividad == nivelActividad)&&(identical(other.nombreDisciplina, nombreDisciplina) || other.nombreDisciplina == nombreDisciplina)&&(identical(other.objetivoPrincipal, objetivoPrincipal) || other.objetivoPrincipal == objetivoPrincipal)&&(identical(other.fechaInicioPreferida, fechaInicioPreferida) || other.fechaInicioPreferida == fechaInicioPreferida)&&const DeepCollectionEquality().equals(other._diasEntrenamiento, _diasEntrenamiento)&&(identical(other.nombrePlanActivo, nombrePlanActivo) || other.nombrePlanActivo == nombrePlanActivo)&&(identical(other.fechaFinSuscripcion, fechaFinSuscripcion) || other.fechaFinSuscripcion == fechaFinSuscripcion)&&(identical(other.estadoSuscripcion, estadoSuscripcion) || other.estadoSuscripcion == estadoSuscripcion)&&(identical(other.tienePlanActivo, tienePlanActivo) || other.tienePlanActivo == tienePlanActivo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,nombre,apodo,onboardingCompleto,registroActivo,genero,ciudad,altitud,nivelActividad,nombreDisciplina,objetivoPrincipal,fechaInicioPreferida,const DeepCollectionEquality().hash(_diasEntrenamiento),nombrePlanActivo,fechaFinSuscripcion,estadoSuscripcion,tienePlanActivo);

@override
String toString() {
  return 'Usuario(id: $id, email: $email, nombre: $nombre, apodo: $apodo, onboardingCompleto: $onboardingCompleto, registroActivo: $registroActivo, genero: $genero, ciudad: $ciudad, altitud: $altitud, nivelActividad: $nivelActividad, nombreDisciplina: $nombreDisciplina, objetivoPrincipal: $objetivoPrincipal, fechaInicioPreferida: $fechaInicioPreferida, diasEntrenamiento: $diasEntrenamiento, nombrePlanActivo: $nombrePlanActivo, fechaFinSuscripcion: $fechaFinSuscripcion, estadoSuscripcion: $estadoSuscripcion, tienePlanActivo: $tienePlanActivo)';
}


}

/// @nodoc
abstract mixin class _$UsuarioCopyWith<$Res> implements $UsuarioCopyWith<$Res> {
  factory _$UsuarioCopyWith(_Usuario value, $Res Function(_Usuario) _then) = __$UsuarioCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String nombre, String? apodo, bool onboardingCompleto, bool registroActivo, String? genero, String? ciudad, String? altitud, String? nivelActividad, String? nombreDisciplina, String? objetivoPrincipal, String? fechaInicioPreferida, List<String> diasEntrenamiento, String? nombrePlanActivo, String? fechaFinSuscripcion, String? estadoSuscripcion, bool tienePlanActivo
});




}
/// @nodoc
class __$UsuarioCopyWithImpl<$Res>
    implements _$UsuarioCopyWith<$Res> {
  __$UsuarioCopyWithImpl(this._self, this._then);

  final _Usuario _self;
  final $Res Function(_Usuario) _then;

/// Create a copy of Usuario
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? nombre = null,Object? apodo = freezed,Object? onboardingCompleto = null,Object? registroActivo = null,Object? genero = freezed,Object? ciudad = freezed,Object? altitud = freezed,Object? nivelActividad = freezed,Object? nombreDisciplina = freezed,Object? objetivoPrincipal = freezed,Object? fechaInicioPreferida = freezed,Object? diasEntrenamiento = null,Object? nombrePlanActivo = freezed,Object? fechaFinSuscripcion = freezed,Object? estadoSuscripcion = freezed,Object? tienePlanActivo = null,}) {
  return _then(_Usuario(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,apodo: freezed == apodo ? _self.apodo : apodo // ignore: cast_nullable_to_non_nullable
as String?,onboardingCompleto: null == onboardingCompleto ? _self.onboardingCompleto : onboardingCompleto // ignore: cast_nullable_to_non_nullable
as bool,registroActivo: null == registroActivo ? _self.registroActivo : registroActivo // ignore: cast_nullable_to_non_nullable
as bool,genero: freezed == genero ? _self.genero : genero // ignore: cast_nullable_to_non_nullable
as String?,ciudad: freezed == ciudad ? _self.ciudad : ciudad // ignore: cast_nullable_to_non_nullable
as String?,altitud: freezed == altitud ? _self.altitud : altitud // ignore: cast_nullable_to_non_nullable
as String?,nivelActividad: freezed == nivelActividad ? _self.nivelActividad : nivelActividad // ignore: cast_nullable_to_non_nullable
as String?,nombreDisciplina: freezed == nombreDisciplina ? _self.nombreDisciplina : nombreDisciplina // ignore: cast_nullable_to_non_nullable
as String?,objetivoPrincipal: freezed == objetivoPrincipal ? _self.objetivoPrincipal : objetivoPrincipal // ignore: cast_nullable_to_non_nullable
as String?,fechaInicioPreferida: freezed == fechaInicioPreferida ? _self.fechaInicioPreferida : fechaInicioPreferida // ignore: cast_nullable_to_non_nullable
as String?,diasEntrenamiento: null == diasEntrenamiento ? _self._diasEntrenamiento : diasEntrenamiento // ignore: cast_nullable_to_non_nullable
as List<String>,nombrePlanActivo: freezed == nombrePlanActivo ? _self.nombrePlanActivo : nombrePlanActivo // ignore: cast_nullable_to_non_nullable
as String?,fechaFinSuscripcion: freezed == fechaFinSuscripcion ? _self.fechaFinSuscripcion : fechaFinSuscripcion // ignore: cast_nullable_to_non_nullable
as String?,estadoSuscripcion: freezed == estadoSuscripcion ? _self.estadoSuscripcion : estadoSuscripcion // ignore: cast_nullable_to_non_nullable
as String?,tienePlanActivo: null == tienePlanActivo ? _self.tienePlanActivo : tienePlanActivo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
