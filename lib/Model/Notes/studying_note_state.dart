import 'package:freezed_annotation/freezed_annotation.dart';

part 'studying_note_state.freezed.dart';

@freezed
class StudyingNoteState with _$StudyingNoteState {
  const factory StudyingNoteState({
    @Default(true) bool isLoading,
    String? imageUrl,
    String? errorMessage,
  }) = _StudyingNoteState;
}
