import 'dart:io';

import 'package:flutter/material.dart';
import 'package:japanese_history_app/model/color/app_colors.dart';
import 'package:japanese_history_app/configs/navigation_service.dart';
import 'package:japanese_history_app/constant/app_strings.dart';
import 'package:japanese_history_app/configs/navigation_service.dart';
import 'package:japanese_history_app/view/account_delete/widgets/app_bar.dart';
import 'package:japanese_history_app/view/screens/email_account_screen/email_account_screen.dart';
import 'package:japanese_history_app/viewmodel/email_account/email_account_view_model.dart';
import 'package:japanese_history_app/view/widgets/modals.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/user_provider.dart';

import 'package:japanese_history_app/view/widgets/history_button.dart';
import '../../enums/email_account_enum.dart';
import 'package:japanese_history_app/providers/user_provider.dart';

class AccountDeleteScreen extends HookConsumerWidget {
  const AccountDeleteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonsWidth = MediaQuery.of(context).size.width - 32;
    final isDeleteCheck = ref.watch(emailAccountViewModelProvider.select((s) => s.isDeleteCheck));
    final isLinkedEmail = ref.watch(userModelProvider.select((s) => s.isLinkedEmail()));
    // String _purchaseOsSettingName() {
    //   if (Platform.isIOS) {
    //     return Strings.of(context).premiumDetailPurchaseSettingNameByIOS();
    //   } else {
    //     return Strings.of(context).premiumDetailPurchaseSettingNameByAndroid();
    //   }
    // }

    return Scaffold(
      appBar: const AccountDeleteAppBar(),
      backgroundColor: AppColors().white,
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(top: 28)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      Strings.accountDeleteSubTitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors().black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors().primaryRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      //border: Border.all(color: AppColor.gray.shade100),
                    ),
                    child: Column(
                      children: [
                        Text(
                          Strings.accountDeleteWordsDeleteTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors().primaryRed,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 4)),
                        Text(
                          Strings.accountDeleteStockDeleteDesc,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors().black, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  // Container(
                  //   width: double.infinity,
                  //   padding: const EdgeInsets.symmetric(vertical: 12),
                  //   decoration: BoxDecoration(
                  //     color: AppColor.accent.withValues(alpha: 0.1),
                  //     borderRadius: BorderRadius.circular(8),
                  //     //border: Border.all(color: AppColor.gray.shade100),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       Text(
                  //         Strings.of(context).accountDeletePremiumCheckTitle(),
                  //         textAlign: TextAlign.center,
                  //         style: const TextStyle(
                  //           color: AppColor.accent,
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       const Padding(padding: EdgeInsets.only(top: 4)),
                  //       // Text(
                  //       //   Strings.of(
                  //       //     context,
                  //       //   ).accountDeletePremiumCheckDesc(_purchaseOsSettingName()),
                  //       //   textAlign: TextAlign.center,
                  //       //   style: const TextStyle(color: AppColor.black, fontSize: 14),
                  //       // ),
                  //       const Gap(10),
                  //       // PrimaryRoundButton(
                  //       //   width: 180,
                  //       //   height: 50,
                  //       //   onPressed: () async {
                  //       //     if (Platform.isIOS) {
                  //       //       final Uri iosUrl = Uri.parse(
                  //       //         'https://apps.apple.com/account/subscriptions',
                  //       //       );
                  //       //       if (await canLaunchUrl(iosUrl)) {
                  //       //         await launchUrl(iosUrl);
                  //       //       } else {
                  //       //         print('Could not launch $iosUrl');
                  //       //       }
                  //       //     } else {
                  //       //       final Uri androidUrl = Uri.parse(
                  //       //         'https://play.google.com/store/account/subscriptions',
                  //       //       );
                  //       //       if (await canLaunchUrl(androidUrl)) {
                  //       //         await launchUrl(androidUrl);
                  //       //       } else {
                  //       //         print('Could not launch $androidUrl');
                  //       //       }
                  //       //     }
                  //       //   },
                  //       //   text: Strings.of(context).accountDeletePremiumCheckButton(),
                  //       //   buttonColor: AppColor.accent,
                  //       // ),
                  //     ],
                  //   ),
                  // ),
                  const Padding(padding: EdgeInsets.only(top: 26)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: isDeleteCheck,
                        focusColor: AppColors().primaryRed,
                        activeColor: AppColors().primaryRed,
                        onChanged: (value) => ref
                            .read(emailAccountViewModelProvider.notifier)
                            .setIsDeleteCheck(value: value),
                      ),
                      Text(Strings.accountDeleteCheckBoxTitle),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 90)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SecondaryButton(
                        width: buttonsWidth * 0.4,
                        height: 55,
                        text: Strings.cancel,
                        onPressed: () async {
                          return Navigator.of(context).pop();
                        },
                      ),
                      Padding(padding: EdgeInsets.only(left: buttonsWidth * 0.05)),
                      DangerButton(
                        width: buttonsWidth * 0.4,
                        height: 55,
                        text: Strings.delete,
                        isTap: isDeleteCheck,
                        onPressed: () async {
                          if (isDeleteCheck == true) {
                            if (isLinkedEmail == true) {
                              print('ここではないよ');
                              ref
                                  .read(emailAccountViewModelProvider.notifier)
                                  .setActiveType(EmailAccountActiveType.delete);
                              final email = ref.read(userModelProvider).email;
                              if (email.isEmpty) {
                                //ないとは思うけど
                                print('メールアドレスがありません');
                                return;
                              }
                              await ref
                                  .read(emailAccountViewModelProvider.notifier)
                                  .setEmailText(email);
                              await NavigationService.pushNamed(ScreenRoutes.emailAccount);
                            } else {
                              print('ここだよ');
                              await showDialog<dynamic>(
                                context: context,
                                builder: (_) => DeletedAccountLoadingModal(),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 40)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
