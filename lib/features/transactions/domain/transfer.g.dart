// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferImpl _$$TransferImplFromJson(Map<String, dynamic> json) =>
    _$TransferImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fromAccountId: json['from_account_id'] as String,
      toAccountId: json['to_account_id'] as String,
      cryptId: json['crypt_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      execAt: DateTime.parse(json['exec_at'] as String),
      feeCryptId: json['fee_crypt_id'] as String?,
      feeAmount: (json['fee_amount'] as num?)?.toDouble(),
      memo: json['memo'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$TransferImplToJson(_$TransferImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'from_account_id': instance.fromAccountId,
      'to_account_id': instance.toAccountId,
      'crypt_id': instance.cryptId,
      'amount': instance.amount,
      'exec_at': instance.execAt.toIso8601String(),
      'fee_crypt_id': instance.feeCryptId,
      'fee_amount': instance.feeAmount,
      'memo': instance.memo,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
