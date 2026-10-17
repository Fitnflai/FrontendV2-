// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'glossary_term.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GlossaryTerm _$GlossaryTermFromJson(Map<String, dynamic> json) {
  return _GlossaryTerm.fromJson(json);
}

/// @nodoc
mixin _$GlossaryTerm {
  String get id => throw _privateConstructorUsedError;
  String get termino => throw _privateConstructorUsedError;
  @JsonKey(name: 'descripcion_es')
  String get descripcionEs => throw _privateConstructorUsedError;
  @JsonKey(name: 'descripcion_en')
  String get descripcionEn => throw _privateConstructorUsedError;

  /// Serializes this GlossaryTerm to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GlossaryTerm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GlossaryTermCopyWith<GlossaryTerm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GlossaryTermCopyWith<$Res> {
  factory $GlossaryTermCopyWith(
    GlossaryTerm value,
    $Res Function(GlossaryTerm) then,
  ) = _$GlossaryTermCopyWithImpl<$Res, GlossaryTerm>;
  @useResult
  $Res call({
    String id,
    String termino,
    @JsonKey(name: 'descripcion_es') String descripcionEs,
    @JsonKey(name: 'descripcion_en') String descripcionEn,
  });
}

/// @nodoc
class _$GlossaryTermCopyWithImpl<$Res, $Val extends GlossaryTerm>
    implements $GlossaryTermCopyWith<$Res> {
  _$GlossaryTermCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GlossaryTerm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? termino = null,
    Object? descripcionEs = null,
    Object? descripcionEn = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            termino: null == termino
                ? _value.termino
                : termino // ignore: cast_nullable_to_non_nullable
                      as String,
            descripcionEs: null == descripcionEs
                ? _value.descripcionEs
                : descripcionEs // ignore: cast_nullable_to_non_nullable
                      as String,
            descripcionEn: null == descripcionEn
                ? _value.descripcionEn
                : descripcionEn // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GlossaryTermImplCopyWith<$Res>
    implements $GlossaryTermCopyWith<$Res> {
  factory _$$GlossaryTermImplCopyWith(
    _$GlossaryTermImpl value,
    $Res Function(_$GlossaryTermImpl) then,
  ) = __$$GlossaryTermImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String termino,
    @JsonKey(name: 'descripcion_es') String descripcionEs,
    @JsonKey(name: 'descripcion_en') String descripcionEn,
  });
}

/// @nodoc
class __$$GlossaryTermImplCopyWithImpl<$Res>
    extends _$GlossaryTermCopyWithImpl<$Res, _$GlossaryTermImpl>
    implements _$$GlossaryTermImplCopyWith<$Res> {
  __$$GlossaryTermImplCopyWithImpl(
    _$GlossaryTermImpl _value,
    $Res Function(_$GlossaryTermImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GlossaryTerm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? termino = null,
    Object? descripcionEs = null,
    Object? descripcionEn = null,
  }) {
    return _then(
      _$GlossaryTermImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        termino: null == termino
            ? _value.termino
            : termino // ignore: cast_nullable_to_non_nullable
                  as String,
        descripcionEs: null == descripcionEs
            ? _value.descripcionEs
            : descripcionEs // ignore: cast_nullable_to_non_nullable
                  as String,
        descripcionEn: null == descripcionEn
            ? _value.descripcionEn
            : descripcionEn // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GlossaryTermImpl implements _GlossaryTerm {
  const _$GlossaryTermImpl({
    required this.id,
    required this.termino,
    @JsonKey(name: 'descripcion_es') required this.descripcionEs,
    @JsonKey(name: 'descripcion_en') required this.descripcionEn,
  });

  factory _$GlossaryTermImpl.fromJson(Map<String, dynamic> json) =>
      _$$GlossaryTermImplFromJson(json);

  @override
  final String id;
  @override
  final String termino;
  @override
  @JsonKey(name: 'descripcion_es')
  final String descripcionEs;
  @override
  @JsonKey(name: 'descripcion_en')
  final String descripcionEn;

  @override
  String toString() {
    return 'GlossaryTerm(id: $id, termino: $termino, descripcionEs: $descripcionEs, descripcionEn: $descripcionEn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GlossaryTermImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.termino, termino) || other.termino == termino) &&
            (identical(other.descripcionEs, descripcionEs) ||
                other.descripcionEs == descripcionEs) &&
            (identical(other.descripcionEn, descripcionEn) ||
                other.descripcionEn == descripcionEn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, termino, descripcionEs, descripcionEn);

  /// Create a copy of GlossaryTerm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GlossaryTermImplCopyWith<_$GlossaryTermImpl> get copyWith =>
      __$$GlossaryTermImplCopyWithImpl<_$GlossaryTermImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GlossaryTermImplToJson(this);
  }
}

abstract class _GlossaryTerm implements GlossaryTerm {
  const factory _GlossaryTerm({
    required final String id,
    required final String termino,
    @JsonKey(name: 'descripcion_es') required final String descripcionEs,
    @JsonKey(name: 'descripcion_en') required final String descripcionEn,
  }) = _$GlossaryTermImpl;

  factory _GlossaryTerm.fromJson(Map<String, dynamic> json) =
      _$GlossaryTermImpl.fromJson;

  @override
  String get id;
  @override
  String get termino;
  @override
  @JsonKey(name: 'descripcion_es')
  String get descripcionEs;
  @override
  @JsonKey(name: 'descripcion_en')
  String get descripcionEn;

  /// Create a copy of GlossaryTerm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GlossaryTermImplCopyWith<_$GlossaryTermImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
