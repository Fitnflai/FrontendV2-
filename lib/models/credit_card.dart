import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_card.freezed.dart';
part 'credit_card.g.dart';

@freezed
abstract class CreditCard with _$CreditCard {
  const factory CreditCard({
    required String id,
    required String brand,
    required String lastFour,
    required String expMonth,
    required String expYear,
    String? holderName,
  }) = _CreditCard;

  factory CreditCard.fromJson(Map<String, dynamic> json) => _$CreditCardFromJson(json);

  factory CreditCard.fromNuveiJson(Map<String, dynamic> json) {
    final expiry = json['expiry'] as String? ?? '';
    final parts = expiry.split('/');
    // Default to "12" and "2029" if expiry is null or malformed
    final expMonth = parts.isNotEmpty ? parts[0] : '12';
    final expYear = parts.length > 1 ? parts[1] : '2029';

    return CreditCard(
      id: json['id_tarjeta_usuario'] as String? ?? json['id'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      lastFour: json['last_four'] as String? ?? '',
      expMonth: expMonth,
      expYear: expYear,
      holderName: json['holder_name'] as String?,
    );
  }
}