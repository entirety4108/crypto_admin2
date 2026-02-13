// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_with_crypts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryWithCryptsImpl _$$CategoryWithCryptsImplFromJson(
  Map<String, dynamic> json,
) => _$CategoryWithCryptsImpl(
  category: CryptCategory.fromJson(json['category'] as Map<String, dynamic>),
  crypts: (json['crypts'] as List<dynamic>)
      .map((e) => Crypt.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$CategoryWithCryptsImplToJson(
  _$CategoryWithCryptsImpl instance,
) => <String, dynamic>{
  'category': instance.category,
  'crypts': instance.crypts,
};
