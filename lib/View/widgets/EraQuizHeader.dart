import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Model/text_styles.dart';
import 'package:gap/gap.dart';
import '../../Model/Color/app_colors.dart';
import '../screens/modal.dart';

class EraQuizHeader extends StatelessWidget {
  const EraQuizHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: 360,
      child: Row(
        children: [
          Container(
            width: 256,
            height: 56,
            padding: EdgeInsets.only(top: 24, left: 16),
            child: Text(
              '時代別一問一答',
              style: AppTextStyles.notoSansDisplay.copyWith(fontSize: 16),
            ),
          ),
          SizedBox(
            height: 56,
            width: 104,
            child: Column(
              children: [
                Gap(20),
                GestureDetector(
                  onTap: () {
                    AccountDeletedModal.show(context);
                  },
                  child: Row(
                    children: [
                      //ここの全てみる機能は一旦実装しない
                      Gap(20), // 間隔を追加
                      // Text(
                      //   'すべて見る',
                      //   style: AppTextStyles.hiraginoW4.copyWith(
                      //     fontSize: 14,
                      //     color: AppColors().primaryRed, // 色を指定
                      //   ),
                      // ),
                      SizedBox(width: 4), // 間隔を追加
                      // SizedBox(
                      //   width: 6,
                      //   height: 8,
                      //   child: SvgPicture.asset('assets/Vector 1.svg'),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
