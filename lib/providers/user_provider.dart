import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../repositories/user_repository.dart';
import 'package:japanese_history_app/viewmodel/email_account/email_account_view_model.dart';
import '../model/user/user.dart';

final userModelProvider = StateNotifierProvider<UserModel, User>((ref) => UserModel(ref));

class UserModel extends StateNotifier<User> {
  UserModel(this.ref) : super(const User()) {
    () async {
      await initState();
    }();
  }

  final Ref ref;
  final _repository = UserRepository();

  Future<void> initState() async {
    await streamUser();
  }

  Future<void> streamUser() async {
    try {
      final streamUser = await _repository.streamUser();
      streamUser.listen((user) async {
        if (user != null) {
          state = user;
        }
      });
    } on Exception catch (e) {}
  }

  Future<bool> signInAnonymously() async {
    final firebaseUser = await _repository.signInAnonymously();
    if (firebaseUser == null) return false;

    state = state.copyWith(uid: firebaseUser.uid, email: firebaseUser.email ?? '');

    return true;
  }

  Future signOut() async {
    try {
      await _repository.deleteLocalData();
      await _repository.signOut();
      state = state.copyWith(uid: '');
    } on Exception catch (e) {}
  }

  /// userProvider の中で使える関数
  Future<bool> existsUserCheckWithEmail(String email) async {
    try {
      final callable = FirebaseFunctions.instanceFor(
        region: 'asia-northeast1',
      ).httpsCallable('existsUserCheckWithEmail');

      final result = await callable.call(email);
      print('result,$result');

      final exists = result.data == true;

      return exists;
    } on FirebaseFunctionsException catch (e) {
      print('エラー,$e');
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signUpWithEmailAccount(String email) async {
    try {
      ref.read(emailAccountViewModelProvider.notifier).setIsSucceededSignUp(value: true);
      ref.read(emailAccountViewModelProvider.notifier).setIsSended(false);

      return true;
    } on Exception catch (e) {
      // await _crashlyticsService.recordError(e, s, 'userProvider signUpWithEmailLink');
      return false;
    }
  }

  Future<bool> signInWithEmailAccount(String email) async {
    try {
      final uid = await UserRepository().getUserUid();
      if (uid != null) {
        // final ver = state.createAppVersion;
        // if (ver > 128) {
        //   afService.sendSignIn(email: email);
        //   afService.setUserEmails(email: email);
        // }
        ref.read(emailAccountViewModelProvider.notifier).setIsSucceededSignIn(value: true);
        ref.read(emailAccountViewModelProvider.notifier).setIsSended(false);
        return true;
      }
      return false;
    } on Exception catch (e) {
      // await _crashlyticsService.recordError(e, s, 'userProvider signUpWithEmailLink');
      return false;
    }
  }

  Future deleteAccount() async {
    try {
      await _repository.deleteLocalData();
      await _repository.delete();

      print('ここも実行中');
      state = state.copyWith(uid: '');
    } on Exception catch (e) {
      // await _crashlyticsService.recordError(e, s, 'userProvider deleteAccount');
    }
  }

  Future setEmail(String value) async {
    try {
      print('setEmail:$value');
      state = state.copyWith(email: value);
      await _repository.updateUser('email', value);
    } on Exception catch (e) {
      // await _crashlyticsService.recordError(e, s, 'userProvider setEmail');
    }
  }

  Future<bool> updateEmailAccount(String email) async {
    try {
      final uid = await UserRepository().getUserUid();
      if (uid != null) {
        // setMyTimeZone();
        // saveAppVersion();
        // saveCreateAppVersion();

        setEmail(email);
        // afService.sendCreateAccount();
        // afService.sendSignUp();
        // afService.setUserEmails(email: email);
      }

      ref.read(emailAccountViewModelProvider.notifier).setIsSucceededUpdateEmail(true);
      ref.read(emailAccountViewModelProvider.notifier).setIsSended(false);
      return true;
    } on Exception catch (e) {
      // await _crashlyticsService.recordError(e, s, 'userProvider signUpWithEmailLink');
      return false;
    }
  }
}
