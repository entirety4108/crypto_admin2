import 'package:freezed_annotation/freezed_annotation.dart';

part 'crypt.freezed.dart';
part 'crypt.g.dart';

@freezed
class Crypt with _$Crypt {
  const factory Crypt({
    required String id,
    required String symbol,
    @JsonKey(name: 'project_name') String? projectName,
    @JsonKey(name: 'icon_url') String? iconUrl,
    String? color,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'coingecko_id') String? coingeckoId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Crypt;

  factory Crypt.fromJson(Map<String, dynamic> json) => _$CryptFromJson(json);
}
