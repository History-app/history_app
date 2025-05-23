part of '../screens/home_screen.dart';

class CustomCard extends ConsumerWidget {
  const CustomCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final distribution =
        ref.watch(cardsDataNotifierProvider).leftValueDistribution;
    print('これがdistributionです$distribution');
    final nullCount = distribution[null] ?? 0;
    final learningCount = (distribution[2001] ?? 0) +
        (distribution[1001] ?? 0) +
        (distribution[2002] ?? 0);
    final reviewCount = distribution[0] ?? 0;
    final studyButtonKey =
        ref.watch(tutorialProvider.notifier).getStudyButtonKey();
    return SizedBox(
      width: 370,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: [
            Container(
              width: 370,
              height: 180,
              color: AppColors().preRed,
              child: Center(
                //元の画像コンテナ
                child: Container(
                  width: 120,
                  height: 180,
                  child: Stack(
                    children: [
                      // 元の画像
                      Image.asset('assets/text_date.png'),

                      // Column使用して51pxの位置に配置
                      Column(
                        children: [
                          // 上部の空白スペース（51px）
                          Gap(51),

                          // 追加したいContainer
                          Row(
                            children: [
                              Gap(4),
                              Container(
                                width: 55.2, // 必要な幅
                                height: 20.8, // 必要な高さ
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  color: Colors.black,
                                ),
                                // 必要なコンテンツ
                                child: Center(
                                  child: Text(
                                    DateFormat('M/d').format(DateTime.now()),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // タイトル
            Container(
              width: double.infinity,
              height: 72,
              color: Colors.white,
              child: Column(
                children: [
                  Gap(16),
                  Row(
                    children: [
                      Gap(12),
                      Container(
                        width: 40,
                        height: 40,
                      ),
                      Gap(8),
                      Container(
                        width: 183,
                        height: 36,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 18,
                              child: Text(
                                '日本史探究 一問一答',
                                style: AppTextStyles.hiraginoW7.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Container(
                              height: 18,
                              child: Row(
                                children: [
                                  Text(
                                    '新規',
                                    style: AppTextStyles.hiraginoW6.copyWith(
                                      fontSize: 14,
                                      color: AppColors().menu_Grey,
                                    ),
                                  ),
                                  Text(
                                    '$nullCount  ',
                                    style: AppTextStyles.hiraginoW6.copyWith(
                                      fontSize: 14,
                                      color: AppColors().blue,
                                    ),
                                  ),
                                  Text(
                                    '習得中',
                                    style: AppTextStyles.hiraginoW6.copyWith(
                                      fontSize: 14,
                                      color: AppColors().menu_Grey,
                                    ),
                                  ),
                                  Text(
                                    '$learningCount  ',
                                    style: AppTextStyles.hiraginoW6.copyWith(
                                      fontSize: 14,
                                      color: AppColors().primaryRed,
                                    ),
                                  ),
                                  Text(
                                    '復習',
                                    style: AppTextStyles.hiraginoW6.copyWith(
                                      fontSize: 14,
                                      color: AppColors().menu_Grey,
                                    ),
                                  ),
                                  Text(
                                    '$reviewCount',
                                    style: AppTextStyles.hiraginoW6.copyWith(
                                      fontSize: 14,
                                      color: AppColors().green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(37),
                      GestureDetector(
                        key: studyButtonKey,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudyingScreen(),
                            ),
                          );
                          print('学習ボタンがタップされました');
                        },
                        child: Container(
                          width: 72,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors().primaryRed,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(
                            child: Text(
                              '学習',
                              style: AppTextStyles.hiraginoW7.copyWith(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(16)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
