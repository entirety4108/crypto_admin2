// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sell.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SellImpl _$$SellImplFromJson(Map<String, dynamic> json) => _$SellImpl(
  id: json['id'] as String,
  execAt: DateTime.parse(json['exec_at'] as String),
  accountId: json['account_id'] as String,
  cryptId: json['crypt_id'] as String,
  unitYen: (json['unit_yen'] as num).toDouble(),
  amount: (json['amount'] as num).toDouble(),
  yen: (json['yen'] as num).toDouble(),
  commissionId: json['commission_id'] as String?,
  profit: (json['profit'] as num?)?.toDouble(),
  swapId: json['swap_id'] as String?,
  type: json['type'] as String,
  userId: json['user_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$SellImplToJson(_$SellImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'exec_at': instance.execAt.toIso8601String(),
      'account_id': instance.accountId,
      'crypt_id': instance.cryptId,
      'unit_yen': instance.unitYen,
      'amount': instance.amount,
      'yen': instance.yen,
      'commission_id': instance.commissionId,
      'profit': instance.profit,
      'swap_id': instance.swapId,
      'type': instance.type,
      'user_id': instance.userId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
