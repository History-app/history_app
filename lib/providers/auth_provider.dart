import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:japanese_history_app/enums/email_account_enum.dart';
import 'package:japanese_history_app/repositories/user_repository.dart';
import 'package:japanese_history_app/viewmodel/email_account/email_account_view_model.dart';
// import 'package:funwork/utils/services/auth_service.dart';
import 'package:japanese_history_app/util/services/af_analytics_service.dart';
import 'package:japanese_history_app/providers/user_provider.dart';
import 'package:japanese_history_app/viewmodel/view_models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'auth_provider.freezed.dart';

enum AuthStatus { none, notSignedIn, signedIn }

@freezed
abstract class AuthState with _$AuthState {
  const AuthState._();
  const factory AuthState({@Default(AuthStatus.none) AuthStatus authStatus}) = _AuthState;
}

final authModelProvider = AsyncNotifierProvider<AuthModel, AuthState>(AuthModel.new);

class AuthModel extends AsyncNotifier<AuthState> {
  final _firebaseAuth = auth.FirebaseAuth.instance;
  final _afService = afService;

  late final StreamSubscription<DeepLinkData> _linkSub;
  late final StreamSubscription<auth.User?> _authSub;
  final completer = Completer<AuthState>();

  @override
  Future<AuthState> build() async {
    await _afService.initFuture;

    _linkSub = _afService.deepLinkStream.listen(_onDeepLink);

    final fbUser = await _firebaseAuth.authStateChanges().first;
    final initialState = _stateFromUser(fbUser);
    state = AsyncData(initialState);

    _authSub = _firebaseAuth.authStateChanges().listen((fbUser) {
      final next = _stateFromUser(fbUser);
      state = AsyncData(next);
      if (fbUser != null) {
        ref.read(userModelProvider.notifier).streamUser();
      }
    });

    ref.onDispose(() {
      _linkSub.cancel();
      _authSub.cancel();
    });

    return initialState;
  }

  AuthState _stateFromUser(auth.User? fbUser) {
    if (fbUser == null) {
      // Sentry.configureScope((s) => s.setUser(null));
      return const AuthState(authStatus: AuthStatus.notSignedIn);
    }
    // Sentry.configureScope((s) => s.setUser(SentryUser(id: fbUser.uid, email: fbUser.email)));
    FirebaseCrashlytics.instance.setUserIdentifier(fbUser.uid);
    final userUid = fbUser.uid;
    print('userUid:$userUid');
    // gaAnalyticsService.setUserId(userId: userUid);
    // afService.setUserId(userId: userUid);
    return const AuthState(authStatus: AuthStatus.signedIn);
  }

  Future<void> _onDeepLink(DeepLinkData data) async {
    final emailNotifier = ref.read(emailAccountViewModelProvider.notifier);
    try {
      print('🔥 DEEPLINK STREAM FIRED');
      print('オコオコ');
      final email = data.email;
      final link = data.link;
      emailNotifier.setIsLoading(true);

      // authenticate をエラーコード付きに変更

      final errorCode = await UserRepository().authenticateWithCode(email: email, link: link);

      if (errorCode == null) {
        final activeType = ref.read(emailAccountViewModelProvider).activeType;
        switch (activeType) {
          case EmailAccountActiveType.signUp:
            ref.read(userModelProvider.notifier).signUpWithEmailAccount(email);
            break;
          case EmailAccountActiveType.signIn:
            print('サインイン');
            ref.read(userModelProvider.notifier).signInWithEmailAccount(email);
            break;
          case EmailAccountActiveType.updateEmail:
            ref.read(userModelProvider.notifier).updateEmailAccount(email);
            break;
          case EmailAccountActiveType.delete:
            emailNotifier.setIsShowAccountDeleteModal(true);
            break;
        }
      } else {
        emailNotifier.setErrorMessage(emailNotifier.getErrorMessage(errorCode));
        // final isDoneTutorial = ref.read(userModelProvider).isDoneTutorial;
        // if (!isDoneTutorial) {
        //   NavigationService.showModal(ModalRoutes.flaseAuthEmailTutorialModal);
        // } else {
        //   NavigationService.showModal(ModalRoutes.flaseAuthEmailModal);
        // }
      }
    } on Exception catch (e) {
      // await _crashlyticsService.recordError(e, s, 'authModelProvider _onDeepLink');
      emailNotifier.setErrorMessage('予期せぬエラーが発生しました。しばらくしてから再度お試しください。');
      // final isDoneTutorial = ref.read(userProvider).isDoneTutorial;
      // if (!isDoneTutorial) {
      //   NavigationService.showModal(ModalRoutes.flaseAuthEmailTutorialModal);
      // } else {
      //   NavigationService.showModal(ModalRoutes.flaseAuthEmailModal);
      // }
    } finally {
      emailNotifier.setIsLoading(false);
    }
  }

  Future<String?> sendAuthEmailLinks(String email) async {
    try {
      print('実行');
      final result = await FirebaseFunctions.instanceFor(
        region: 'asia-northeast1',
      ).httpsCallable('createAuthEmailLink').call(<String, dynamic>{'email': email});
      print('result,${result.data}');
      final ok = (result.data as Map)['success'] as bool? ?? false;
      return ok ? null : 'user_not_exists';
    } catch (e) {
      return 'unknown_error';
    }
  }

  Future<String?> sendAuthEmailLink(String email) async {
    try {
      final url =
          'https://${dotenv.env['AF_BRANDED_DOMAIN']}'
          '/${dotenv.env['AF_ONELINK_PATH']}'
          '?deep_link_value=signin';

      print('URL: $url');

      final actionCodeSettings = auth.ActionCodeSettings(
        url: url,
        handleCodeInApp: true,
        iOSBundleId: dotenv.env['IOS_BUNDLE_ID'],
        androidPackageName: dotenv.env['ANDROID_PACKAGE_NAME'],
        androidInstallApp: true,
        androidMinimumVersion: '1',
      );
      print('成');
      await _firebaseAuth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );
      print('成功');
      return null; // 成功
    } on auth.FirebaseAuthException catch (e) {
      // Firebase Auth の公式エラーコード
      return e.code; // email-already-in-use / invalid-email など
    } catch (e) {
      return 'unknown_error';
    }
  }
}
