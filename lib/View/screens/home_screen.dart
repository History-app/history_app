import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Model/widgets/common_app_bar.dart';
import '../../Model/text_styles.dart';
import 'package:rive/rive.dart' as rive;
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import '../widgets/EraQuizHeader.dart';
import '../widgets/svg_container_list.dart';
import '../widgets/EraNoteHeader.dart';
import '../widgets/svg_container_note_list.dart';
import '../../Model/firebases/firebase.dart';
import '../../ViewModel/random_text_viewmodel.dart';
import './modal.dart';
// import '../../ViewModel/tutorial_viewmodel.dart';
import '../../ViewModel/tutorial/home_tutorial.dart';
import '../../Model/Color/app_colors.dart';
import './studying_screen.dart';
import '../../View/widgets/update.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
part '../widgets/custom_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isLoading = false; // ← 追加
  List<Map<String, dynamic>> duecard = [];
  List<Map<String, dynamic>> duecards = [];
  Map<dynamic, int> leftValueDistribution = {};

  void _updateLeftValueDistribution() {
    Map<dynamic, int> distribution = {};

    for (var card in duecards) {
      if (card.containsKey('left')) {
        final leftValue = card['left'];
        distribution[leftValue] = (distribution[leftValue] ?? 0) + 1;
      }
    }
    ref
        .read(cardsDataNotifierProvider.notifier)
        .updateLeftValueDistribution(distribution);
  }

  Future<void> _onRefresh() async {
    await ref.read(cardsDataNotifierProvider.notifier).fetchCardsData();
    await ref
        .read(cardsDataNotifierProvider.notifier)
        .fetchTodaysReviewNoteRefs();

    final todaysReviewNoteRefs =
        ref.read(cardsDataNotifierProvider).todaysReviewNoteRefs;
    await _loadNoteData(todaysReviewNoteRefs);
  }

  // _loadNoteDataをcardsDataからではなく、provider経由で取得したreviewデータを使うように変更
  Future<void> _loadNoteData(List<String> noteRefs) async {
    try {
      await ref
          .read(cardsDataNotifierProvider.notifier)
          .fetchUsersMultipleCards();
      final DueCards = ref.read(cardsDataNotifierProvider).usersMultipleCards;
      print('これがDueCardsです$DueCards');
      List<Map<String, dynamic>> allNotes = [];
      for (String noteRef in noteRefs) {
        final cards = await getNotesByNoteRef(noteRef);
        allNotes.addAll(cards);
      }

      ref.read(cardsDataNotifierProvider.notifier).updateNotes(allNotes);
      setState(() {
        duecard = allNotes;
        duecards = DueCards;
      });
      _updateLeftValueDistribution();
    } catch (e) {
      print('Error loading note data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // ref.read(tutorialProvider.notifier).resetTutorial();
    _isLoading = true; // ← ここでtrueにする
    Future.microtask(() async {
      ref.read(randomTextProvider.notifier).generateRandomText();
      await ref.read(cardsDataNotifierProvider.notifier).fetchCardsData();

      await ref
          .read(cardsDataNotifierProvider.notifier)
          .fetchTodaysReviewNoteRefs();
      final todaysReviewNoteRefs =
          ref.read(cardsDataNotifierProvider).todaysReviewNoteRefs;
      print('これがtodaysReviewNoteRefsです$todaysReviewNoteRefs');
      await _loadNoteData(todaysReviewNoteRefs);
      setState(() {
        _isLoading = false; // ← データ取得完了でfalseに
      });

      final needsUpdate = await versionCheck();

      if (needsUpdate) {
        // BuildContextが有効なスコープ内でダイアログを表示
        showUpdateDialog(context);
      } else {
        // チュートリアル処理をViewModelに移行
        await ref.read(tutorialProvider.notifier).initTutorial(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final randomText = ref.watch(randomTextProvider); // 状態の監視
    final cardState = ref.watch(cardsDataNotifierProvider);
    return Scaffold(
        backgroundColor: Colors.white,
        //コメントアウト部分の機能はいずれ実装する予定
        appBar: CommonAppBar(
          title: 'これだけ日本史',
          // leadingIconPath: 'assets/add_to_home_screen.svg',
          // actionIconPath: 'assets/tab_search.svg',
          // onLeadingPressed: () {},
          // onActionPressed: () {},
        ),
        body: _isLoading
            ? Center(
                child: Stack(
                  alignment: Alignment.center, // Stack内の要素を中央揃え
                  children: [
                    Container(
                      width:
                          MediaQuery.of(context).size.width * 0.9, // 画面サイズに対応
                      height: MediaQuery.of(context).size.width * 0.9,
                      child: rive.RiveAnimation.asset(
                        'assets/bounce_animation.riv',
                        stateMachines: ['State Machine 1'],
                        fit: BoxFit.contain, // コンテナ内に収める
                      ),
                    ),
                    Positioned(
                      top: 0, // 上から50ピクセルの位置
                      child: Column(
                        children: [
                          Text(
                            'データ読み込み中...', // 表示するテキスト
                            style: AppTextStyles.hiraginoW6.copyWith(
                              fontSize: 24,
                              color: AppColors().primaryRed,
                            ),
                          ),
                          Text(
                            randomText, // 表示するテキスト
                            style: AppTextStyles.hiraginoW6.copyWith(
                              fontSize: 24,
                              color: AppColors().primaryRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors().primaryRed,
                backgroundColor: Colors.white,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const Gap(24),
                    Row(
                      children: [
                        const Gap(16),
                        Text(
                          '続きから学習',
                          style:
                              AppTextStyles.hiraginoW6.copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                    const Gap(6),
                    CustomCard(),
                    const Gap(18),
                    GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        height: 120,
                        child: Image.asset('assets/premium.png'),
                      ),
                    ),
                    const Gap(10),
                    EraNoteHeader(),
                    const SvgNoteList(),
                    const Gap(40),
                  ],
                ),
              ));
  }
}
