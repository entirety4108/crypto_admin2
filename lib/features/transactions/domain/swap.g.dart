// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swap.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SwapImpl _$$SwapImplFromJson(Map<String, dynamic> json) => _$SwapImpl(
  id: json['id'] as String,
  sellId: json['sell_id'] as String,
  buyId: json['buy_id'] as String,
  execAt: DateTime.parse(json['exec_at'] as String),
  memo: json['memo'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$SwapImplToJson(_$SwapImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sell_id': instance.sellId,
      'buy_id': instance.buyId,
      'exec_at': instance.execAt.toIso8601String(),
      'memo': instance.memo,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
