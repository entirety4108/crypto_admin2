import 'package:freezed_annotation/freezed_annotation.dart';

part 'portfolio_summary.freezed.dart';
part 'portfolio_summary.g.dart';

@freezed
class PortfolioSummary with _$PortfolioSummary {
  const factory PortfolioSummary({
    @JsonKey(name: 'total_value_jpy') required double totalValueJpy,
    @JsonKey(name: 'total_cost_basis_jpy') required double totalCostBasisJpy,
    @JsonKey(name: 'total_profit_loss_jpy') required double totalProfitLossJpy,
    @JsonKey(name: 'profit_loss_percentage') required double profitLossPercentage,
    @JsonKey(name: 'last_updated') required DateTime lastUpdated,
  }) = _PortfolioSummary;

  factory PortfolioSummary.fromJson(Map<String, dynamic> json) =>
      _$PortfolioSummaryFromJson(json);
}
