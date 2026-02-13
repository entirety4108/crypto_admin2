// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypt_holding.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CryptHoldingImpl _$$CryptHoldingImplFromJson(Map<String, dynamic> json) =>
    _$CryptHoldingImpl(
      cryptId: json['crypt_id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      avgCostBasisJpy: (json['avg_cost_basis_jpy'] as num).toDouble(),
      currentPriceJpy: (json['current_price_jpy'] as num).toDouble(),
      valueJpy: (json['value_jpy'] as num).toDouble(),
      profitLossJpy: (json['profit_loss_jpy'] as num).toDouble(),
      profitLossPercentage: (json['profit_loss_percentage'] as num).toDouble(),
      iconUrl: json['icon_url'] as String?,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$$CryptHoldingImplToJson(_$CryptHoldingImpl instance) =>
    <String, dynamic>{
      'crypt_id': instance.cryptId,
      'symbol': instance.symbol,
      'name': instance.name,
      'amount': instance.amount,
      'avg_cost_basis_jpy': instance.avgCostBasisJpy,
      'current_price_jpy': instance.currentPriceJpy,
      'value_jpy': instance.valueJpy,
      'profit_loss_jpy': instance.profitLossJpy,
      'profit_loss_percentage': instance.profitLossPercentage,
      'icon_url': instance.iconUrl,
      'color': instance.color,
    };
