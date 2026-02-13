import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_profit_loss.freezed.dart';
part 'account_profit_loss.g.dart';

@freezed
class AccountProfitLoss with _$AccountProfitLoss {
  const factory AccountProfitLoss({
    @JsonKey(name: 'account_id') required String accountId,
    required String name,
    @JsonKey(name: 'realized_pnl') required double realizedPnl,
    @JsonKey(name: 'unrealized_pnl') required double unrealizedPnl,
    @JsonKey(name: 'total_pnl') required double totalPnl,
  }) = _AccountProfitLoss;

  factory AccountProfitLoss.fromJson(Map<String, dynamic> json) =>
      _$AccountProfitLossFromJson(json);
}
