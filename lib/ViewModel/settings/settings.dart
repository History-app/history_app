import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/user_repository.dart';
import '../../Model/user/user.dart';
import '../../providers/user_provider.dart';
import '../../providers/card_provider.dart';
import '../../ViewModel/home_screen/home_screen.dart';

final settingsNotifierProvider =
    StateNotifierProvider<SettingsStateNotifier, User>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return SettingsStateNotifier(userRepository, ref);
});

class SettingsStateNotifier extends StateNotifier<User> {
  final UserRepository userRepository;
  final Ref ref;
  SettingsStateNotifier(this.userRepository, this.ref)
      : super(User(uid: '', nullCount: 5)) {
    _init();
  }

  Future<void> _init() async {
    try {
      final user = await ref.read(userProvider.future);
      state = user;
    } catch (e) {}
  }

  Future<void> updateNullCount(count) async {
    try {
      await userRepository.setNullCount(count);

      state = state.copyWith(nullCount: count);
    } catch (error) {}
  }

  Future<void> updateTodayCard(nullCount) async {
    try {
      await ref
          .read(cardsDataNewNotifierProvider.notifier)
          .fetchCardsData(nullCount);

      await ref
          .read(cardsDataNewNotifierProvider.notifier)
          .fetchTodaysReviewNoteRefs();
      final todaysReviewNoteRefs =
          ref.read(cardsDataNewNotifierProvider).todaysReviewNoteRefs;
      await _loadNoteData(todaysReviewNoteRefs);
    } catch (error) {}
  }

  Future<void> _loadNoteData(List<String> noteRefs) async {
    try {
      await ref.read(homescreenProvider).fetchUsersMultipleCards(noteRefs);
      final DueCards =
          ref.read(cardsDataNewNotifierProvider).usersMultipleCards;

      List<Map<String, dynamic>> allNotes = [];
      for (String noteRef in noteRefs) {
        final cards =
            await ref.read(homescreenProvider).getNotesByNoteRef(noteRef);

        allNotes.addAll(cards);
      }

      ref.read(homescreenProvider).updateNotes(allNotes);

      ref.read(homescreenProvider).updateLeftValueDistribution(DueCards);
    } catch (e) {}
  }
}
