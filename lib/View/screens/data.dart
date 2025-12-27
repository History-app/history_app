import 'package:flutter/material.dart';
import '../../Model/Color/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../../Model/widgets/common_app_bar.dart';
import '../../Model/text_styles.dart';

import '../widgets/EraQuizHeader.dart';

import '../../providers/card_provider.dart';
import '../widgets/svg_container_list.dart';
import '../widgets/EraNoteHeader.dart';
import '../widgets/svg_container_note_list.dart';
import '../screens/studying_screen.dart';
// インポートの代わりに
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// StatelessWidgetからStatefulWidgetに変更
class DataScreen extends ConsumerStatefulWidget {
  const DataScreen({super.key});

  @override
  ConsumerState<DataScreen> createState() => _DataScreenState();
}

// 対応するStateクラスを作成
class _DataScreenState extends ConsumerState<DataScreen> {
  List<Map<String, dynamic>> carddata = [];
  Map<dynamic, int> distribution = {};
  // int NewCard = 0;
  // int LearningCard = 0;
  // int ReviewCard = 0;
  // int totalCards = 0;
  void _updateDistribution() {
    // final allLearnedCards = ref.read(cardsDataNotifierProvider).allLearnedCards;
    // // ここにforループを移動
    // for (var card in allLearnedCards) {
    //   if (card.containsKey('left')) {
    //     final leftValue = card['left'];
    //     distribution[leftValue] = (distribution[leftValue] ?? 0) + 1;
    //   }
    // }
    // setState(() {
    //   NewCard = distribution[null] ?? 0;
    //   LearningCard = (distribution[2001] ?? 0) +
    //       (distribution[1001] ?? 0) +
    //       (distribution[2002] ?? 0);
    //   ReviewCard = distribution[0] ?? 0;
    //   totalCards = carddata.length;
    // });

    // print('Left値の分布: $distribution');
    // print('NewCard: $NewCard');
    // print('LearningCard: $LearningCard');
    // print('ReviewCard: $ReviewCard');
    // print('totalCards: $totalCards');
    //ここでデータを挿入するようにしたい
  }

