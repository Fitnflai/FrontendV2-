// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreditCardImpl _$$CreditCardImplFromJson(Map<String, dynamic> json) =>
    _$CreditCardImpl(
      id: json['id'] as String,
      brand: json['brand'] as String,
      lastFour: json['lastFour'] as String,
      expMonth: json['expMonth'] as String,
      expYear: json['expYear'] as String,
      holderName: json['holderName'] as String?,
    );

Map<String, dynamic> _$$CreditCardImplToJson(_$CreditCardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'brand': instance.brand,
      'lastFour': instance.lastFour,
      'expMonth': instance.expMonth,
      'expYear': instance.expYear,
      'holderName': instance.holderName,
    };
