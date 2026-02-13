import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_crypt_category.freezed.dart';
part 'user_crypt_category.g.dart';

@freezed
class UserCryptCategory with _$UserCryptCategory {
  const factory UserCryptCategory({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'category_id') required String categoryId,
    @JsonKey(name: 'crypt_id') required String cryptId,
  }) = _UserCryptCategory;

  factory UserCryptCategory.fromJson(Map<String, dynamic> json) =>
      _$UserCryptCategoryFromJson(json);
}
