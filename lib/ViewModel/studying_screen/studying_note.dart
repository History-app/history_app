import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:japanese_history_app/model/notes/studying_note_state.dart';
import 'package:japanese_history_app/repositories/card_repository.dart';

final studyingNoteViewModelProvider =
    StateNotifierProvider.family<StudyingNoteViewModel, StudyingNoteState, String>(
      (ref, noteId) => StudyingNoteViewModel(ref, noteId),
    );

class StudyingNoteViewModel extends StateNotifier<StudyingNoteState> {
  StudyingNoteViewModel(this.ref, this.noteId) : super(const StudyingNoteState()) {
    fetchImageUrl();
  }

  final Ref ref;
  final String noteId;

  Future<void> fetchImageUrl() async {
    try {
      final repository = ref.read(cardRepositoryProvider);
      final url = await repository.fetchNoteImageUrl(noteId);

      state = state.copyWith(isLoading: false, imageUrl: url);
    } catch (e) {
      state = state.copyWith(
        isLoading: false, // ← ここが超重要
        errorMessage: 'オフラインのため画像を取得できません',
      );
    }
  }
}
