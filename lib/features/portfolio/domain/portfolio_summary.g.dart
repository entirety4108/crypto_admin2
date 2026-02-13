// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PortfolioSummaryImpl _$$PortfolioSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$PortfolioSummaryImpl(
  totalValueJpy: (json['total_value_jpy'] as num).toDouble(),
  totalCostBasisJpy: (json['total_cost_basis_jpy'] as num).toDouble(),
  totalProfitLossJpy: (json['total_profit_loss_jpy'] as num).toDouble(),
  profitLossPercentage: (json['profit_loss_percentage'] as num).toDouble(),
  lastUpdated: DateTime.parse(json['last_updated'] as String),
);

Map<String, dynamic> _$$PortfolioSummaryImplToJson(
  _$PortfolioSummaryImpl instance,
) => <String, dynamic>{
  'total_value_jpy': instance.totalValueJpy,
  'total_cost_basis_jpy': instance.totalCostBasisJpy,
  'total_profit_loss_jpy': instance.totalProfitLossJpy,
  'profit_loss_percentage': instance.profitLossPercentage,
  'last_updated': instance.lastUpdated.toIso8601String(),
};
