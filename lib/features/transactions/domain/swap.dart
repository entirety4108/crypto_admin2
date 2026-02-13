import 'package:freezed_annotation/freezed_annotation.dart';

import 'purchase.dart';
import 'sell.dart';

part 'swap.freezed.dart';
part 'swap.g.dart';

@freezed
class Swap with _$Swap {
  const factory Swap({
    required String id,
    @JsonKey(name: 'sell_id') required String sellId,
    @JsonKey(name: 'buy_id') required String buyId,
    @JsonKey(name: 'exec_at') required DateTime execAt,
    String? memo,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Swap;

  factory Swap.fromJson(Map<String, dynamic> json) => _$SwapFromJson(json);
}

class SwapWithDetails {
  const SwapWithDetails({
    required this.swap,
    required this.sell,
    required this.buy,
  });

  final Swap swap;
  final Sell sell;
  final Purchase buy;

  DateTime get execAt => swap.execAt;
  String get accountId => sell.accountId;
  String get sellCryptId => sell.cryptId;
  String get buyCryptId => buy.cryptId;
  double get profit => sell.profit ?? (sell.yen - buy.purchaseYen);
}
