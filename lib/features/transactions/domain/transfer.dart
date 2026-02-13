import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer.freezed.dart';
part 'transfer.g.dart';

@freezed
class Transfer with _$Transfer {
  const factory Transfer({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'from_account_id') required String fromAccountId,
    @JsonKey(name: 'to_account_id') required String toAccountId,
    @JsonKey(name: 'crypt_id') required String cryptId,
    required double amount,
    @JsonKey(name: 'exec_at') required DateTime execAt,
    @JsonKey(name: 'fee_crypt_id') String? feeCryptId,
    @JsonKey(name: 'fee_amount') double? feeAmount,
    String? memo,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Transfer;

  factory Transfer.fromJson(Map<String, dynamic> json) =>
      _$TransferFromJson(json);
}
