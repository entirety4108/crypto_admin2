// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyBalanceImpl _$$DailyBalanceImplFromJson(Map<String, dynamic> json) =>
    _$DailyBalanceImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      accountId: json['account_id'] as String,
      cryptId: json['crypt_id'] as String,
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
      unitPrice: (json['unit_price'] as num).toDouble(),
      valuation: (json['valuation'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$DailyBalanceImplToJson(_$DailyBalanceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'account_id': instance.accountId,
      'crypt_id': instance.cryptId,
      'date': instance.date.toIso8601String(),
      'amount': instance.amount,
      'unit_price': instance.unitPrice,
      'valuation': instance.valuation,
      'created_at': instance.createdAt.toIso8601String(),
    };
