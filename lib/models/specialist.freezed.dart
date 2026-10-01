// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'specialist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Specialist {

@JsonKey(name: 'id_especialista') int get id; String get nombre; List<String> get disciplinas; String? get especialidad; String? get bio;@JsonKey(name: 'foto_url') String? get fotoUrl;@JsonKey(name: 'historial_laboral') List<dynamic>? get historialLaboral; String? get email; String? get ciudad; String? get pais;@JsonKey(name: 'anios_experiencia') num? get aniosExperiencia;@JsonKey(name: 'telefono_contacto') String? get telefonoContacto; List<dynamic>? get certificados;
/// Create a copy of Specialist
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpecialistCopyWith<Specialist> get copyWith => _$SpecialistCopyWithImpl<Specialist>(this as Specialist, _$identity);

  /// Serializes this Specialist to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Specialist&&(identical(other.id, id) || other.id == id)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&const DeepCollectionEquality().equals(other.disciplinas, disciplinas)&&(identical(other.especialidad, especialidad) || other.especialidad == especialidad)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.fotoUrl, fotoUrl) || other.fotoUrl == fotoUrl)&&const DeepCollectionEquality().equals(other.historialLaboral, historialLaboral)&&(identical(other.email, email) || other.email == email)&&(identical(other.ciudad, ciudad) || other.ciudad == ciudad)&&(identical(other.pais, pais) || other.pais == pais)&&(identical(other.aniosExperiencia, aniosExperiencia) || other.aniosExperiencia == aniosExperiencia)&&(identical(other.telefonoContacto, telefonoContacto) || other.telefonoContacto == telefonoContacto)&&const DeepCollectionEquality().equals(other.certificados, certificados));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nombre,const DeepCollectionEquality().hash(disciplinas),especialidad,bio,fotoUrl,const DeepCollectionEquality().hash(historialLaboral),email,ciudad,pais,aniosExperiencia,telefonoContacto,const DeepCollectionEquality().hash(certificados));

@override
String toString() {
  return 'Specialist(id: $id, nombre: $nombre, disciplinas: $disciplinas, especialidad: $especialidad, bio: $bio, fotoUrl: $fotoUrl, historialLaboral: $historialLaboral, email: $email, ciudad: $ciudad, pais: $pais, aniosExperiencia: $aniosExperiencia, telefonoContacto: $telefonoContacto, certificados: $certificados)';
}


}

