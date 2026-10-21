// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'credit_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CreditCard _$CreditCardFromJson(Map<String, dynamic> json) {
  return _CreditCard.fromJson(json);
}

/// @nodoc
mixin _$CreditCard {
  String get id => throw _privateConstructorUsedError;
  String get brand => throw _privateConstructorUsedError;
  String get lastFour => throw _privateConstructorUsedError;
  String get expMonth => throw _privateConstructorUsedError;
  String get expYear => throw _privateConstructorUsedError;
  String? get holderName => throw _privateConstructorUsedError;

  /// Serializes this CreditCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreditCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreditCardCopyWith<CreditCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreditCardCopyWith<$Res> {
  factory $CreditCardCopyWith(
    CreditCard value,
    $Res Function(CreditCard) then,
  ) = _$CreditCardCopyWithImpl<$Res, CreditCard>;
  @useResult
  $Res call({
    String id,
    String brand,
    String lastFour,
    String expMonth,
    String expYear,
    String? holderName,
  });
}

/// @nodoc
class _$CreditCardCopyWithImpl<$Res, $Val extends CreditCard>
    implements $CreditCardCopyWith<$Res> {
  _$CreditCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreditCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? brand = null,
    Object? lastFour = null,
    Object? expMonth = null,
    Object? expYear = null,
    Object? holderName = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            brand: null == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                      as String,
            lastFour: null == lastFour
                ? _value.lastFour
                : lastFour // ignore: cast_nullable_to_non_nullable
                      as String,
            expMonth: null == expMonth
                ? _value.expMonth
                : expMonth // ignore: cast_nullable_to_non_nullable
                      as String,
            expYear: null == expYear
                ? _value.expYear
                : expYear // ignore: cast_nullable_to_non_nullable
                      as String,
            holderName: freezed == holderName
                ? _value.holderName
                : holderName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreditCardImplCopyWith<$Res>
    implements $CreditCardCopyWith<$Res> {
  factory _$$CreditCardImplCopyWith(
    _$CreditCardImpl value,
    $Res Function(_$CreditCardImpl) then,
  ) = __$$CreditCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String brand,
    String lastFour,
    String expMonth,
    String expYear,
    String? holderName,
  });
}

/// @nodoc
class __$$CreditCardImplCopyWithImpl<$Res>
    extends _$CreditCardCopyWithImpl<$Res, _$CreditCardImpl>
    implements _$$CreditCardImplCopyWith<$Res> {
  __$$CreditCardImplCopyWithImpl(
    _$CreditCardImpl _value,
    $Res Function(_$CreditCardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreditCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? brand = null,
    Object? lastFour = null,
    Object? expMonth = null,
    Object? expYear = null,
    Object? holderName = freezed,
  }) {
    return _then(
      _$CreditCardImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        brand: null == brand
            ? _value.brand
            : brand // ignore: cast_nullable_to_non_nullable
                  as String,
        lastFour: null == lastFour
            ? _value.lastFour
            : lastFour // ignore: cast_nullable_to_non_nullable
                  as String,
        expMonth: null == expMonth
            ? _value.expMonth
            : expMonth // ignore: cast_nullable_to_non_nullable
                  as String,
        expYear: null == expYear
            ? _value.expYear
            : expYear // ignore: cast_nullable_to_non_nullable
                  as String,
        holderName: freezed == holderName
            ? _value.holderName
            : holderName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreditCardImpl implements _CreditCard {
  const _$CreditCardImpl({
    required this.id,
    required this.brand,
    required this.lastFour,
    required this.expMonth,
    required this.expYear,
    this.holderName,
  });

  factory _$CreditCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreditCardImplFromJson(json);

  @override
  final String id;
  @override
  final String brand;
  @override
  final String lastFour;
  @override
  final String expMonth;
  @override
  final String expYear;
  @override
  final String? holderName;

  @override
  String toString() {
    return 'CreditCard(id: $id, brand: $brand, lastFour: $lastFour, expMonth: $expMonth, expYear: $expYear, holderName: $holderName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreditCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.lastFour, lastFour) ||
                other.lastFour == lastFour) &&
            (identical(other.expMonth, expMonth) ||
                other.expMonth == expMonth) &&
            (identical(other.expYear, expYear) || other.expYear == expYear) &&
            (identical(other.holderName, holderName) ||
                other.holderName == holderName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    brand,
    lastFour,
    expMonth,
    expYear,
    holderName,
  );

  /// Create a copy of CreditCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreditCardImplCopyWith<_$CreditCardImpl> get copyWith =>
      __$$CreditCardImplCopyWithImpl<_$CreditCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreditCardImplToJson(this);
  }
}

abstract class _CreditCard implements CreditCard {
  const factory _CreditCard({
    required final String id,
    required final String brand,
    required final String lastFour,
    required final String expMonth,
    required final String expYear,
    final String? holderName,
  }) = _$CreditCardImpl;

  factory _CreditCard.fromJson(Map<String, dynamic> json) =
      _$CreditCardImpl.fromJson;

  @override
  String get id;
  @override
  String get brand;
  @override
  String get lastFour;
  @override
  String get expMonth;
  @override
  String get expYear;
  @override
  String? get holderName;

  /// Create a copy of CreditCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreditCardImplCopyWith<_$CreditCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
