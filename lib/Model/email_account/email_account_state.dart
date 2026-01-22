// Flutter imports:
import 'package:flutter/foundation.dart';
// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../enums/email_account_enum.dart';

part 'email_account_state.freezed.dart';

@freezed
abstract class EmailAccountState with _$EmailAccountState {
  const EmailAccountState._();
  const factory EmailAccountState({
    @Default(false) bool isLoading,
    @Default(false) bool isSended,
    @Default(true) bool isValidEmail,
    @Default(false) bool isEmailChecked,
    @Default(false) bool isShowNotExistsUserModal,
    @Default(false) bool isShowMailAppPickerModal,
    @Default(false) bool isDisplayNameEditing,
    @Default(false) bool isSucceededSignUp,
    @Default(false) bool isSucceededUpdateEmail,
    @Default(false) bool isSucseedSignIn,
    @Default(false) bool isDeleteAccountCheck,
    @Default(false) bool isShowAccountDeleteModal,
    @Default(false) bool isDeleteCheck,
    @Default('') String emailText,
    @Default('') String errorMessage,
    @Default(EmailAccountActiveType.signUp) EmailAccountActiveType activeType,
  }) = _EmailAccountState;
}