/// @nodoc
abstract mixin class $SpecialistCopyWith<$Res>  {
  factory $SpecialistCopyWith(Specialist value, $Res Function(Specialist) _then) = _$SpecialistCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id_especialista') int id, String nombre, List<String> disciplinas, String? especialidad, String? bio,@JsonKey(name: 'foto_url') String? fotoUrl,@JsonKey(name: 'historial_laboral') List<dynamic>? historialLaboral, String? email, String? ciudad, String? pais,@JsonKey(name: 'anios_experiencia') num? aniosExperiencia,@JsonKey(name: 'telefono_contacto') String? telefonoContacto, List<dynamic>? certificados
});




}
/// @nodoc
class _$SpecialistCopyWithImpl<$Res>
    implements $SpecialistCopyWith<$Res> {
  _$SpecialistCopyWithImpl(this._self, this._then);

  final Specialist _self;
  final $Res Function(Specialist) _then;

/// Create a copy of Specialist
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nombre = null,Object? disciplinas = null,Object? especialidad = freezed,Object? bio = freezed,Object? fotoUrl = freezed,Object? historialLaboral = freezed,Object? email = freezed,Object? ciudad = freezed,Object? pais = freezed,Object? aniosExperiencia = freezed,Object? telefonoContacto = freezed,Object? certificados = freezed,}) {
  return _then(Specialist(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,disciplinas: null == disciplinas ? _self.disciplinas : disciplinas // ignore: cast_nullable_to_non_nullable
as List<String>,especialidad: freezed == especialidad ? _self.especialidad : especialidad // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,fotoUrl: freezed == fotoUrl ? _self.fotoUrl : fotoUrl // ignore: cast_nullable_to_non_nullable
as String?,historialLaboral: freezed == historialLaboral ? _self.historialLaboral : historialLaboral // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,ciudad: freezed == ciudad ? _self.ciudad : ciudad // ignore: cast_nullable_to_non_nullable
as String?,pais: freezed == pais ? _self.pais : pais // ignore: cast_nullable_to_non_nullable
as String?,aniosExperiencia: freezed == aniosExperiencia ? _self.aniosExperiencia : aniosExperiencia // ignore: cast_nullable_to_non_nullable
as num?,telefonoContacto: freezed == telefonoContacto ? _self.telefonoContacto : telefonoContacto // ignore: cast_nullable_to_non_nullable
as String?,certificados: freezed == certificados ? _self.certificados : certificados // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Specialist].
extension SpecialistPatterns on Specialist {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Specialist value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Specialist() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Specialist value)  $default,){
final _that = this;
switch (_that) {
case _Specialist():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Specialist value)?  $default,){
final _that = this;
switch (_that) {
case _Specialist() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id_especialista')  int id,  String nombre,  List<String> disciplinas,  String? especialidad,  String? bio, @JsonKey(name: 'foto_url')  String? fotoUrl, @JsonKey(name: 'historial_laboral')  List<dynamic>? historialLaboral,  String? email,  String? ciudad,  String? pais, @JsonKey(name: 'anios_experiencia')  num? aniosExperiencia, @JsonKey(name: 'telefono_contacto')  String? telefonoContacto,  List<dynamic>? certificados)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Specialist() when $default != null:
return $default(_that.id,_that.nombre,_that.disciplinas,_that.especialidad,_that.bio,_that.fotoUrl,_that.historialLaboral,_that.email,_that.ciudad,_that.pais,_that.aniosExperiencia,_that.telefonoContacto,_that.certificados);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id_especialista')  int id,  String nombre,  List<String> disciplinas,  String? especialidad,  String? bio, @JsonKey(name: 'foto_url')  String? fotoUrl, @JsonKey(name: 'historial_laboral')  List<dynamic>? historialLaboral,  String? email,  String? ciudad,  String? pais, @JsonKey(name: 'anios_experiencia')  num? aniosExperiencia, @JsonKey(name: 'telefono_contacto')  String? telefonoContacto,  List<dynamic>? certificados)  $default,) {final _that = this;
switch (_that) {
case _Specialist():
return $default(_that.id,_that.nombre,_that.disciplinas,_that.especialidad,_that.bio,_that.fotoUrl,_that.historialLaboral,_that.email,_that.ciudad,_that.pais,_that.aniosExperiencia,_that.telefonoContacto,_that.certificados);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id_especialista')  int id,  String nombre,  List<String> disciplinas,  String? especialidad,  String? bio, @JsonKey(name: 'foto_url')  String? fotoUrl, @JsonKey(name: 'historial_laboral')  List<dynamic>? historialLaboral,  String? email,  String? ciudad,  String? pais, @JsonKey(name: 'anios_experiencia')  num? aniosExperiencia, @JsonKey(name: 'telefono_contacto')  String? telefonoContacto,  List<dynamic>? certificados)?  $default,) {final _that = this;
switch (_that) {
case _Specialist() when $default != null:
return $default(_that.id,_that.nombre,_that.disciplinas,_that.especialidad,_that.bio,_that.fotoUrl,_that.historialLaboral,_that.email,_that.ciudad,_that.pais,_that.aniosExperiencia,_that.telefonoContacto,_that.certificados);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Specialist implements Specialist {
  const _Specialist({@JsonKey(name: 'id_especialista') required this.id, required this.nombre, required  List<String> disciplinas, this.especialidad, this.bio, @JsonKey(name: 'foto_url') this.fotoUrl, @JsonKey(name: 'historial_laboral')  List<dynamic>? historialLaboral, this.email, this.ciudad, this.pais, @JsonKey(name: 'anios_experiencia') this.aniosExperiencia, @JsonKey(name: 'telefono_contacto') this.telefonoContacto,  List<dynamic>? certificados}): _disciplinas = disciplinas,_historialLaboral = historialLaboral,_certificados = certificados;
  factory _Specialist.fromJson(Map<String, dynamic> json) => _$SpecialistFromJson(json);

@override@JsonKey(name: 'id_especialista') final  int id;
@override final  String nombre;
 final  List<String> _disciplinas;
@override List<String> get disciplinas {
  if (_disciplinas is EqualUnmodifiableListView) return _disciplinas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_disciplinas);
}

@override final  String? especialidad;
@override final  String? bio;
@override@JsonKey(name: 'foto_url') final  String? fotoUrl;
 final  List<dynamic>? _historialLaboral;
@override@JsonKey(name: 'historial_laboral') List<dynamic>? get historialLaboral {
  final value = _historialLaboral;
  if (value == null) return null;
  if (_historialLaboral is EqualUnmodifiableListView) return _historialLaboral;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? email;
@override final  String? ciudad;
@override final  String? pais;
@override@JsonKey(name: 'anios_experiencia') final  num? aniosExperiencia;
@override@JsonKey(name: 'telefono_contacto') final  String? telefonoContacto;
 final  List<dynamic>? _certificados;
@override List<dynamic>? get certificados {
  final value = _certificados;
  if (value == null) return null;
  if (_certificados is EqualUnmodifiableListView) return _certificados;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Specialist
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpecialistCopyWith<_Specialist> get copyWith => __$SpecialistCopyWithImpl<_Specialist>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpecialistToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Specialist&&(identical(other.id, id) || other.id == id)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&const DeepCollectionEquality().equals(other._disciplinas, _disciplinas)&&(identical(other.especialidad, especialidad) || other.especialidad == especialidad)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.fotoUrl, fotoUrl) || other.fotoUrl == fotoUrl)&&const DeepCollectionEquality().equals(other._historialLaboral, _historialLaboral)&&(identical(other.email, email) || other.email == email)&&(identical(other.ciudad, ciudad) || other.ciudad == ciudad)&&(identical(other.pais, pais) || other.pais == pais)&&(identical(other.aniosExperiencia, aniosExperiencia) || other.aniosExperiencia == aniosExperiencia)&&(identical(other.telefonoContacto, telefonoContacto) || other.telefonoContacto == telefonoContacto)&&const DeepCollectionEquality().equals(other._certificados, _certificados));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nombre,const DeepCollectionEquality().hash(_disciplinas),especialidad,bio,fotoUrl,const DeepCollectionEquality().hash(_historialLaboral),email,ciudad,pais,aniosExperiencia,telefonoContacto,const DeepCollectionEquality().hash(_certificados));

@override
String toString() {
  return 'Specialist(id: $id, nombre: $nombre, disciplinas: $disciplinas, especialidad: $especialidad, bio: $bio, fotoUrl: $fotoUrl, historialLaboral: $historialLaboral, email: $email, ciudad: $ciudad, pais: $pais, aniosExperiencia: $aniosExperiencia, telefonoContacto: $telefonoContacto, certificados: $certificados)';
}


}

/// @nodoc
abstract mixin class _$SpecialistCopyWith<$Res> implements $SpecialistCopyWith<$Res> {
  factory _$SpecialistCopyWith(_Specialist value, $Res Function(_Specialist) _then) = __$SpecialistCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id_especialista') int id, String nombre, List<String> disciplinas, String? especialidad, String? bio,@JsonKey(name: 'foto_url') String? fotoUrl,@JsonKey(name: 'historial_laboral') List<dynamic>? historialLaboral, String? email, String? ciudad, String? pais,@JsonKey(name: 'anios_experiencia') num? aniosExperiencia,@JsonKey(name: 'telefono_contacto') String? telefonoContacto, List<dynamic>? certificados
});




}
/// @nodoc
class __$SpecialistCopyWithImpl<$Res>
    implements _$SpecialistCopyWith<$Res> {
  __$SpecialistCopyWithImpl(this._self, this._then);

  final _Specialist _self;
  final $Res Function(_Specialist) _then;

/// Create a copy of Specialist
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nombre = null,Object? disciplinas = null,Object? especialidad = freezed,Object? bio = freezed,Object? fotoUrl = freezed,Object? historialLaboral = freezed,Object? email = freezed,Object? ciudad = freezed,Object? pais = freezed,Object? aniosExperiencia = freezed,Object? telefonoContacto = freezed,Object? certificados = freezed,}) {
  return _then(_Specialist(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,disciplinas: null == disciplinas ? _self._disciplinas : disciplinas // ignore: cast_nullable_to_non_nullable
as List<String>,especialidad: freezed == especialidad ? _self.especialidad : especialidad // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,fotoUrl: freezed == fotoUrl ? _self.fotoUrl : fotoUrl // ignore: cast_nullable_to_non_nullable
as String?,historialLaboral: freezed == historialLaboral ? _self._historialLaboral : historialLaboral // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,ciudad: freezed == ciudad ? _self.ciudad : ciudad // ignore: cast_nullable_to_non_nullable
as String?,pais: freezed == pais ? _self.pais : pais // ignore: cast_nullable_to_non_nullable
as String?,aniosExperiencia: freezed == aniosExperiencia ? _self.aniosExperiencia : aniosExperiencia // ignore: cast_nullable_to_non_nullable
as num?,telefonoContacto: freezed == telefonoContacto ? _self.telefonoContacto : telefonoContacto // ignore: cast_nullable_to_non_nullable
as String?,certificados: freezed == certificados ? _self._certificados : certificados // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,
  ));
}


}

// dart format on
