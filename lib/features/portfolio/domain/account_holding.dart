import 'package:freezed_annotation/freezed_annotation.dart';
import 'crypt_holding.dart';

part 'account_holding.freezed.dart';
part 'account_holding.g.dart';

@freezed
class AccountHolding with _$AccountHolding {
  const factory AccountHolding({
    @JsonKey(name: 'account_id') required String accountId,
    required String name,
    required List<CryptHolding> holdings,
    @JsonKey(name: 'total_value_jpy') required double totalValueJpy,
    @JsonKey(name: 'total_profit_loss_jpy') required double totalProfitLossJpy,
    @JsonKey(name: 'icon_url') String? iconUrl,
  }) = _AccountHolding;

  factory AccountHolding.fromJson(Map<String, dynamic> json) =>
      _$AccountHoldingFromJson(json);
}
