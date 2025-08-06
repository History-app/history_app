import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../Model/Color/app_colors.dart';
import '../../Model/text_styles.dart';
import 'package:ruby_text/ruby_text.dart';

class AnswerCard extends StatelessWidget {
  final List<String> questionText;
  final String starImagePath;
  final String theme;

  const AnswerCard({
    super.key,
    required this.questionText,
    required this.starImagePath,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: AppColors().primaryRed,
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 68.04,
                height: 24.8,
                child: Image.asset(starImagePath),
              ),
              Gap(42),
              SizedBox(
                  width: 243,
                  height: 39,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Gap(4),
                      Text((theme),
                          style: AppTextStyles.sourceSansProBold24.copyWith(
                            fontSize: 24,
                            height: 1.0,
                          )),
                      Container(
                        width: 250,
                        height: 1,
                        color: AppColors().primaryRed,
                      ),
                    ],
                  ))
            ],
          ),
          Gap(14),
          Padding(
            padding: const EdgeInsets.only(left: 17, right: 17),
            child: Center(
              child: Transform.translate(
                offset: const Offset(0, -5), // Y方向に-10ピクセル移動（上に移動）
                child: RubyText(
                  [
                    RubyTextData(
                      questionText.isNotEmpty ? questionText[0] : '', // 安全対策
                      ruby: questionText.length > 1
                          ? questionText[1]
                          : null, // 安全対策
                      style: AppTextStyles.hiraginoW4.copyWith(
                        fontSize: 24,
                        height: 1.0,
                      ),
                      rubyStyle: AppTextStyles.hiraginoW4.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Gap(24),
        ],
      ),
    );
  }
}
