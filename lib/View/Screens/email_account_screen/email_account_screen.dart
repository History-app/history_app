import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:japanese_history_app/view/widgets/history_button.dart';
import 'package:japanese_history_app/model/color/app_colors.dart';
import 'package:japanese_history_app/configs/app_color.dart';
import 'package:japanese_history_app/constant/app_strings.dart';
import 'package:japanese_history_app/view/widgets/mail_app_picker_modal.dart';
import 'package:japanese_history_app/enums/email_account_enum.dart';
import 'package:japanese_history_app/viewmodel/email_account/email_account_view_model.dart';
import 'package:japanese_history_app/view/widgets/over_lay_loading.dart';
import 'package:japanese_history_app/configs/navigation_service.dart';
import 'package:japanese_history_app/view/widgets/modals.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:japanese_history_app/configs/custom_color_selection_handle.dart';

part 'app_bar.dart';
// part 'widgets/jump_faq.dart';
part 'mail_button.dart';
part 'main_area.dart';
part 'modals.dart';

class EmailAccountScreen extends HookConsumerWidget {
  const EmailAccountScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(emailAccountViewModelProvider.notifier);
    final state = ref.watch(emailAccountViewModelProvider);
    // final formKey = useMemoized(() => GlobalKey<FormState>());
    final formKey = useRef(GlobalKey<FormState>()).value;

    Future<void>.delayed(Duration.zero, () async {
      if (state.isShowMailAppPickerModal) {
        vm.setIsShowMailAppPickerModal(false);
        print('trueになった');
        mailAppPickerModal(context);
      }
      if (state.isSucceededUpdateEmail) {
        vm.setIsSucceededUpdateEmail(false);
        await NavigationService.pushReplacementNamed(ScreenRoutes.succeededSignUp);
      }
      if (state.isSucceededSignUp) {
        vm.setIsSucceededSignUp(value: false);
        Navigator.of(context).pop();
        // await NavigationService.pushReplacementNamed(ScreenRoutes.main);
      }
      if (state.isSucseedSignIn) {
        vm.setIsSucceededSignIn(value: false);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();

        // await NavigationService.pushReplacementNamed(ScreenRoutes.main);
      }
      if (state.isShowAccountDeleteModal) {
        vm.setIsShowAccountDeleteModal(false);
        return showDialog(context: context, builder: (_) => const _DeleteAccountModal());
      }
      if (state.isShowNotExistsUserModal) {
        vm.setIsShowNotExistsUserModal(false);
        return showDialog(context: context, builder: (_) => const _NotExistsUserModal());
      }
    });

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: _AppBar(
            activeType: state.activeType,
            isSended: state.isSended,
            onPressed: () {
              vm.onTapCloseAppBar();
              Navigator.pop(context);
            },
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(20),
                if (state.isSended) ...[
                  _SendMainArea(emailText: state.emailText),
                  const Gap(15),
                  // _JumpFAQ(
                  //   onTap: () async {
                  //     final url = Uri.parse(external_links.tayoriURL);
                  //     await gaAnalyticsService.sendWebEvent(url: external_links.tayoriURL);
                  //     await launchUrl(url);
                  //   },
                  // ),
                  const Spacer(),
                  _OpenMailButton(onPressed: vm.onTapOpenMailButton),
                ] else ...[
                  _EmailInputArea(
                    formKey: formKey,
                    initialValue: state.emailText,
                    activeType: state.activeType,
                    emailTextEditingController: vm.emailTextEditingController,
                    validator: (v) =>
                        state.isEmailChecked && !state.isValidEmail ? '無効なメールアドレスです' : null,
                    onChanged: vm.setEmailText,
                    focusNode: vm.focusNode,
                  ),
                  const Spacer(),
                  _SendMailButton(
                    activeType: state.activeType,
                    isButtonEnabled: state.emailText.isNotEmpty,
                    onPressed: () => vm.onTapSendMailButton(formKey),
                  ),
                ],
                const Gap(50),
              ],
            ),
          ),
        ),
        if (state.isLoading) Positioned.fill(child: OverLayLoading()),
      ],
    );
  }
}
