import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../Model/Color/app_colors.dart';
import '../../Model/text_styles.dart';
import '../../Model/Tutorial/tutorial_model.dart';
import '../../View/screens/studying_screen.dart';
import 'dart:async';

enum TutorialStep {
  homeScreen,
  studyScreen,
}

// チュートリアル状態を管理するNotifierクラス
class TutorialNotifier extends StateNotifier<TutorialState> {
  final GlobalKey _homeStudyButtonKey =
      GlobalKey(debugLabel: 'homeStudyButton');
  final GlobalKey _studyQuestionCardKey =
      GlobalKey(debugLabel: 'studyQuestionCard');
  final GlobalKey _studyAnswerButtonKey =
      GlobalKey(debugLabel: 'studyAnswerButton');
  final GlobalKey _noteSearchKey = GlobalKey(debugLabel: 'noteSearch');
  final GlobalKey _bottomBarKey = GlobalKey(debugLabel: 'bottomBar');
  // 現在のチュートリアルステップ
  TutorialStep _currentStep = TutorialStep.homeScreen;

  TutorialNotifier() : super(TutorialState(isCompleted: false));

  // チュートリアルを初期化
  Future<void> initTutorial(BuildContext context) async {
    final isCompleted = await checkTutorialCompleted();

    final tutorialMark = TutorialCoachMark(
      targets: _createHomeTargets(),
      colorShadow: AppColors().primaryRed,
      hideSkip: true,
      paddingFocus: 10,
      // opacityShadow: 0.8,
      pulseEnable: false,
      onFinish: () {
        _handleStepCompletion(context);
      },
    );

    state = state.copyWith(
      isCompleted: isCompleted,
      coachMark: tutorialMark,
    );

    // チュートリアルが未完了の場合は表示
    if (!isCompleted) {
      Future.delayed(Duration(milliseconds: 500), () {
        showTutorial(context);
      });
    }
  }

  // チュートリアルを表示
  void showTutorial(BuildContext context) {
    state.coachMark?.show(context: context);
  }

  // ステップ完了時の処理
  Future<void> _handleStepCompletion(BuildContext context) async {
    switch (_currentStep) {
      case TutorialStep.homeScreen:
        // Navigatorで次の画面に遷移
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudyingScreen(),
          ),
        );

        // 次のステップに進む
        _currentStep = TutorialStep.studyScreen;
        return;

      case TutorialStep.studyScreen:
        // 最後のステップなので完了フラグをセット
        print("チュートリアル完");

        break;
    }
  }

  // 学習画面用のターゲットを作成
  List<TargetFocus> createStudyTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "questionCardTarget",
        keyTarget: _studyQuestionCardKey,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                color: Colors.white,
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "問題カード",
                      style: AppTextStyles.hiraginoW6.copyWith(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "ここに表示される問題を確認して、答えを思い出せるか考えてみましょう。",
                      style: AppTextStyles.hiraginoW6.copyWith(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
    // 解答ボタンのターゲット
    targets.add(
      TargetFocus(
        identify: "answerButtonTarget",
        keyTarget: _studyAnswerButtonKey,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              top: 30, // ターゲットの上端から50ピクセル下に配置
            ),
            builder: (context, controller) {
              return Container(
                color: Colors.white,
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "解答確認",
                      style: AppTextStyles.hiraginoW6.copyWith(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "思い出せたら、画面をタップして解答を確認しましょう。",
                      style: AppTextStyles.hiraginoW6.copyWith(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );

    return targets;
  }

  List<TargetFocus> _createExtraTargets() {
    List<TargetFocus> targets = [];

    targets.add(
      TargetFocus(
        identify: 'noteSearch',
        keyTarget: _noteSearchKey,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              top: 30, // ターゲットの上端から50ピクセル下に配置
            ),
            builder: (context, controller) {
              return Container(
                color: Colors.white,
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ノート検索機能",
                      style: AppTextStyles.hiraginoW6.copyWith(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "カードに対応するまとめノートを開けます。\n一問一答に加え、背景知識を確認することで、より深く理解できます。",
                      style: AppTextStyles.hiraginoW6.copyWith(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: 'bottomBar',
        keyTarget: _bottomBarKey,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              top: 30, // ターゲットの上端から50ピクセル下に配置
            ),
            builder: (context, controller) {
              return Container(
                color: Colors.white,
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "記憶に合わせて選べる4つの評価",
                      style: AppTextStyles.hiraginoW6.copyWith(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "覚えた度合いに応じてボタンを選び、効率よく復習できます。実際に、この日にち後に復習することができます。",
                      style: AppTextStyles.hiraginoW6.copyWith(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );

    return targets;
  }

  void showExtraStudyTutorial(BuildContext context) {
    final extraMark = TutorialCoachMark(
      targets: _createExtraTargets(), // ← 下で実装
      colorShadow: AppColors().primaryRed,
      hideSkip: true,
      paddingFocus: 10,
      pulseEnable: false,
    );

    // レイアウトが終わるまで 1 フレーム待つ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      extraMark.show(context: context);
    });
  }

  void showStudyingTutorial(
    BuildContext context, {
    required VoidCallback revealCallback,
  }) {
    final studyingTutorialMark = TutorialCoachMark(
      targets: createStudyTargets(),
      colorShadow: AppColors().primaryRed,
      hideSkip: true,
      paddingFocus: 10,
      opacityShadow: 0.8,
      pulseEnable: false,
      onFinish: () {
        print("学習画面チュートリアル完了");
        // _currentStep = TutorialStep.studyScreen;
        // _saveTutorialCompleted();
        revealCallback();
        _saveTutorialCompleted();
      },
    );

    // Future.delayed(Duration(milliseconds: 500), () {
    //   studyingTutorialMark.show(context: context);
    // });
    studyingTutorialMark.show(context: context);
  }

  // ホーム画面用のターゲットを作成
  List<TargetFocus> _createHomeTargets() {
    List<TargetFocus> targets = [];

    // 学習ボタンのターゲット
    targets.add(
      TargetFocus(
        identify: "studyButtonTarget",
        keyTarget: _homeStudyButtonKey,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                color: Colors.white,
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "今日の学習を始めましょう！",
                      style: AppTextStyles.hiraginoW6.copyWith(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "このボタンをタップすると、今日学習すべきカードが表示されます。新規カード、学習中のカード、復習カードの順に表示されます。",
                      style: AppTextStyles.hiraginoW6.copyWith(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
    return targets;
  }

  // チュートリアル完了フラグを保存
  Future<void> _saveTutorialCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('study_button_tutorial_shown', true);
    state = state.copyWith(isCompleted: true);
  }

  // チュートリアル表示済みかチェック
  Future<bool> checkTutorialCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('study_button_tutorial_shown') ?? false;
  }

  // チュートリアルをリセット
  Future<void> resetTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('study_button_tutorial_shown', false);
    _currentStep = TutorialStep.homeScreen;
    state = state.copyWith(isCompleted: false);
    print("チュートリアルがリセットされました");
  }

  // グローバルキーを取得
  GlobalKey getStudyButtonKey() => _homeStudyButtonKey;
  GlobalKey getQuestionCardKey() => _studyQuestionCardKey;
  GlobalKey getAnswerButtonKey() => _studyAnswerButtonKey;
  GlobalKey get noteSearchKey => _noteSearchKey;
  GlobalKey get bottomBarKey => _bottomBarKey;
}

// Riverpodプロバイダー - ファイルの最後に配置
final tutorialProvider =
    StateNotifierProvider<TutorialNotifier, TutorialState>((ref) {
  return TutorialNotifier();
});
