// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'turno.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Turno {

 int get id;@JsonKey(name: 'id_especialista') int get idEspecialista; String get fecha;@JsonKey(name: 'hora_inicio') String get horaInicio;@JsonKey(name: 'hora_fin') String get horaFin; String get estado;
/// Create a copy of Turno
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TurnoCopyWith<Turno> get copyWith => _$TurnoCopyWithImpl<Turno>(this as Turno, _$identity);

  /// Serializes this Turno to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Turno&&(identical(other.id, id) || other.id == id)&&(identical(other.idEspecialista, idEspecialista) || other.idEspecialista == idEspecialista)&&(identical(other.fecha, fecha) || other.fecha == fecha)&&(identical(other.horaInicio, horaInicio) || other.horaInicio == horaInicio)&&(identical(other.horaFin, horaFin) || other.horaFin == horaFin)&&(identical(other.estado, estado) || other.estado == estado));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,idEspecialista,fecha,horaInicio,horaFin,estado);

@override
String toString() {
  return 'Turno(id: $id, idEspecialista: $idEspecialista, fecha: $fecha, horaInicio: $horaInicio, horaFin: $horaFin, estado: $estado)';
}


}

/// @nodoc
abstract mixin class $TurnoCopyWith<$Res>  {
  factory $TurnoCopyWith(Turno value, $Res Function(Turno) _then) = _$TurnoCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'id_especialista') int idEspecialista, String fecha,@JsonKey(name: 'hora_inicio') String horaInicio,@JsonKey(name: 'hora_fin') String horaFin, String estado
});




}
/// @nodoc
class _$TurnoCopyWithImpl<$Res>
    implements $TurnoCopyWith<$Res> {
  _$TurnoCopyWithImpl(this._self, this._then);

  final Turno _self;
  final $Res Function(Turno) _then;

/// Create a copy of Turno
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? idEspecialista = null,Object? fecha = null,Object? horaInicio = null,Object? horaFin = null,Object? estado = null,}) {
  return _then(Turno(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,idEspecialista: null == idEspecialista ? _self.idEspecialista : idEspecialista // ignore: cast_nullable_to_non_nullable
as int,fecha: null == fecha ? _self.fecha : fecha // ignore: cast_nullable_to_non_nullable
as String,horaInicio: null == horaInicio ? _self.horaInicio : horaInicio // ignore: cast_nullable_to_non_nullable
as String,horaFin: null == horaFin ? _self.horaFin : horaFin // ignore: cast_nullable_to_non_nullable
as String,estado: null == estado ? _self.estado : estado // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Turno].
extension TurnoPatterns on Turno {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Turno value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Turno() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Turno value)  $default,){
final _that = this;
switch (_that) {
case _Turno():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Turno value)?  $default,){
final _that = this;
switch (_that) {
case _Turno() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'id_especialista')  int idEspecialista,  String fecha, @JsonKey(name: 'hora_inicio')  String horaInicio, @JsonKey(name: 'hora_fin')  String horaFin,  String estado)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Turno() when $default != null:
return $default(_that.id,_that.idEspecialista,_that.fecha,_that.horaInicio,_that.horaFin,_that.estado);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'id_especialista')  int idEspecialista,  String fecha, @JsonKey(name: 'hora_inicio')  String horaInicio, @JsonKey(name: 'hora_fin')  String horaFin,  String estado)  $default,) {final _that = this;
switch (_that) {
case _Turno():
return $default(_that.id,_that.idEspecialista,_that.fecha,_that.horaInicio,_that.horaFin,_that.estado);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'id_especialista')  int idEspecialista,  String fecha, @JsonKey(name: 'hora_inicio')  String horaInicio, @JsonKey(name: 'hora_fin')  String horaFin,  String estado)?  $default,) {final _that = this;
switch (_that) {
case _Turno() when $default != null:
return $default(_that.id,_that.idEspecialista,_that.fecha,_that.horaInicio,_that.horaFin,_that.estado);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Turno implements Turno {
  const _Turno({required this.id, @JsonKey(name: 'id_especialista') required this.idEspecialista, required this.fecha, @JsonKey(name: 'hora_inicio') required this.horaInicio, @JsonKey(name: 'hora_fin') required this.horaFin, required this.estado});
  factory _Turno.fromJson(Map<String, dynamic> json) => _$TurnoFromJson(json);

@override final  int id;
@override@JsonKey(name: 'id_especialista') final  int idEspecialista;
@override final  String fecha;
@override@JsonKey(name: 'hora_inicio') final  String horaInicio;
@override@JsonKey(name: 'hora_fin') final  String horaFin;
@override final  String estado;

/// Create a copy of Turno
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TurnoCopyWith<_Turno> get copyWith => __$TurnoCopyWithImpl<_Turno>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TurnoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Turno&&(identical(other.id, id) || other.id == id)&&(identical(other.idEspecialista, idEspecialista) || other.idEspecialista == idEspecialista)&&(identical(other.fecha, fecha) || other.fecha == fecha)&&(identical(other.horaInicio, horaInicio) || other.horaInicio == horaInicio)&&(identical(other.horaFin, horaFin) || other.horaFin == horaFin)&&(identical(other.estado, estado) || other.estado == estado));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,idEspecialista,fecha,horaInicio,horaFin,estado);

@override
String toString() {
  return 'Turno(id: $id, idEspecialista: $idEspecialista, fecha: $fecha, horaInicio: $horaInicio, horaFin: $horaFin, estado: $estado)';
}


}

/// @nodoc
abstract mixin class _$TurnoCopyWith<$Res> implements $TurnoCopyWith<$Res> {
  factory _$TurnoCopyWith(_Turno value, $Res Function(_Turno) _then) = __$TurnoCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'id_especialista') int idEspecialista, String fecha,@JsonKey(name: 'hora_inicio') String horaInicio,@JsonKey(name: 'hora_fin') String horaFin, String estado
});




}
/// @nodoc
class __$TurnoCopyWithImpl<$Res>
    implements _$TurnoCopyWith<$Res> {
  __$TurnoCopyWithImpl(this._self, this._then);

  final _Turno _self;
  final $Res Function(_Turno) _then;

/// Create a copy of Turno
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? idEspecialista = null,Object? fecha = null,Object? horaInicio = null,Object? horaFin = null,Object? estado = null,}) {
  return _then(_Turno(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,idEspecialista: null == idEspecialista ? _self.idEspecialista : idEspecialista // ignore: cast_nullable_to_non_nullable
as int,fecha: null == fecha ? _self.fecha : fecha // ignore: cast_nullable_to_non_nullable
as String,horaInicio: null == horaInicio ? _self.horaInicio : horaInicio // ignore: cast_nullable_to_non_nullable
as String,horaFin: null == horaFin ? _self.horaFin : horaFin // ignore: cast_nullable_to_non_nullable
as String,estado: null == estado ? _self.estado : estado // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
