import 'package:flutter/material.dart';
import 'package:japanese_history_app/providers/auth_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../enums/email_account_enum.dart';
import 'package:japanese_history_app/providers/user_provider.dart';
import 'package:japanese_history_app/model/email_account/email_account_state.dart';

final emailAccountViewModelProvider = NotifierProvider<EmailAccountViewModel, EmailAccountState>(
  EmailAccountViewModel.new,
);

class EmailAccountViewModel extends Notifier<EmailAccountState> {
  @override
  EmailAccountState build() {
    final String email = ref.read(userModelProvider).email ?? '';
    emailTextEditingController.text = email;
    ref.onDispose(() {
      resetState();
    });
    return EmailAccountState(emailText: email);
  }

  final emailTextEditingController = TextEditingController();
  final displayNameTextEditingController = TextEditingController();
  final focusNode = FocusNode();

  Future sendEmail(String email) async {
    try {
      if (state.activeType == EmailAccountActiveType.signIn) {
        print('こk');
        final isExistsUser = await ref
            .read(userModelProvider.notifier)
            .existsUserCheckWithEmail(email);
        if (!isExistsUser) {
          setIsShowNotExistsUserModal(true);
          print('ここ');
          return;
        }
      }

      final errorCode = await ref.read(authModelProvider.notifier).sendAuthEmailLinks(email);

      print('個ここ');

      if (errorCode == null) {
        setIsSended(true);
        print('エラーコードなし');
      } else {
        setErrorMessage(getErrorMessage(errorCode));
        // final isDoneTutorial = ref.read(userModelProvider).isDoneTutorial;
        // if (!isDoneTutorial) {
        //   NavigationService.showModal(ModalRoutes.flaseAuthEmailTutorialModal);
        // } else {
        //   NavigationService.showModal(ModalRoutes.flaseAuthEmailModal);
        // }
      }
    } on Exception catch (e, s) {
      // await _crashlyticsService.recordError(e, s, 'emailAccountViewModelProvider onTapMailButton');
      setErrorMessage(getErrorMessage(e.toString()));
      // final isDoneTutorial = ref.read(userModelProvider).isDoneTutorial;
      // if (!isDoneTutorial) {
      //   NavigationService.showModal(ModalRoutes.flaseAuthEmailTutorialModal);
      // } else {
      //   NavigationService.showModal(ModalRoutes.flaseAuthEmailModal);
      // }
      return;
    }
  }

  Future onTapOpenMailButton() async {
    try {
      setIsShowMailAppPickerModal(true);
    } on Exception catch (e, s) {
      // await _crashlyticsService.recordError(
      //   e,
      //   s,
      //   'emailAccountViewModelProvider onTapOpenMailButton',
      // );
    }
  }

  Future onTapCloseAppBar() async {
    if (state.isSended) {
      setActiveType(EmailAccountActiveType.signUp);
      setIsSended(false);
    } else {
      resetAccountLinkTextEdigingController();
    }
    setIsValidEmail(true);
    setIsEmailChecked(false);
  }

  void resetAccountLinkTextEdigingController() {
    emailTextEditingController.clear();
    state = state.copyWith(emailText: '');
  }

  void setIsDeleteAccountCheck({bool? value}) {
    state = state.copyWith(isDeleteAccountCheck: value!);
  }

  Future<void> setEmailText(String email) async {
    state = state.copyWith(emailText: email);
    if (state.isEmailChecked) {
      final regExp = RegExp(
        r'^[a-zA-Z0-9.!#$%&‘*+-/=?^_`{|}~]+@[a-zA-Z0-9.!#$%&‘*+-/=?^_`{|}~]+\.[a-zA-Z0-9-]+$',
      );
      final isValidEmail = regExp.hasMatch(email);
      setIsValidEmail(isValidEmail);
    }
  }

