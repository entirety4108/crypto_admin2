import 'package:freezed_annotation/freezed_annotation.dart';
import '../../transactions/domain/crypt.dart';
import 'crypt_category.dart';

part 'category_with_crypts.freezed.dart';
part 'category_with_crypts.g.dart';

@freezed
class CategoryWithCrypts with _$CategoryWithCrypts {
  const factory CategoryWithCrypts({
    required CryptCategory category,
    required List<Crypt> crypts,
  }) = _CategoryWithCrypts;

  factory CategoryWithCrypts.fromJson(Map<String, dynamic> json) =>
      _$CategoryWithCryptsFromJson(json);
}
