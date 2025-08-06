import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialState {
  final bool isCompleted;

  final TutorialCoachMark? coachMark; // プロパティを追加

  TutorialState({
    this.isCompleted = false,
    this.coachMark, // 追加
  });

  TutorialState copyWith({
    bool? isCompleted,
    GlobalKey? studyButtonKey,
    TutorialCoachMark? coachMark, // 追加
  }) {
    return TutorialState(
      isCompleted: isCompleted ?? this.isCompleted,

      coachMark: coachMark ?? this.coachMark, // 追加
    );
  }
}
