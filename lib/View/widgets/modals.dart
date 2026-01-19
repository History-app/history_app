import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:japanese_history_app/enums/email_account_enum.dart';
import 'package:japanese_history_app/viewmodel/email_account/email_account_view_model.dart';
import 'package:japanese_history_app/view/widgets/history_button.dart';
import 'package:japanese_history_app/configs/navigation_service.dart';
import 'package:japanese_history_app/constant/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:japanese_history_app/configs/app_color.dart';
import 'package:japanese_history_app/model/color/app_colors.dart';
import 'package:japanese_history_app/providers/user_provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future needDeleteGuestAccount(BuildContext context, WidgetRef ref) async {
  await showDialog<Dialog>(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Column(
            children: [
              const Spacer(),
              const Text(
                "ログインするには",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "現在のゲストとしてのデータを\n削除する必要があります。",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SecondaryButton(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 55,
                    text: "キャンセル",
                    onPressed: () async {
                      return Navigator.of(context).pop();
                    },
                  ),
                  Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05)),
                  DangerButton(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 55,
                    isTap: true,
                    text: "削除の確認",
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await NavigationService.pushNamed(ScreenRoutes.accountDelete);
                    },
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      );
    },
  );
}

class DeletedAccountLoadingModal extends HookConsumerWidget {
  const DeletedAccountLoadingModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(userModelProvider.select((state) => state.isLoggedIn()));
    print('isLoggedIn: $isLoggedIn');

    useEffect(() {
      Future.microtask(() async {
        print('ここを実行中');
        await ref.read(userModelProvider.notifier).deleteAccount();
        await CookieManager.instance().deleteAllCookies();
      });
      return;
    }, const []);

    return isLoggedIn
        ? Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              height: 163,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Center(
                child: Center(
                  child: SpinKitWave(
                    color: Theme.of(context).primaryColor,
                    duration: const Duration(milliseconds: 600),
                  ),
                ),
              ),
            ),
          )
        : Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              height: 163,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 32, bottom: 14),
                    child: Text(Strings.accountDeletedModalTitle, textAlign: TextAlign.center),
                  ),
                  GestureDetector(
                    onTap: () async {
                      ref
                          .read(emailAccountViewModelProvider.notifier)
                          .setActiveType(EmailAccountActiveType.signIn);
                      NavigationService.pushNamed(ScreenRoutes.emailAccount);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      height: 51,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        border: Border.all(color: AppColor.gray.shade300),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        Strings.goToNext,
                        style: TextStyle(
                          color: AppColor.gray.shade400,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

void showSignOutModal(BuildContext context, WidgetRef ref) {
  showDialog<dynamic>(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Container(
          width: double.infinity,
          height: 162,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColor.white),
          padding: const EdgeInsets.only(top: 32),
          child: Column(
            children: [
              Text(
                Strings.accountLogoutModalTitle,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Padding(padding: EdgeInsets.only(top: 30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: 150,
                      height: 51,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        border: Border.all(color: AppColor.gray.shade300),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        Strings.cancel,
                        style: TextStyle(
                          color: AppColor.gray.shade400,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await ref.read(userModelProvider.notifier).signOut();
                      ref.read(userModelProvider.notifier).signInAnonymously();

                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: 150,
                      height: 51,
                      decoration: BoxDecoration(
                        color: AppColors().primaryRed.withValues(alpha: 0.89),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        Strings.logout,
                        style: const TextStyle(
                          color: AppColor.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
