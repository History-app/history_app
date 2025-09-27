import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../ViewModel/studying_screen/studying_screen.dart';
import '../../Model/widgets/common_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Model/Color/app_colors.dart';
import '../../Model/text_styles.dart';
import '../widgets/question_card.dart';
import '../widgets/answer_card.dart';
import '../widgets/memo_card.dart';

import '../../providers/user_provider.dart';
import '../../providers/card_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/studying_note.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import '../../ViewModel/tutorial/home_tutorial.dart';
import '../screens/modal.dart';
part '../widgets/edit_card.dart';
part '../bottom_navigation/studying_screen_bottom_bar.dart';

class StudyingScreen extends ConsumerStatefulWidget {
  const StudyingScreen({super.key});
  @override
  ConsumerState<StudyingScreen> createState() => _StudyingScreenState();
}

class _StudyingScreenState extends ConsumerState<StudyingScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool showAdditionalWidgets = false;
  bool allowMoving = false;
  final ScrollController _scrollController = ScrollController();
  Map<String, dynamic>? noteData;
  List<Map<String, dynamic>> carddata = [];
  List<Map<String, dynamic>> duecard = [];
  List<Map<String, dynamic>> duecards = [];
  Map<dynamic, int> leftValueDistribution = {};
  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    _loadNoteData();

    // 画面構築後にチュートリアルを初期化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tutorialProvider.notifier).checkTutorialCompleted().then((completed) async {
        if (!completed) {
          await Future.delayed(Duration(seconds: 1));
          ref.read(tutorialProvider.notifier).showStudyingTutorial(
                context,
                revealCallback: _revealAnswerSection,
              );
        }
      });
    });
  }

  /// チュートリアル終了後に呼ばれるメソッド
  void _revealAnswerSection() async {
    if (!mounted) return;

    setState(() => showAdditionalWidgets = true);

    await _scrollController.animateTo(
      200.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    ref.read(tutorialProvider.notifier).showExtraStudyTutorial(context);
  }

  // duecards内のleft値の分布を計算する関数
  void _updateLeftValueDistribution() {
    Map<dynamic, int> distribution = {};

    // 各カードのleft値をカウント
    for (var card in duecards) {
      if (card.containsKey('left')) {
        final leftValue = card['left'];
        distribution[leftValue] = (distribution[leftValue] ?? 0) + 1;
      }
    }

    setState(() {
      leftValueDistribution = distribution;
    });

    Future(() {
      if (mounted) {
        ref.read(cardsDataNewNotifierProvider.notifier).setLeftValueDistribution(distribution);
      }
    });
  }

  Future<void> _loadNoteData() async {
    try {
      final data2 = ref.read(cardsDataNewNotifierProvider).cards;
      final DueCards = ref.read(cardsDataNewNotifierProvider).usersMultipleCards;
      final allNotes = ref.read(cardsDataNewNotifierProvider).allNotes;
      print("allNotes: $allNotes");
      setState(() {
        carddata = data2;
        duecard = allNotes;
        isLoading = false;
        duecards = DueCards;
      });

      _updateLeftValueDistribution();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DueCards = ref.watch(cardsDataNewNotifierProvider).usersMultipleCards;
    final questionCardKey = ref.read(tutorialProvider.notifier).getQuestionCardKey();
    final answerCardKey = ref.read(tutorialProvider.notifier).getAnswerButtonKey();

    final List<String> answerCardQuestionText;

    if (duecard.isNotEmpty && duecard[0]['flds'] != null && duecard[0]['flds'] is List) {
      final flds = duecard[0]['flds'] as List;

      answerCardQuestionText = [
        flds.length > 1 ? flds[1].toString() : '',
        flds.length > 2 ? flds[2].toString() : '',
      ];
    } else {
      answerCardQuestionText = ['', ''];
    }

    return Scaffold(
      backgroundColor: Colors.white,
      //未実装の箇所はのちに実装予定
      appBar: duecard.isNotEmpty
          ? CommonAppBar(
              title: 'これだけ日本史',
              leadingIconPath: 'assets/Mask.svg',
              actionIconPath: 'assets/note.svg',
              // exleadingIconPath: 'assets/add_to_home_screen.svg',
              // exactionIconPath: 'assets/tab_search.svg',
              onLeadingPressed: () {
                Navigator.pop(context); // 前のページに戻る
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => HomeScreen(),
                //   ),
                // );
              },
              onActionPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditCard(
                      cardId: duecards[0]['id'].toString(),
                      question: duecard[0]['flds'][0].toString(),
                      answer: duecard[0]['flds'][1].toString(),
                      memo: duecards[0]['memo'],
                    ),
                  ),
                );
              },
            )
          : CommonAppBar(
              title: 'これだけ日本史',
              leadingIconPath: 'assets/Mask.svg',
              onLeadingPressed: () {
                Navigator.pop(context);
              },
            ),
      body: duecard.isNotEmpty
          ? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (!showAdditionalWidgets) {
                  setState(() {
                    showAdditionalWidgets = true;
                    allowMoving = true;
                  });
                }
                if (allowMoving) {
                  Future.delayed(Duration(milliseconds: 100), () {
                    _scrollController.animateTo(
                      200.0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  });
                  setState(() {
                    allowMoving = false;
                  });
                }
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  child: Column(
                    children: [
                      Gap(8),
                      Container(
                        alignment: Alignment.center,
                        key: questionCardKey,
                        child: QuestionCard(
                          questionText: duecard.isNotEmpty && duecard[0]['flds'] != null
                              ? duecard[0]['flds'][0].toString()
                              : 'No data',
                          starImagePath: 'assets/star_${duecard[0]['star']}.png',
                        ),
                      ),
                      if (showAdditionalWidgets) ...[
                        Gap(40),
                        Divider(
                            height: 0.5,
                            thickness: 0.5,
                            color: AppColors().grey,
                            indent: 8,
                            endIndent: 8),
                        Gap(8),
                        Center(
                          child: AnswerCard(
                              questionText: answerCardQuestionText,
                              starImagePath: 'assets/star_${duecard[0]['star']}.png',
                              theme: duecard[0]['theme']),
                        ),
                        Gap(36),
                        Center(
                          child: MemoCard(
                            memoText: DueCards[0]['memo'],
                          ),
                        ),
                        Gap(36),
                        Divider(
                            height: 0.5,
                            thickness: 0.5,
                            color: AppColors().grey,
                            indent: 8,
                            endIndent: 8),
                        SizedBox(
                          height: 300,
                          child: Column(children: [
                            Gap(20),
                            Row(children: [
                              Gap(25.5),
                              GestureDetector(
                                key: ref.read(tutorialProvider.notifier).noteSearchKey,
                                onTap: () {
                                  final noteId = duecard[0]['hnref'].toString();

                                  if (noteId != "null") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StudyingNotePage(noteId: noteId),
                                      ),
                                    );
                                  } else {
                                    AccountDeletedModal.show(context);
                                  }
                                },
                                child: Container(
                                    width: 80,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: AppColors().paleRed,
                                      borderRadius: BorderRadius.circular(40),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          offset: Offset(0, 2),
                                          blurRadius: 1,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text('ノート検索',
                                          style: AppTextStyles.sfProSemibold24
                                              .copyWith(fontSize: 13, color: Colors.white)),
                                    )),
                              )
                            ]),
                          ]),
                        ),
                      ] else ...[
                        Container(
                            key: answerCardKey, height: MediaQuery.of(context).size.height - 330),
                      ],
                    ],
                  ),
                ),
              ),
            )
          : SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(30),
                  Center(
                    child: Text(
                      'おめでとうございます！\n本日の学習を全て達成しました!',
                      style: TextStyle(
                        fontFamily: 'HiraginoSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gap(40),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Image.asset(
                            'assets/star_Alan.png',
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          left: 180,
                          top: 100,
                          child: Image.asset(
                            'assets/normal_Alan.png',
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: KeyedSubtree(
        key: ref.read(tutorialProvider.notifier).bottomBarKey,
        child: _buildBottomNavigationBar(),
      ),
    );
  }
}
