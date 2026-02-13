// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_profit_loss.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountProfitLossImpl _$$AccountProfitLossImplFromJson(
  Map<String, dynamic> json,
) => _$AccountProfitLossImpl(
  accountId: json['account_id'] as String,
  name: json['name'] as String,
  realizedPnl: (json['realized_pnl'] as num).toDouble(),
  unrealizedPnl: (json['unrealized_pnl'] as num).toDouble(),
  totalPnl: (json['total_pnl'] as num).toDouble(),
);

Map<String, dynamic> _$$AccountProfitLossImplToJson(
  _$AccountProfitLossImpl instance,
) => <String, dynamic>{
  'account_id': instance.accountId,
  'name': instance.name,
  'realized_pnl': instance.realizedPnl,
  'unrealized_pnl': instance.unrealizedPnl,
  'total_pnl': instance.totalPnl,
};
