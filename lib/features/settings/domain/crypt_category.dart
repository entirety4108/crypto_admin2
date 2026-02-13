import 'package:freezed_annotation/freezed_annotation.dart';

part 'crypt_category.freezed.dart';
part 'crypt_category.g.dart';

@freezed
class CryptCategory with _$CryptCategory {
  const factory CryptCategory({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    required String color,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _CryptCategory;

  factory CryptCategory.fromJson(Map<String, dynamic> json) =>
      _$CryptCategoryFromJson(json);
}
