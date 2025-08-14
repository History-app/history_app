import 'package:firebase_auth/firebase_auth.dart';
import '../Model/card/cards_data_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/card_repository.dart';
import '../../repositories/sqlite_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final currentUser = FirebaseAuth.instance.currentUser;

final userId = currentUser?.uid;

final cardsDataNewNotifierProvider =
    NotifierProvider<CardsDataNotifier, CardsDataState>(CardsDataNotifier.new);

class CardsDataNotifier extends Notifier<CardsDataState> {
  CardsDataState initialCardsDataState() => const CardsDataState();
  @override
  CardsDataState build() {
    return initialCardsDataState();
  }

  Future<void> fetchUsersMultipleCards(List<String> noteRefs) async {
    final allCards = state.allLearnedCards;

    if (noteRefs.isEmpty || allCards.isEmpty) {
      state = state.copyWith(usersMultipleCards: []);
      return;
    }

    final cardMap = {
      for (var card in allCards)
        if (card['noteRef'] != null) card['noteRef']: card
    };

    final orderedCards = noteRefs
        .map((noteRef) => cardMap[noteRef])
        .whereType<Map<String, dynamic>>()
        .toList();

    state = state.copyWith(usersMultipleCards: orderedCards);
  }

  Future getNotesByNoteRef(String noteRef) async {
    final notesData = await SQLiteRepository().getNotesByNoteRef(noteRef);
    return notesData;
  }

  void updateNotes(List<Map<String, dynamic>> allNotes) {
    state = state.copyWith(allNotes: allNotes);
  }

  void updateLeftValueDistribution(Map<dynamic, int> distribution) {
    state = state.copyWith(leftValueDistribution: distribution);
  }

  Future<void> fetchCardsData(int nullCount) async {
    await fetchAllLearnedCards();

    final cardRepository = ref.read(cardRepositoryProvider);
    final cardsData = await cardRepository.getUsersCardsData(
        allLearnedCards: state.allLearnedCards, nullCount: nullCount);

    state = state.copyWith(cards: cardsData);
    calculateCardStats();
  }

  Future<void> fetchAllLearnedCards() async {
    final cardRepository = ref.read(cardRepositoryProvider);
    final allCards = await cardRepository.getAllUserLearnedCards();
    state = state.copyWith(allLearnedCards: allCards);
  }

  Future<void> calculateCardStats() async {
    final allCards = state.allLearnedCards;
    if (allCards.isEmpty) return;

    final distribution = <dynamic, int>{};

    for (var card in allCards) {
      if (card.containsKey('left')) {
        final leftValue = card['left'];
        distribution[leftValue] = (distribution[leftValue] ?? 0) + 1;
      }
    }

    // 各タイプのカード数を計算
    final newCardCount = distribution[null] ?? 0;
    final learningCardCount = (distribution[2001] ?? 0) +
        (distribution[1001] ?? 0) +
        (distribution[2002] ?? 0);
    final reviewCardCount = distribution[0] ?? 0;
    final totalCardCount = allCards.length;

    state = state.copyWith(
        newCardCount: newCardCount,
        learningCardCount: learningCardCount,
        reviewCardCount: reviewCardCount,
        totalCardCount: totalCardCount);
  }

  Future<void> fetchTodaysReviewNoteRefs() async {
    final todaysReviewRefs = await getTodaysReviewData(state.cards);

    state = state.copyWith(todaysReviewNoteRefs: todaysReviewRefs);
  }

  void setLeftValueDistribution(Map<dynamic, int> distribution) {
    state = state.copyWith(leftValueDistribution: distribution);
  }

  Future<List<String>> getTodaysReviewData(
      List<Map<String, dynamic>> cardsData) async {
    try {
      final now = DateTime.now();

      List<Map<String, dynamic>> filteredCards = cardsData.where((card) {
        if (card['due'] == null) {
          return true;
        } else {
          DateTime dueDate = (card['due'] as Timestamp).toDate();
          return dueDate.isBefore(now);
        }
      }).toList();

      List<String> results =
          filteredCards.map((card) => card['noteRef'] as String).toList();

      return results;
    } catch (e) {
      return [];
    }
  }

  Future<void> saveMemo({required String cardId, required String memo}) async {
    try {
      final updatedCards =
          List<Map<String, dynamic>>.from(state.usersMultipleCards);
      for (int i = 0; i < updatedCards.length; i++) {
        if (updatedCards[i]['id'] == cardId) {
          updatedCards[i]['memo'] = memo;
          break;
        }
      }
      state = state.copyWith(usersMultipleCards: updatedCards);
    } catch (e) {}
  }

  void decrementLeftValueCount(dynamic key, [int decrement = 1]) {
    final currentDistribution =
        Map<dynamic, int>.from(state.leftValueDistribution);
    // キーが存在し、減らしても0以上になる場合のみ減算
    if (currentDistribution.containsKey(key) &&
        currentDistribution[key]! >= decrement) {
      currentDistribution[key] = currentDistribution[key]! - decrement;

      // 0になったら削除するオプション（必要に応じて）
      if (currentDistribution[key] == 0) {
        currentDistribution.remove(key);
      }
    }
    state = state.copyWith(leftValueDistribution: currentDistribution);
  }

  void moveCardBetweenCategories(int from, int to) {
    int newCount = state.newCardCount;
    int learningCount = state.learningCardCount;
    int reviewCount = state.reviewCardCount;

    switch (from) {
      case 0: // 新規カード
        if (newCount > 0) {
          newCount--;
        } else {
          return; // 何も変更せずに終了
        }
        break;

      case 1: // 学習中カード
        if (learningCount > 0) {
          learningCount--;
        } else {
          return;
        }
        break;

      case 2: // 復習カード
        if (reviewCount > 0) {
          reviewCount--;
        } else {
          return;
        }
        break;

      default:
        return;
    }

    // 移動先にカードを増やす
    switch (to) {
      case 1: // 学習中カード
        learningCount++;
        break;

      case 2: // 復習カード
        reviewCount++;
        break;

      default:
        return;
    }

    state = state.copyWith(
      newCardCount: newCount,
      learningCardCount: learningCount,
      reviewCardCount: reviewCount,
    );
  }

  void removeFirstCard() {
    final updatedCards = List<Map<String, dynamic>>.from(state.cards.skip(1));
    final updatedtodaysReviewNoteRefs =
        List<String>.from(state.todaysReviewNoteRefs.skip(1));
    final updatedUsersMultipleCards =
        List<Map<String, dynamic>>.from(state.usersMultipleCards.skip(1));
    final updatedAllNotes =
        List<Map<String, dynamic>>.from(state.allNotes.skip(1));
    state = state.copyWith(cards: updatedCards);
    state = state.copyWith(todaysReviewNoteRefs: updatedtodaysReviewNoteRefs);
    state = state.copyWith(usersMultipleCards: updatedUsersMultipleCards);
    state = state.copyWith(allNotes: updatedAllNotes);
  }
}
