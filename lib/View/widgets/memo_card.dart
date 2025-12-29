import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:japanese_history_app/constant/app_strings.dart';
import '../../Model/Color/app_colors.dart';
import '../../Model/text_styles.dart';

class MemoCard extends StatelessWidget {
  final String? memoText;

  const MemoCard({
    super.key,
    this.memoText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: AppColors().paleRed,
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                  width: 260,
                  height: 39,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(8),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Text(Strings.memo,
                            style: AppTextStyles.sourceSansProBold24.copyWith(
                              fontSize: 24,
                              height: 1.0,
                            )),
                      ),
                      Container(
                        width: 250,
                        height: 1,
                        color: AppColors().primaryRed,
                      )
                    ],
                  ))
            ],
          ),
          Gap(14),
          Padding(
            padding: const EdgeInsets.only(left: 17, right: 17),
            child: Text(
              memoText ?? '',
              style: AppTextStyles.hiraginoW4.copyWith(
                fontSize: 24,
                height: 1.0,
              ),
            ),
          ),
          Gap(24),
        ],
      ),
    );
  }
}
