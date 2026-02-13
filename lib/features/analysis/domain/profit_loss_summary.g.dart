// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profit_loss_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfitLossSummaryImpl _$$ProfitLossSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$ProfitLossSummaryImpl(
  totalRealizedPnl: (json['total_realized_pnl'] as num).toDouble(),
  totalUnrealizedPnl: (json['total_unrealized_pnl'] as num).toDouble(),
  totalPnl: (json['total_pnl'] as num).toDouble(),
  year: (json['year'] as num?)?.toInt(),
);

Map<String, dynamic> _$$ProfitLossSummaryImplToJson(
  _$ProfitLossSummaryImpl instance,
) => <String, dynamic>{
  'total_realized_pnl': instance.totalRealizedPnl,
  'total_unrealized_pnl': instance.totalUnrealizedPnl,
  'total_pnl': instance.totalPnl,
  'year': instance.year,
};
