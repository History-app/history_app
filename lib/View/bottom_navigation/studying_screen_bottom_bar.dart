part of '../screens/studying_screen.dart';

extension StudyingScreenBottomBarExtension on _StudyingScreenState {
  Widget buildBottomNavigationBar(List<String> answerCardQuestionText) {
    final nullCount = leftValueDistribution[null] ?? 0;
    final learningCount =
        (leftValueDistribution[2001] ?? 0) +
        (leftValueDistribution[1001] ?? 0) +
        (leftValueDistribution[2002] ?? 0);
    final reviewCount = leftValueDistribution[0] ?? 0;
    print('answerCardQuestionText,$answerCardQuestionText');

    return !showAdditionalWidgets
        ? Container(
            color: Colors.white,
            height: 84,
            child: Column(
              children: [
                Divider(height: 0.5, thickness: 0.5, color: AppColors().grey),
                Gap(13),
                SizedBox(
                  width: 104,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$nullCount',
                        style: AppTextStyles.sfProSemibold24.copyWith(
                          fontSize: 24,
                          color: AppColors().blue,
                        ),
                      ),
                      Text('+', style: AppTextStyles.sfProSemibold24.copyWith(fontSize: 24)),
                      Text(
                        '$learningCount',
                        style: AppTextStyles.sfProSemibold24.copyWith(
                          fontSize: 24,
                          color: AppColors().primaryRed,
                        ),
                      ),
                      Text('+', style: AppTextStyles.sfProSemibold24.copyWith(fontSize: 24)),
                      Text(
                        '$reviewCount',
                        style: AppTextStyles.sfProSemibold24.copyWith(
                          fontSize: 24,
                          color: AppColors().green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            color: Colors.white,
            height: 84,
            child: Column(
              children: [
                Divider(height: 0.5, thickness: 0.5, color: AppColors().grey),
                Gap(5),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: SizedBox(
                    height: 36,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //もう一度ボタン
                        GestureDetector(
                          onTap: () {
                            if ([2002, 1001, null].contains(carddata[0]['left'])) {
                              // 1分後のタイムスタンプを作成
                              final timestamp1Min = Timestamp.fromDate(
                                DateTime.now().add(Duration(minutes: 1)),
                              );

                              ref
                                  .read(studyingScreenProvider)
                                  .updateCardOnFirestore(
                                    duecards[0]['noteRef'],
                                    1,
                                    1,
                                    dueTimestamp: timestamp1Min,
                                    left: 2002,
                                  );
                            }
                            if ([2001].contains(carddata[0]['left'])) {
                              // 1分後のタイムスタンプを作成
                              final timestamp10Min = Timestamp.fromDate(
                                DateTime.now().add(Duration(minutes: 10)),
                              );

                              ref
                                  .read(studyingScreenProvider)
                                  .updateCardOnFirestore(
                                    duecards[0]['noteRef'],
                                    1,
                                    1,
                                    dueTimestamp: timestamp10Min,
                                    left: 2001,
                                  );
                            }
                            if (carddata[0]['left'] == 0) {
                              final timestamp10Min = Timestamp.fromDate(
                                DateTime.now().add(Duration(minutes: 10)),
                              );

                              final factor = duecards[0]['factor'];
                              final newfactor = factor - 200;
                              ref
                                  .read(studyingScreenProvider)
                                  .updateCardOnFirestore(
                                    duecards[0]['noteRef'],
                                    3,
                                    1,
                                    left: 2001,
                                    dueTimestamp: timestamp10Min,
                                    factor: newfactor,
                                  );
                            }
                            ref
                                .read(cardsDataNewNotifierProvider.notifier)
                                .moveCardBetweenCategories(carddata[0]['type'], 1);

                            ref
                                .read(cardsDataNewNotifierProvider.notifier)
                                .decrementLeftValueCount(carddata[0]['left']);
                            ref.read(cardsDataNewNotifierProvider.notifier).removeFirstCard();

                            setState(() {
                              print(carddata);
                              showAdditionalWidgets = false;
                            });
                            _loadNoteData();
                          },
                          child: Container(
                            width: 80,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors().primaryRed,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Center(
                              child: Column(
                                // または Row、Stack などを使用
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if ([2002, 1001, null].contains(carddata[0]['left']))
                                    Text(
                                      Strings.oneMinute,
                                      style: AppTextStyles.sfProSemibold24.copyWith(
                                        fontSize: 14,
                                        height: 1.0,
                                        color: Colors.white,
                                      ),
                                    )
                                  else if ([2001, 0, null].contains(carddata[0]['left']))
                                    Text(
                                      Strings.tenMinutes,
                                      style: AppTextStyles.sfProSemibold24.copyWith(
                                        fontSize: 14,
                                        height: 1.0,
                                        color: Colors.white,
                                      ),
                                    ),

                                  Text(
                                    Strings.onRetry,
                                    style: AppTextStyles.sfProSemibold24.copyWith(
                                      fontSize: 14,
                                      height: 1.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //難しいボタン
                        GestureDetector(
                          onTap: () {
                            if ([2002, null].contains(carddata[0]['left'])) {
                              final timestamp10Min = Timestamp.fromDate(
                                DateTime.now().add(Duration(minutes: 10)),
                              );

                              ref
                                  .read(studyingScreenProvider)
                                  .updateCardOnFirestore(
                                    duecards[0]['noteRef'],
                                    1,
                                    1,
                                    left: 1001,
                                    dueTimestamp: timestamp10Min,
                                  );
                              ref
                                  .read(cardsDataNewNotifierProvider.notifier)
                                  .moveCardBetweenCategories(carddata[0]['type'], 1);

                              _loadNoteData();
                            }
                            if ([1001, 2001].contains(carddata[0]['left'])) {
                              final timestamp18Hours = Timestamp.fromDate(
                                DateTime.now().add(Duration(hours: 18)),
                              );

                              ref
                                  .read(studyingScreenProvider)
                                  .updateCardOnFirestore(
                                    duecards[0]['noteRef'],
                                    2,
                                    2,
                                    left: 0,
                                    dueTimestamp: timestamp18Hours,
                                  );
                              ref
                                  .read(cardsDataNewNotifierProvider.notifier)
                                  .moveCardBetweenCategories(carddata[0]['type'], 2);
                            }

                            if (carddata[0]['left'] == 0) {
                              final ivl = duecards[0]['ivl'].toDouble();

                              final newfactor = duecards[0]['factor'] - 150;
                              final newivl = ivl * duecards[0]['factor'] / 1000;

                              final double newivlDays = ivl * 1.2;
                              // 小数点以下を保持
                              final double newivlDays2 = ivl + 1;

                              // 大きい方を抽出
                              final double maxNewIvlDays = newivlDays > newivlDays2
                                  ? newivlDays
                                  : newivlDays2;

                              final dueTimestamp = Timestamp.fromDate(
                                DateTime.now().add(
                                  Duration(
                                    hours: (maxNewIvlDays * 24).toInt(), // 日数を時間に変換
                                  ),
                                ),
                              );

                              ref
                                  .read(studyingScreenProvider)
                                  .updateCardOnFirestore(
                                    duecards[0]['noteRef'],
                                    2,
                                    2,
                                    left: 0,
                                    dueTimestamp: dueTimestamp,
                                    ivl: newivl,
                                    factor: newfactor,
                                  );
                              ref
                                  .read(cardsDataNewNotifierProvider.notifier)
                                  .moveCardBetweenCategories(carddata[0]['type'], 2);
                            }
                            ref.read(cardsDataNewNotifierProvider.notifier).removeFirstCard();
                            setState(() {
                              // duecard.removeAt(0);
                              showAdditionalWidgets = false;
                            });
                            _updateLeftValueDistribution();
                            _loadNoteData();
                          },
                          child: Container(
                            width: 80,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if ([2002, null].contains(carddata[0]['left']))
                                    Text(
                                      Strings.tenMinutes,
                                      style: AppTextStyles.sfProSemibold24.copyWith(
                                        fontSize: 14,
                                        height: 1.0,
                                        color: Colors.white,
                                      ),
                                    )
                                  else if ([1001, 2001].contains(carddata[0]['left']))
                                    Text(
                                      Strings.eighteenHours,
                                      style: AppTextStyles.sfProSemibold24.copyWith(
                                        fontSize: 14,
                                        height: 1.0,
                                        color: Colors.white,
                                      ),
                                    )
                                  else if (carddata[0]['left'] == 0)
                                    (() {
                                      final ivl = duecards[0]['ivl'].toDouble();

                                      final double newivlDays = ivl * 1.2;

                                      final double newivlDays2 = ivl + 1;

                                      final double maxNewIvlDays = newivlDays > newivlDays2
                                          ? newivlDays
                                          : newivlDays2;

                                      return Text(
                                        '${maxNewIvlDays.toStringAsFixed(1)}日',
                                        style: AppTextStyles.sfProSemibold24.copyWith(
                                          fontSize: 14,
                                          height: 1.0,
                                          color: Colors.white,
                                        ),
                                      );
                                    })(),
                                  Text(
                                    Strings.hard,
                                    style: AppTextStyles.sfProSemibold24.copyWith(
                                      fontSize: 14,
                                      height: 1.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //正解ボタン
                        GestureDetector(
                          onTap: () {
                            if ([2002, null].contains(carddata[0]['left'])) {
                              final timestamp10Min = Timestamp.fromDate(
                                DateTime.now().add(Duration(minutes: 10)),
                              );

                              ref
                                  .read(studyingScreenProvider)
                                  .updateCardOnFirestore(
                                    duecards[0]['noteRef'],
                                    1,
                                    1,
                                    left: 1001,
                                    dueTimestamp: timestamp10Min,
                                  );
                              ref
                                  .read(cardsDataNewNotifierProvider.notifier)
                                  .moveCardBetweenCategories(carddata[0]['type'], 1);
                              _loadNoteData();
                            }
                            if ([1001, 2001].contains(carddata[0]['left'])) {
                              final timestamp18Hours = Timestamp.fromDate(
                                DateTime.now().add(Duration(hours: 24)),
                              );
                              ref
                                  .read(studyingScreenProvider)
                                  .updateCardOnFirestore(
                                    duecards[0]['noteRef'],
                                    2,
                                    2,
                                    left: 0,
                                    dueTimestamp: timestamp18Hours,
                                  );
                              ref
                                  .read(cardsDataNewNotifierProvider.notifier)
                                  .moveCardBetweenCategories(carddata[0]['type'], 2);
                            }

                            if (carddata[0]['left'] == 0) {
                              final ivl = duecards[0]['ivl'];

                              final newivl = ivl * duecards[0]['factor'] / 1000;

                              final double newivlDays = ivl * duecards[0]['factor'] / 1000;

                              final dueTimestamp = Timestamp.fromDate(
                                DateTime.now().add(Duration(hours: (newivlDays * 24).toInt())),
                              );

                              ref
                                  .read(studyingScreenProvider)
                                  .updateCardOnFirestore(
                                    duecards[0]['noteRef'],
                                    2,
                                    2,
                                    left: 0,
                                    dueTimestamp: dueTimestamp,
                                    ivl: newivl,
                                  );
                              ref
                                  .read(cardsDataNewNotifierProvider.notifier)
                                  .moveCardBetweenCategories(carddata[0]['type'], 2);
                            }

                            ref.read(cardsDataNewNotifierProvider.notifier).removeFirstCard();
                            setState(() {
                              print(carddata);
                              showAdditionalWidgets = false;
                            });
                            _updateLeftValueDistribution();
                            _loadNoteData();
                          },
                          child: Container(
                            width: 80,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors().green,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if ([2002, null].contains(carddata[0]['left']))
                                    Text(
                                      Strings.tenMinutes,
                                      style: AppTextStyles.sfProSemibold24.copyWith(
                                        fontSize: 14,
                                        height: 1.0,
                                        color: Colors.white,
                                      ),
                                    )
                                  else if ([1001, 2001].contains(carddata[0]['left']))
                                    Text(
                                      Strings.oneDay,
                                      style: AppTextStyles.sfProSemibold24.copyWith(
                                        fontSize: 14,
                                        height: 1.0,
                                        color: Colors.white,
                                      ),
                                    )
                                  else if (carddata[0]['left'] == 0)
                                    (() {
                                      final ivl = duecards[0]['ivl'];

                                      final double newivlDays = ivl * duecards[0]['factor'] / 1000;
                                      return Text(
                                        '${newivlDays.toStringAsFixed(1)}日',
                                        style: AppTextStyles.sfProSemibold24.copyWith(
                                          fontSize: 14,
                                          height: 1.0,
                                          color: Colors.white,
                                        ),
                                      );
                                    })(),
                                  Text(
                                    Strings.correct,
                                    style: AppTextStyles.sfProSemibold24.copyWith(
                                      fontSize: 14,
                                      height: 1.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //簡単ボタン
                        GestureDetector(
                          onTap: () async {
                            if ([2002, null, 1001, 2001].contains(carddata[0]['left'])) {
                              final timestamp4Days = Timestamp.fromDate(
                                DateTime.now().add(Duration(days: 4)),
                              );
                              final newfactor = duecards[0]['factor'] + 200;
                              print('newfactor,$newfactor');

                              ///AIコメントを自動生成
                              // if (newfactor >= 2800) {
                              // ref
                              //     .read(studyingScreenProvider)
                              //     .generateJapaneseHistoryQuestion(answerCardQuestionText[0]);
                              // }
                              ref
                                  .read(studyingScreenProvider)
                                  .updateCardOnFirestore(
                                    duecards[0]['noteRef'],
                                    1,
                                    1,
                                    left: 0,
                                    dueTimestamp: timestamp4Days,
                                    factor: newfactor,
                                  );
                              ref
                                  .read(cardsDataNewNotifierProvider.notifier)
                                  .moveCardBetweenCategories(carddata[0]['type'], 2);
                            }

                            if (carddata[0]['left'] == 0) {
                              final ivl = duecards[0]['ivl'];

                              final newivl = ivl * duecards[0]['factor'] / 1000;

                              final double newivlDays = ivl * duecards[0]['factor'] / 1000 * 1.3;

                              final dueTimestamp = Timestamp.fromDate(
                                DateTime.now().add(Duration(hours: (newivlDays * 24).toInt())),
                              );
                              final newfactor = duecards[0]['factor'] + 200;
                              print('newfactor,$newfactor');
                              // if (newfactor >= 2800) {
                              // await ref
                              //     .read(studyingScreenProvider)
                              //     .generateJapaneseHistoryQuestion(answerCardQuestionText[0]);

                              // }
                              ref
                                  .read(studyingScreenProvider)
                                  .updateCardOnFirestore(
                                    duecards[0]['noteRef'],
                                    2,
                                    2,
                                    left: 0,
                                    dueTimestamp: dueTimestamp,
                                    ivl: newivl,
                                    factor: newfactor,
                                  );
                              ref
                                  .read(cardsDataNewNotifierProvider.notifier)
                                  .moveCardBetweenCategories(carddata[0]['type'], 2);
                            }
                            ref.read(cardsDataNewNotifierProvider.notifier).removeFirstCard();
                            setState(() {
                              print(carddata);
                              showAdditionalWidgets = false;
                            });
                            _updateLeftValueDistribution();
                            _loadNoteData();
                          },
                          child: Container(
                            width: 80,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors().blue,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if ([2002, null, 1001, 2001].contains(carddata[0]['left']))
                                    Text(
                                      Strings.fourDays,
                                      style: AppTextStyles.sfProSemibold24.copyWith(
                                        fontSize: 14,
                                        height: 1.0,
                                        color: Colors.white,
                                      ),
                                    )
                                  else if (carddata[0]['left'] == 0)
                                    (() {
                                      final ivl = duecards[0]['ivl'];

                                      final newivl = ivl * duecards[0]['factor'] / 1000 * 1.3;

                                      return Text(
                                        '${newivl.toStringAsFixed(1)}日',
                                        style: AppTextStyles.sfProSemibold24.copyWith(
                                          fontSize: 14,
                                          height: 1.0,
                                          color: Colors.white,
                                        ),
                                      );
                                    })(),
                                  Text(
                                    Strings.easy,
                                    style: AppTextStyles.sfProSemibold24.copyWith(
                                      fontSize: 14,
                                      height: 1.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
