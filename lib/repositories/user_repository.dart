import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/user/user.dart' as app_user;
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Stream<app_user.User> userStream;

  UserRepository() {
    initState();
  }

  void initState() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      userStream = Stream.error('未ログイン');
    } else {
      userStream =
          _firestore.collection('users').doc(uid).snapshots().map((doc) {
        if (!doc.exists || doc.data() == null) {
          return app_user.User(uid: uid, nullCount: 5);
        }

        final data = doc.data()!;

        return app_user.User.fromJson({
          'uid': doc.id,
          'nullCount': data['nullCount'] ?? 5,
        });
      });
    }
  }

  Future<void> setNullCount(int value) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return Future.error('未ログイン');

    return _firestore.collection('users').doc(uid).set(
      {'nullCount': value},
      SetOptions(merge: true),
    );
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});
