import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/card_repository.dart';
import '../../providers/card_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudyingScreenFunctions {
  final Ref ref;
  final CardRepository repository;

  StudyingScreenFunctions({
    required this.ref,
    required this.repository,
  });

  Future<void> updateMemo({
    required String cardId,
    required String memo,
  }) async {
    try {
      await ref
          .read(cardsDataNewNotifierProvider.notifier)
          .saveMemo(cardId: cardId, memo: memo);

      await repository.saveMemoToFirestore(cardId: cardId, memo: memo);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCardOnFirestore(
    String noteRef,
    int queue,
    int type, {
    Timestamp? dueTimestamp,
    int? left,
    int? factor,
    dynamic ivl,
  }) async {
    await repository.updateLearnedCardsData(
      noteRef,
      queue,
      type,
      dueTimestamp: dueTimestamp,
      left: left,
      factor: factor,
      newivl: ivl,
    );
  }

  void decrementLeftValueCount(dynamic key) {
    final notifier = ref.read(cardsDataNewNotifierProvider.notifier);
    notifier.decrementLeftValueCount(key);
  }

  void moveCardBetweenCategories(int from, int to) {
    final notifier = ref.read(cardsDataNewNotifierProvider.notifier);
    notifier.moveCardBetweenCategories(from, to);
  }

  void discardFirstCard() {
    final notifier = ref.read(cardsDataNewNotifierProvider.notifier);
    notifier.removeFirstCard();
  }
}

final studyingScreenProvider = Provider<StudyingScreenFunctions>((ref) {
  return StudyingScreenFunctions(
    ref: ref,
    repository: ref.watch(cardRepositoryProvider),
  );
});
