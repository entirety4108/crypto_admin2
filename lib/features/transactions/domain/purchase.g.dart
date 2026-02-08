// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PurchaseImpl _$$PurchaseImplFromJson(Map<String, dynamic> json) =>
    _$PurchaseImpl(
      id: json['id'] as String,
      execAt: DateTime.parse(json['exec_at'] as String),
      accountId: json['account_id'] as String,
      cryptId: json['crypt_id'] as String,
      unitYen: (json['unit_yen'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      depositYen: (json['deposit_yen'] as num).toDouble(),
      purchaseYen: (json['purchase_yen'] as num).toDouble(),
      commissionId: json['commission_id'] as String?,
      type: json['type'] as String,
      airdropType: (json['airdrop_type'] as num?)?.toInt(),
      airdropProfit: (json['airdrop_profit'] as num?)?.toDouble(),
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PurchaseImplToJson(_$PurchaseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'exec_at': instance.execAt.toIso8601String(),
      'account_id': instance.accountId,
      'crypt_id': instance.cryptId,
      'unit_yen': instance.unitYen,
      'amount': instance.amount,
      'deposit_yen': instance.depositYen,
      'purchase_yen': instance.purchaseYen,
      'commission_id': instance.commissionId,
      'type': instance.type,
      'airdrop_type': instance.airdropType,
      'airdrop_profit': instance.airdropProfit,
      'user_id': instance.userId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
