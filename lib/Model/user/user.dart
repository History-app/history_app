import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

part 'user.g.dart';

@Freezed()
class User with _$User {
  @JsonSerializable(explicitToJson: true)
  const factory User(
      {required String uid, @Default(5) int nullCount, @Default("旧石器") String startEra}) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
