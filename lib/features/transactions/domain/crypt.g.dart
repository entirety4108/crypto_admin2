// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CryptImpl _$$CryptImplFromJson(Map<String, dynamic> json) => _$CryptImpl(
  id: json['id'] as String,
  symbol: json['symbol'] as String,
  projectName: json['project_name'] as String?,
  iconUrl: json['icon_url'] as String?,
  color: json['color'] as String?,
  isActive: json['is_active'] as bool,
  coingeckoId: json['coingecko_id'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$CryptImplToJson(_$CryptImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'project_name': instance.projectName,
      'icon_url': instance.iconUrl,
      'color': instance.color,
      'is_active': instance.isActive,
      'coingecko_id': instance.coingeckoId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