  Future<void> onTapSendMailButton(GlobalKey<FormState> formKey) async {
    focusNode.unfocus();
    Future.delayed(const Duration(milliseconds: 100));
    final email = state.emailText;
    final regExp = RegExp(
      r'^[a-zA-Z0-9.!#$%&‘*+-/=?^_`{|}~]+@[a-zA-Z0-9.!#$%&‘*+-/=?^_`{|}~]+\.[a-zA-Z0-9-]+$',
    );
    final isValidEmail = regExp.hasMatch(email);
    setIsValidEmail(isValidEmail);
    setIsEmailChecked(true);

    /// stateの更新を待つ
    await Future.delayed(const Duration(milliseconds: 300));
    formKey.currentState?.validate();
    if (isValidEmail) {
      setIsLoading(true);
      await sendEmail(email);
      setIsLoading(false);
      print('メール送信:$email');
    }
  }

  void setActiveType(EmailAccountActiveType value) {
    state = state.copyWith(activeType: value);
  }

  void setIsLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  void setIsSended(bool value) {
    state = state.copyWith(isSended: value);
  }

  void setIsValidEmail(bool value) {
    state = state.copyWith(isValidEmail: value);
  }

  void setIsEmailChecked(bool value) {
    state = state.copyWith(isEmailChecked: value);
  }

  void setIsShowNotExistsUserModal(bool value) {
    state = state.copyWith(isShowNotExistsUserModal: value);
  }

  void setIsShowMailAppPickerModal(bool value) {
    state = state.copyWith(isShowMailAppPickerModal: value);
  }

  Future setIsSucceededSignUp({required bool value}) async {
    state = state.copyWith(isSucceededSignUp: value);
  }

  void setIsSucceededSignIn({required bool value}) {
    state = state.copyWith(isSucseedSignIn: value);
  }

  void setIsSucceededUpdateEmail(bool value) {
    state = state.copyWith(isSucceededUpdateEmail: value);
  }

  void setIsShowAccountDeleteModal(bool value) {
    state = state.copyWith(isShowAccountDeleteModal: value);
  }

  void setErrorMessage(String value) {
    state = state.copyWith(errorMessage: value);
  }

  void setIsDeleteCheck({bool? value}) {
    state = state.copyWith(isDeleteCheck: value!);
  }

  void resetState() {
    state = const EmailAccountState();
  }

  String getErrorMessage(String code) {
    switch (code) {
      case 'unauthenticated':
        return 'セッションの有効期限が切れています。\n最新のメールかご確認の上、再度お試しください。';
      case 'deadline-exceeded':
        return 'サーバーへの接続がタイムアウトしました。\n通信環境をご確認のうえ、再度お試しください。';
      case 'not-found':
        return 'サーバーが見つかりません。\nしばらく経ってから再度お試しください。';
      case 'permission-denied':
        return 'リクエストを処理できませんでした。\n解決しない場合はお問い合わせまでご連絡ください。';
      case 'user_not_exists':
        return '未登録のメールアドレスです。\n"初めての方は「新規登録して始める」から入力してご確認ください。';
      case 'internal':
        return 'サーバー側で問題が発生しました。しばらく時間を置いてから再度お試しください。';
      case 'invalid-email-link':
        return '無効なリンクです。最新のメールを開いてから再度お試しください。';
      case 'user-disabled':
        return 'このアカウントは無効化されています。サポートまでお問い合わせください。';
      case 'user-not-found':
        return '指定されたメールアドレスのアカウントが見つかりません。';
      case 'expired-action-code':
        return 'リンクの有効期限が切れています。再度メールを送信してください。';
      case 'unauthorized-domain':
        return 'この認証は許可されていないドメインから行われました。';
      case 'network-request-failed':
        return '通信に失敗しました。ネットワーク環境をご確認のうえ、再度お試しください。';
      case 'email-already-in-use':
        return 'このメールアドレスはすでに使用されています。別のメールアドレスをお試しください。';
      default:
        return '認証中にエラーが発生しました。しばらく経ってから再度お試しください。';
    }
  }
}
