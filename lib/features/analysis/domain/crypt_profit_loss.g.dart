// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypt_profit_loss.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CryptProfitLossImpl _$$CryptProfitLossImplFromJson(
  Map<String, dynamic> json,
) => _$CryptProfitLossImpl(
  cryptId: json['crypt_id'] as String,
  symbol: json['symbol'] as String,
  iconUrl: json['icon_url'] as String?,
  realizedPnl: (json['realized_pnl'] as num).toDouble(),
  unrealizedPnl: (json['unrealized_pnl'] as num).toDouble(),
  totalPnl: (json['total_pnl'] as num).toDouble(),
);

Map<String, dynamic> _$$CryptProfitLossImplToJson(
  _$CryptProfitLossImpl instance,
) => <String, dynamic>{
  'crypt_id': instance.cryptId,
  'symbol': instance.symbol,
  'icon_url': instance.iconUrl,
  'realized_pnl': instance.realizedPnl,
  'unrealized_pnl': instance.unrealizedPnl,
  'total_pnl': instance.totalPnl,
};