  Future<void> _loadNoteData() async {
    try {
      // final allLearnedCards =
      //     ref.read(cardsDataNotifierProvider).allLearnedCards;
      // print('allLearnedCards: $allLearnedCards');
      // final data2 = await getAllUserLearnedCards();
      // print(data2);
      // setState(() {
      //   // carddata = allLearnedCards;
      // });
      // _updateDistribution();
      // print('これがdataです$data');
    } catch (e) {
      print('Error loading note data: $e');
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    _loadNoteData();
  }

  @override
  Widget build(BuildContext context) {
    final cardStats = ref.watch(cardsDataNewNotifierProvider);

    print('これがcardStatsです$cardStats');

    // プロバイダーから計算済み値を取得
    final NewCard = cardStats.newCardCount;
    final LearningCard = cardStats.learningCardCount;
    final ReviewCard = cardStats.reviewCardCount;
    final totalCards = cardStats.totalCardCount;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonAppBar(
          title: 'データ',
          onActionPressed: () {
            // 右アイコンタップ時の処理
          },
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Gap(42),
              Center(
                child: Container(
                  height: 391,
                  width: 332,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: AppColors().grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3), // 影の色と透明度
                        spreadRadius: 2, // 影の広がり
                        blurRadius: 8, // 影のぼかし具合
                        offset: Offset(0, 3), // 影の位置 (x, y)
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Gap(10),
                      SizedBox(
                          width: 300,
                          height: 38,
                          child: Column(
                            children: [
                              Gap(10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Gap(4),
                                  Text(
                                    'カード枚数',
                                    style:
                                        AppTextStyles.sfProSemibold24.copyWith(
                                      fontSize: 20,
                                      height: 1.0, // 行の高さはフォントサイズの1.0倍
                                    ),
                                  ),
                                ],
                              ),
                              Gap(6),
                              Divider(
                                color: AppColors().grey,
                                thickness: 0.5,
                                height: 0.5, // dividerの上下のスペースも含めた全体の高さ
                              )
                            ],
                          )),
                      Gap(22),
                      SizedBox(
                          width: 214,
                          height: 214,
                          child: PieChart(
                            PieChartData(
                              startDegreeOffset: 270,
                              sections: [
                                PieChartSectionData(
                                    color: Colors.blue,
                                    value: NewCard / totalCards,
                                    titlePositionPercentageOffset: 0.7,
                                    title: "新規",
                                    titleStyle: TextStyle(fontSize: 10),
                                    radius: 100),
                                PieChartSectionData(
                                    color: Colors.orange,
                                    value: LearningCard / totalCards,
                                    titlePositionPercentageOffset: 0.8,
                                    titleStyle: TextStyle(fontSize: 10),
                                    title: "学習中",
                                    radius: 100),
                                PieChartSectionData(
                                    color: Colors.green,
                                    value: ReviewCard / totalCards,
                                    titlePositionPercentageOffset: 0.5,
                                    title: "復習",
                                    titleStyle: TextStyle(fontSize: 10),
                                    radius: 100),
                              ],
                              sectionsSpace: 0,
                              centerSpaceRadius: 0,
                            ),
                          )),
                      Gap(12),
                      SizedBox(
                          width: 184,
                          height: 16,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                color: Colors.blue,
                              ),
                              Gap(23),
                              Text(
                                '新規',
                                style: AppTextStyles.sfProSemibold24.copyWith(
                                  fontSize: 10,
                                  height: 1.0, // 行の高さはフォントサイズの1.0倍
                                ),
                              ),
                              Gap(30),
                              SizedBox(
                                width: 30,
                                child: Text(
                                  '$NewCard',
                                  textAlign: TextAlign.right,
                                  style: AppTextStyles.sfProSemibold24.copyWith(
                                    fontSize: 10,
                                    height: 1.0, // 行の高さはフォントサイズの1.0倍
                                  ),
                                ),
                              ),
                              Gap(30),
                              SizedBox(
                                width: 40,
                                child: Text(
                                  totalCards > 0
                                      ? '${((NewCard / totalCards) * 100).toStringAsFixed(1)}%'
                                      : '0%',
                                  textAlign: TextAlign.right,
                                  style: AppTextStyles.sfProSemibold24.copyWith(
                                    fontSize: 10,
                                    height: 1.0, // 行の高さはフォントサイズの1.0倍
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Gap(1),
                      SizedBox(
                          width: 184,
                          height: 16,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                color: Colors.orange,
                              ),
                              Gap(23),
                              Text(
                                '習得中',
                                style: AppTextStyles.sfProSemibold24.copyWith(
                                  fontSize: 10,
                                  height: 1.0, // 行の高さはフォントサイズの1.0倍
                                ),
                              ),
                              Gap(20),
                              SizedBox(
                                width: 30,
                                child: Text(
                                  '$LearningCard',
                                  textAlign: TextAlign.right,
                                  style: AppTextStyles.sfProSemibold24.copyWith(
                                    fontSize: 10,
                                    height: 1.0, // 行の高さはフォントサイズの1.0倍
                                  ),
                                ),
                              ),
                              Gap(30),
                              SizedBox(
                                width: 40,
                                child: Text(
                                  totalCards > 0
                                      ? '${((LearningCard / totalCards) * 100).toStringAsFixed(1)}%'
                                      : '0%',
                                  textAlign: TextAlign.right,
                                  style: AppTextStyles.sfProSemibold24.copyWith(
                                    fontSize: 10,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Gap(1),
                      SizedBox(
                          width: 184,
                          height: 16,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                color: Colors.green,
                              ),
                              Gap(23),
                              Text(
                                '復習',
                                style: AppTextStyles.sfProSemibold24.copyWith(
                                  fontSize: 10,
                                  height: 1.0, // 行の高さはフォントサイズの1.0倍
                                ),
                              ),
                              Gap(30),
                              SizedBox(
                                width: 30,
                                child: Text(
                                  '$ReviewCard',
                                  textAlign: TextAlign.right,
                                  style: AppTextStyles.sfProSemibold24.copyWith(
                                    fontSize: 10,
                                    height: 1.0, // 行の高さはフォントサイズの1.0倍
                                  ),
                                ),
                              ),
                              Gap(30),
                              SizedBox(
                                width: 40,
                                child: Text(
                                  totalCards > 0
                                      ? '${((ReviewCard / totalCards) * 100).toStringAsFixed(1)}%'
                                      : '0%',
                                  textAlign: TextAlign.right,
                                  style: AppTextStyles.sfProSemibold24.copyWith(
                                    fontSize: 10,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Gap(1),
                      SizedBox(
                          width: 184,
                          height: 16,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 10,
                                height: 10,
                              ),
                              Gap(23),
                              Text(
                                '合計',
                                style: AppTextStyles.sfProSemibold24.copyWith(
                                  fontSize: 10,
                                  height: 1.0, // 行の高さはフォントサイズの1.0倍
                                ),
                              ),
                              Gap(30),
                              SizedBox(
                                width: 30,
                                child: Text(
                                  '$totalCards',
                                  textAlign: TextAlign.right,
                                  style: AppTextStyles.sfProSemibold24.copyWith(
                                    fontSize: 10,
                                    height: 1.0, // 行の高さはフォントサイズの1.0倍
                                  ),
                                ),
                              ),
                              Gap(30),
                              SizedBox(
                                width: 40,
                                child: Text(
                                  '',
                                  textAlign: TextAlign.right,
                                  style: AppTextStyles.sfProSemibold24.copyWith(
                                    fontSize: 10,
                                    height: 1.0, // 行の高さはフォントサイズの1.0倍
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
