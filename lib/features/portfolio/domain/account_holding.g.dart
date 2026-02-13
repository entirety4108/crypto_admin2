// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_holding.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountHoldingImpl _$$AccountHoldingImplFromJson(Map<String, dynamic> json) =>
    _$AccountHoldingImpl(
      accountId: json['account_id'] as String,
      name: json['name'] as String,
      holdings: (json['holdings'] as List<dynamic>)
          .map((e) => CryptHolding.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalValueJpy: (json['total_value_jpy'] as num).toDouble(),
      totalProfitLossJpy: (json['total_profit_loss_jpy'] as num).toDouble(),
      iconUrl: json['icon_url'] as String?,
    );

Map<String, dynamic> _$$AccountHoldingImplToJson(
  _$AccountHoldingImpl instance,
) => <String, dynamic>{
  'account_id': instance.accountId,
  'name': instance.name,
  'holdings': instance.holdings,
  'total_value_jpy': instance.totalValueJpy,
  'total_profit_loss_jpy': instance.totalProfitLossJpy,
  'icon_url': instance.iconUrl,
};
