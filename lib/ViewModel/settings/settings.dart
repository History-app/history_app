import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/user_repository.dart';
import '../../Model/user/user.dart';
import '../../providers/user_provider.dart';
import '../../providers/card_provider.dart';
import '../../ViewModel/home_screen/home_screen.dart';

final settingsNotifierProvider = StateNotifierProvider<SettingsStateNotifier, User>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return SettingsStateNotifier(userRepository, ref);
});

class SettingsStateNotifier extends StateNotifier<User> {
  final UserRepository userRepository;
  final Ref ref;
  SettingsStateNotifier(this.userRepository, this.ref) : super(User(uid: '', nullCount: 5)) {
    _init();
  }
  Future<void> _init() async {
    try {
      final user = await ref.watch(userProvider.future);
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
      final startEra = state.startEra;
      await ref.read(cardsDataNewNotifierProvider.notifier).fetchCardsData(nullCount, startEra);

      await ref.read(cardsDataNewNotifierProvider.notifier).fetchTodaysReviewNoteRefs();
      final todaysReviewNoteRefs = ref.read(cardsDataNewNotifierProvider).todaysReviewNoteRefs;
      await _loadNoteData(todaysReviewNoteRefs);
    } catch (error) {}
  }

//こっちは新時代のUpdateの方

  Future<void> updateTodaysEra(nullCount) async {
    try {
      final startEra = state.startEra;
      print('startEraa: $startEra');

      // 前後にログを入れる
      print('fetchCardsDatainEra: before call, nullCount=$nullCount startEra=$startEra');
      await ref
          .read(cardsDataNewNotifierProvider.notifier)
          .fetchCardsDatainEra(nullCount, startEra);
      print('fetchCardsDatainEra: after call (completed)');

      await ref.read(cardsDataNewNotifierProvider.notifier).fetchTodaysReviewNoteRefs();
      final todaysReviewNoteRefs = ref.read(cardsDataNewNotifierProvider).todaysReviewNoteRefs;
      await _loadNoteData(todaysReviewNoteRefs);
    } catch (error, stack) {
      // 例外を握り潰さずログ出力する
      print('updateTodaysEra error: $error');
      print('$stack');
      rethrow; // 必要なら再送出して呼び出し元で扱わせる
    }
  }

  Future<void> _loadNoteData(List<String> noteRefs) async {
    try {
      await ref.read(homescreenProvider).fetchUsersMultipleCards(noteRefs);
      final DueCards = ref.read(cardsDataNewNotifierProvider).usersMultipleCards;

      List<Map<String, dynamic>> allNotes = [];
      for (String noteRef in noteRefs) {
        final cards = await ref.read(homescreenProvider).getNotesByNoteRef(noteRef);

        allNotes.addAll(cards);
      }

      ref.read(homescreenProvider).updateNotes(allNotes);

      ref.read(homescreenProvider).updateLeftValueDistribution(DueCards);
    } catch (e) {}
  }

  //Userの学習開始時代をsetする関数
  Future<void> updateStartEra(String era) async {
    try {
      state = state.copyWith(startEra: era);
      await userRepository.setStartEra(era);
    } catch (error) {}
  }
}
