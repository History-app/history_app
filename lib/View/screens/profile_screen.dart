import 'package:flutter/material.dart';
import '../../Model/widgets/common_app_bar.dart';
import 'package:gap/gap.dart';
import 'package:japanese_history_app/constant/app_strings.dart';
import 'package:japanese_history_app/View/widgets/promotion_card.dart';
import '../../Model/Color/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:japanese_history_app/common/ui_helper.dart';
import '../screens/modal.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: Strings.myPageTitle,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              // Centerを削除
              crossAxisAlignment: CrossAxisAlignment.start, // 左揃えに設定
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // タップ時の処理
                      // AccountDeletedModal.show(context);
                    },
                    child: Container(
                      width: 325,
                      height: 115,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors().grey,
                          width: 1,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: <Widget>[
                          Gap(25),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors().grey,
                                width: 1,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.asset(
                                'assets/Frame 18.png',
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 17),
                            height: 80,
                            width: 178,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Gap(12),
                                Text(
                                  Strings.alan,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Gap(8),
                                Text(
                                  // '無料会員',
                                  Strings.mascotAlanMessage,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 26,
                            width: 26,
                            // child: Icon(
                            //   Icons.arrow_forward_ios,
                            //   color: AppColors().grey,
                            // ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Gap(29),
                // Container(
                //   padding: EdgeInsets.only(left: 34, right: 34),
                //   height: 40,
                //   width: MediaQuery.of(context).size.width,
                //   child: Row(
                //     children: [
                //       GestureDetector(
                //         onTap: () {
                //           // タップ時の処理
                //           // AccountDeletedModal.show(context);
                //         },
                //         child: Container(
                //           decoration: BoxDecoration(
                //             color: AppColors().pale_profile_grey,
                //             borderRadius: BorderRadius.circular(8),
                //           ),
                //           width: 146,
                //           height: 40,
                //           child: Row(
                //             children: [
                //               Gap(9),
                //               Container(
                //                 width: 24,
                //                 height: 24,
                //                 child: Icon(
                //                   Icons.emoji_events,
                //                   color: AppColors().accentYellow,
                //                 ),
                //               ),
                //               Gap(4),
                //               Center(
                //                 child: Text('日本史_テスト'),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //       Spacer(),
                //       GestureDetector(
                //         onTap: () {
                //           // タップ時の処理
                //           AccountDeletedModal.show(context);
                //         },
                //         child: Container(
                //           decoration: BoxDecoration(
                //             color: AppColors().pale_profile_grey,
                //             borderRadius: BorderRadius.circular(8),
                //           ),
                //           width: 146,
                //           height: 40,
                //           child: Row(
                //             children: [
                //               Gap(9),
                //               Container(
                //                 width: 24,
                //                 height: 24,
                //                 child: Icon(
                //                   Icons.military_tech,
                //                   color: AppColors().accentYellow,
                //                 ),
                //               ),
                //               Gap(9),
                //               Center(
                //                 child: Text('ランキング'),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Gap(45),
                // Center(
                //   // 中央寄せにしたいウィジェット
                //   child: GestureDetector(
                //     onTap: () {
                //       // タップ時の処理をここに記述
                //       AccountDeletedModal.show(context);
                //     },
                //     child: Container(
                //       width: 326,
                //       height: 40,
                //       child: Row(
                //         children: [
                //           Container(
                //             width: 40,
                //             height: 40,
                //             child: Icon(
                //               Icons.settings,
                //               color: Colors.grey,
                //               size: 30,
                //             ),
                //           ),
                //           Gap(12),
                //           Text(
                //             '設定',
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // // 他の中央寄せにしたいウィジェットも同様に囲む
                // Gap(40),
                // Center(
                //   child: GestureDetector(
                //     onTap: () {
                //       // タップ時の処理
                //       AccountDeletedModal.show(context);
                //     },
                //     child: Container(
                //       width: 326,
                //       height: 40,
                //       child: Row(
                //         children: [
                //           Container(
                //             width: 40,
                //             height: 40,
                //             child: Icon(
                //               Icons.notifications_active,
                //               color: Colors.grey,
                //               size: 30,
                //             ),
                //           ),
                //           Gap(12),
                //           Text(
                //             'お知らせ',
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // Gap(40),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      // タップ時の処理
                      // AccountDeletedModal.show(context);
                      final Uri url = Uri.parse(
                          'https://docs.google.com/forms/d/e/1FAIpQLSccWw_Owr7y5U6MkFc6WqG7R2yazkjIc2l4sdRq7BNcvVBGLA/viewform?fbzx=-373354133227981354');

                      // ここを修正：LaunchMode.externalApplicationを明示的に使用
                      if (!await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication, // 内部ブラウザではなく外部ブラウザを開く
                      )) {
                        // if (context.mounted) {
                        //   // コンテキストが有効か確認
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(content: Text('URLを開けませんでした')),
                        //   );
                        // }
                      }
                    },
                    child: SizedBox(
                      width: 326,
                      height: 40,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.chat_bubble_outline,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                          Gap(12),
                          Text(
                            Strings.contactForm,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 393,
                  height: 140,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      children: [
                        FeaturePromotionCard(
                          backgroundColor: AppColors().primaryRed,
                          title: Text(
                            Strings.learningHint,
                            style: GoogleFonts.notoSansJp(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          description: Strings.dailyStudyMessage,
                          imageAssetPath: "assets/alan_good.png",
                        ),
                        horizontalSpace,
                        GestureDetector(
                          onTap: () {
                            // タップ時の処理
                            // AccountDeletedModal.show(context);
                          },
                          child: SizedBox(
                            width: 186,
                            height: 92,
                            child: Image.asset(
                              'assets/Frame 44.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Gap(15),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 34.0),
                  child: GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse(
                          'https://organic-orchid-846.notion.site/1d3bfeefad1a8027b47bc6a5ac29e9b6');

                      // ここを修正：LaunchMode.externalApplicationを明示的に使用
                      if (!await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication, // 内部ブラウザではなく外部ブラウザを開く
                      )) {
                        if (context.mounted) {
                          // コンテキストが有効か確認
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text(Strings.failedToOpenUrlMessage)),
                          );
                        }
                      }
                    },
                    child: SizedBox(
                      width: 108,
                      height: 40,
                      child: Text(
                        Strings.termsOfService,
                        style: TextStyle(
                          color: Colors.black, // リンクであることを示す
                          decoration: TextDecoration.underline, // 下線を追加
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 34.0),
                  child: GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse(
                          'https://www.notion.so/1d3bfeefad1a80dda3b3dbe4d229bd75'); // プライバシーポリシーのURLを設定

                      // 外部ブラウザで開く設定
                      if (!await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      )) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text(Strings.failedToOpenUrlMessage)),
                          );
                        }
                      }
                    },
                    child: SizedBox(
                      width: 139,
                      height: 40,
                      child: Text(
                        Strings.privacyPolicyTitle,
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline, // リンクであることを示す下線
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
