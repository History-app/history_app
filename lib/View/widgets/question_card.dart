import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../Model/Color/app_colors.dart';
import '../../Model/text_styles.dart';

class QuestionCard extends StatelessWidget {
  final String questionText;
  final String starImagePath;
  final bool isAiQuestion;

  const QuestionCard({
    super.key,
    required this.questionText,
    required this.starImagePath,
    required this.isAiQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: AppColors().primaryRed, width: 2.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 68.04, height: 24.8, child: Image.asset(starImagePath)),
          Gap(14),
          Padding(
            padding: const EdgeInsets.only(left: 17, right: 17),
            child: isAiQuestion
                ? Text(
                    questionText,
                    style: AppTextStyles.hiraginoW4.copyWith(fontSize: 24, height: 1),
                  )
                : SelectableText(
                    questionText,
                    style: AppTextStyles.hiraginoW4.copyWith(fontSize: 24, height: 1),
                  ),
          ),
          Gap(24),
        ],
      ),
    );
  }
}
