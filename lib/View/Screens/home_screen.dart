import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:japanese_history_app/util/number_formatter.dart';
import 'package:japanese_history_app/constant/app_strings.dart';
import 'package:japanese_history_app/view/widgets/premium_card.dart';
import '../../Model/widgets/common_app_bar.dart';
import '../../Model/text_styles.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../../repositories/card_repository.dart';
import 'package:rive/rive.dart' as rive;
import 'package:gap/gap.dart';
import '../widgets/era_note_header.dart';
import '../widgets/svg_container_note_list.dart';
import '../../ViewModel/random_text_viewmodel.dart';
import '../../providers/user_provider.dart';
import 'package:intl/intl.dart';
import '../../View/screens/studying_screen.dart';
import '../../ViewModel/tutorial/home_tutorial.dart';
import '../../Model/Color/app_colors.dart';
import '../../View/widgets/update.dart';

import '../screens/settings/settings.dart';
import '../../ViewModel/home_screen/home_screen.dart';
import '../../providers/card_provider.dart';

part '../widgets/custom_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isLoading = false; // ← 追加
  List<Map<String, dynamic>> duecard = [];
  List<Map<String, dynamic>> duecards = [];
  Map<dynamic, int> leftValueDistribution = {};

  Future<void> _onRefresh() async {
    final user = ref.watch(userModelProvider);
    final nullCount = user.nullCount;
    final startEraLabel = user.startEra;
    await ref.read(cardsDataNewNotifierProvider.notifier).fetchCardsData(nullCount, startEraLabel);
    await ref.read(cardsDataNewNotifierProvider.notifier).fetchTodaysReviewNoteRefs();

    final todaysReviewNoteRefs = ref.read(cardsDataNewNotifierProvider).todaysReviewNoteRefs;

    await _loadNoteData(todaysReviewNoteRefs);
  }

  Future<void> _loadNoteData(List<String> noteRefs) async {
    try {
      await ref.read(homescreenProvider).fetchUsersMultipleCards(noteRefs);
      final DueCards = ref.watch(cardsDataNewNotifierProvider).usersMultipleCards;

      List<Map<String, dynamic>> allNotes = [];
      for (String noteRef in noteRefs) {
        final cards = await ref.read(homescreenProvider).getNotesByNoteRef(noteRef);
        print('cards,$cards');
        allNotes.addAll(cards);
      }

      ref.read(homescreenProvider).updateNotes(allNotes);
      setState(() {
        duecard = allNotes;
        duecards = DueCards;
      });

      ref.read(homescreenProvider).updateLeftValueDistribution(duecards);
    } catch (e) {
      print('Error loading note data: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    _isLoading = true;
    Future<void> waitForUserUid({
      Duration timeout = const Duration(seconds: 15),
      Duration pollInterval = const Duration(milliseconds: 200),
    }) async {
      final deadline = DateTime.now().add(timeout);
      while (DateTime.now().isBefore(deadline)) {
        final user = ref.read(userModelProvider);
        final uid = user.uid;
        if (uid != null && uid.isNotEmpty) {
          print('uid,$uid');
          print('nullcount,$user.nullCount');
          return;
        }

        await Future.delayed(pollInterval);
      }
    }

    Future.microtask(() async {
      //一旦ここに仮設定
      FlutterNativeSplash.remove();

      ref.read(randomTextProvider.notifier).generateRandomText();
      await waitForUserUid();
      final user = ref.watch(userModelProvider);

      final nullCount = user.nullCount;
      final startEra = user.startEra;
      print('ここで始まり,$nullCount');

      await ref.read(cardsDataNewNotifierProvider.notifier).fetchCardsData(nullCount, startEra);

      await ref.read(cardsDataNewNotifierProvider.notifier).fetchTodaysReviewNoteRefs();
      final todaysReviewNoteRefs = ref.read(cardsDataNewNotifierProvider).todaysReviewNoteRefs;
      await _loadNoteData(todaysReviewNoteRefs);
      setState(() {
        _isLoading = false;
      });

      final needsUpdate = await ref.read(homescreenProvider).checkCurrentVersion();

      if (needsUpdate) {
        showUpdateDialog(context);
      } else {
        print('バージョンチェックは問題ありませんでした');
        await ref.read(tutorialProvider.notifier).initTutorial(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final randomText = ref.watch(randomTextProvider);
    final cardState = ref.watch(cardsDataNewNotifierProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      //コメントアウト部分の機能はいずれ実装する予定
      appBar: CommonAppBar(
        title: 'これだけ日本史',
        // leadingIconPath: 'assets/add_to_home_screen.svg',
        actionIconPath: 'assets/setting.svg',
        // onLeadingPressed: () {},
        onActionPressed: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
        },
      ),
      body: _isLoading
          ? Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
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
                          Strings.isLoading, // 表示するテキスト
                          style: AppTextStyles.hiraginoW6.copyWith(
                            fontSize: 24,
                            color: AppColors().primaryRed,
                          ),
                        ),
                        Text(
                          Strings.firstLaunchTakesTimeMessage, // 表示するテキスト
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
                        Strings.resumeLearning,
                        style: AppTextStyles.hiraginoW6.copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                  const Gap(6),
                  CustomCard(),
                  const Gap(18),
                  FractionallySizedBox(
                    widthFactor: 0.9,
                    child: PremiumCard(
                      title: Text(
                        Strings.dailyLearningMessage,
                        maxLines: 2,
                        style: GoogleFonts.notoSansJp(
                          fontSize: 17,
                          height: 1.3,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: AppColors().primaryRed,
                      imageAssetPath: 'assets/alan_posing.png',
                    ),
                  ),
                  const Gap(10),
                  EraNoteHeader(),
                  const SvgNoteList(),
                  const Gap(40),
                ],
              ),
            ),
    );
  }
}
