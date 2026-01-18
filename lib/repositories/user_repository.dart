import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user/user.dart' as app_user;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Stream<app_user.User> userStream;
  static final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  UserRepository() {
    initState();
  }
  Future<Stream<app_user.User?>> streamUser() async {
    try {
      final uid = await getUserUid();
      if (uid == null) {
        return const Stream.empty();
      }

      final ref = firestoreInstance
          .collection('users')
          .doc(uid)
          .withConverter(
            fromFirestore: (snapshot, options) => app_user.User.fromDocumentSnapshot(snapshot),
            toFirestore: (app_user.User user, options) => user.toJson(),
          );

      return ref.snapshots().map((doc) {
        if (!doc.exists) return null;

        final user = doc.data();
        if (user == null) return null;

        final email = FirebaseAuth.instance.currentUser?.email;
        if (email == null) {
          return user; // 何もしない
        }

        return user.copyWith(email: email!);
      });
    } catch (e) {
      rethrow;
    }
  }

  void initState() {
    // if (uid == null) {
    //   userStream = Stream.error('未ログイン');
    // } else {
    //   userStream = _firestore.collection('users').doc(uid).snapshots().map((doc) {
    //     final data = doc.data()!;
    //     return app_user.User.fromJson({
    //       'uid': doc.id,
    //       'nullCount': data['nullCount'],
    //       'startEra': data['startEra'] ?? null,
    //     });
    //   });
    // }
  }

  Future<String?> getUserUid() async {
    if (auth.currentUser == null) {
      return null;
    }
    return auth.currentUser!.uid;
  }

  Future<User?> signInAnonymously() async {
    try {
      final signIn = await auth.signInAnonymously();
      return signIn.user;
    } on Exception catch (_) {
      return null;
    }
  }

  Future<String?> authenticateWithCode({required String? email, required Uri? link}) async {
    if (email == null || link == null) {
      return 'invalid-email-link';
    }
    try {
      UserCredential cred;
      final current = auth.currentUser;

      if (current != null && current.isAnonymous) {
        print('ここに行くよ');
        final credential = EmailAuthProvider.credentialWithLink(
          email: email,
          emailLink: link.toString(),
        );
        cred = await current.linkWithCredential(credential);
      } else {
        cred = await auth.signInWithEmailLink(email: email, emailLink: link.toString());
      }
      return cred.user != null ? null : 'user-not-found';
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (_) {
      return 'network-request-failed';
    }
  }

  Future<void> setNullCount(int value) async {
    final uid = await getUserUid();
    if (uid == null) return Future.error('未ログイン');

    return _firestore.collection('users').doc(uid).set({
      'nullCount': value,
    }, SetOptions(merge: true));
  }

  Future<void> setStartEra(String era) async {
    final uid = await getUserUid();
    if (uid == null) return Future.error('未ログイン');

    return _firestore.collection('users').doc(uid).set({'startEra': era}, SetOptions(merge: true));
  }

  Future deleteLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('実行完了');
  }

  Future signOut() async {
    await auth.signOut();
  }

  Future<void> delete() async {
    final user = auth.currentUser;
    if (user == null) {
      print('delete: no current user');
      return;
    }

    print('delete: starting for uid=${user.uid}');
    try {
      // タイムアウトを設けてハングを防ぐ
      await user.delete().timeout(const Duration(seconds: 10));
      print('delete: succeeded');
    } on FirebaseAuthException catch (e) {
      print('delete: FirebaseAuthException code=${e.code} message=${e.message}');
      if (e.code == 'requires-recent-login') {
        // 再認証が必要。呼び出し元で再認証フローを実装するか、管理側で削除してください。
        throw Exception('requires-recent-login');
      }
      rethrow;
    } catch (e, s) {
      print('delete: unknown error $e\n$s');
      rethrow;
    }
  }

  Future updateUser(String index, dynamic data) async {
    try {
      final userUid = await getUserUid();
      if (userUid != null) {
        await _firestore.collection('users').doc(userUid).set(<String, dynamic>{
          'uid': userUid,
          index: data,
          'updatedAt': Timestamp.now(),
        }, SetOptions(merge: true));
      }
    } on Exception catch (e, s) {
      // await _crashlyticsService.recordError(e, s, 'userRepository updateUser');
      rethrow;
    }
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});
