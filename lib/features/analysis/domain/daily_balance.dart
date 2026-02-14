import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_balance.freezed.dart';
part 'daily_balance.g.dart';

@freezed
class DailyBalance with _$DailyBalance {
  const factory DailyBalance({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'crypt_id') required String cryptId,
    required DateTime date,
    required double amount,
    @JsonKey(name: 'unit_price') required double unitPrice,
    required double valuation,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _DailyBalance;

  factory DailyBalance.fromJson(Map<String, dynamic> json) =>
      _$DailyBalanceFromJson(json);
}
