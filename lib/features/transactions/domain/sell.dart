import 'package:freezed_annotation/freezed_annotation.dart';

part 'sell.freezed.dart';
part 'sell.g.dart';

@freezed
class Sell with _$Sell {
  const factory Sell({
    required String id,
    @JsonKey(name: 'exec_at') required DateTime execAt,
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'crypt_id') required String cryptId,
    @JsonKey(name: 'unit_yen') required double unitYen,
    required double amount,
    required double yen,
    @JsonKey(name: 'commission_id') String? commissionId,
    double? profit,
    @JsonKey(name: 'swap_id') String? swapId,
    required String type,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Sell;

  factory Sell.fromJson(Map<String, dynamic> json) => _$SellFromJson(json);
}
