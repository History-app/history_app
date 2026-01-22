import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const User._();
  const factory User({
    String? uid,
    @Default(5) int nullCount,
    @Default("旧石器") String startEra,
    @Default('') String email,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  factory User.fromDocumentSnapshot(DocumentSnapshot doc) {
    final json = doc.data()! as Map<String, dynamic>;
    json['uid'] = doc.id;
    return User.fromJson(json);
  }
  bool isLinkedEmail() => email != '';

  bool isLoggedIn() {
    return uid != '';
  }
}
