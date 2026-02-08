import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase.freezed.dart';
part 'purchase.g.dart';

@freezed
class Purchase with _$Purchase {
  const factory Purchase({
    required String id,
    @JsonKey(name: 'exec_at') required DateTime execAt,
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'crypt_id') required String cryptId,
    @JsonKey(name: 'unit_yen') required double unitYen,
    required double amount,
    @JsonKey(name: 'deposit_yen') required double depositYen,
    @JsonKey(name: 'purchase_yen') required double purchaseYen,
    @JsonKey(name: 'commission_id') String? commissionId,
    required String type,
    @JsonKey(name: 'airdrop_type') int? airdropType,
    @JsonKey(name: 'airdrop_profit') double? airdropProfit,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Purchase;

  factory Purchase.fromJson(Map<String, dynamic> json) =>
      _$PurchaseFromJson(json);
}
