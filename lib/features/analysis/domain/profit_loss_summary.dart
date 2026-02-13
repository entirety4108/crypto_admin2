import 'package:freezed_annotation/freezed_annotation.dart';

part 'profit_loss_summary.freezed.dart';
part 'profit_loss_summary.g.dart';

@freezed
class ProfitLossSummary with _$ProfitLossSummary {
  const factory ProfitLossSummary({
    @JsonKey(name: 'total_realized_pnl') required double totalRealizedPnl,
    @JsonKey(name: 'total_unrealized_pnl') required double totalUnrealizedPnl,
    @JsonKey(name: 'total_pnl') required double totalPnl,
    int? year,
  }) = _ProfitLossSummary;

  factory ProfitLossSummary.fromJson(Map<String, dynamic> json) =>
      _$ProfitLossSummaryFromJson(json);
}
