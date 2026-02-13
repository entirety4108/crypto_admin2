import 'package:freezed_annotation/freezed_annotation.dart';

part 'crypt_holding.freezed.dart';
part 'crypt_holding.g.dart';

@freezed
class CryptHolding with _$CryptHolding {
  const factory CryptHolding({
    @JsonKey(name: 'crypt_id') required String cryptId,
    required String symbol,
    required String name,
    required double amount,
    @JsonKey(name: 'avg_cost_basis_jpy') required double avgCostBasisJpy,
    @JsonKey(name: 'current_price_jpy') required double currentPriceJpy,
    @JsonKey(name: 'value_jpy') required double valueJpy,
    @JsonKey(name: 'profit_loss_jpy') required double profitLossJpy,
    @JsonKey(name: 'profit_loss_percentage') required double profitLossPercentage,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? color,
  }) = _CryptHolding;

  factory CryptHolding.fromJson(Map<String, dynamic> json) =>
      _$CryptHoldingFromJson(json);
}
