// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypt_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CryptCategoryImpl _$$CryptCategoryImplFromJson(Map<String, dynamic> json) =>
    _$CryptCategoryImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      color: json['color'] as String,
      iconUrl: json['icon_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$CryptCategoryImplToJson(_$CryptCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'color': instance.color,
      'icon_url': instance.iconUrl,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
