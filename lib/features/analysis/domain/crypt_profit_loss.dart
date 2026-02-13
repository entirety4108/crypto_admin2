import 'package:freezed_annotation/freezed_annotation.dart';

part 'crypt_profit_loss.freezed.dart';
part 'crypt_profit_loss.g.dart';

@freezed
class CryptProfitLoss with _$CryptProfitLoss {
  const factory CryptProfitLoss({
    @JsonKey(name: 'crypt_id') required String cryptId,
    required String symbol,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'realized_pnl') required double realizedPnl,
    @JsonKey(name: 'unrealized_pnl') required double unrealizedPnl,
    @JsonKey(name: 'total_pnl') required double totalPnl,
  }) = _CryptProfitLoss;

  factory CryptProfitLoss.fromJson(Map<String, dynamic> json) =>
      _$CryptProfitLossFromJson(json);
}
