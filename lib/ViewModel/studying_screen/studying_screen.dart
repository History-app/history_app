import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/card_repository.dart';
import '../../providers/card_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StudyingScreenFunctions {
  final Ref ref;
  final CardRepository repository;

  StudyingScreenFunctions({required this.ref, required this.repository});

  Future<void> updateMemo({required String cardId, required String memo}) async {
    try {
      await ref.read(cardsDataNewNotifierProvider.notifier).saveMemo(cardId: cardId, memo: memo);

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
    String? aiText,
  }) async {
    await repository.updateLearnedCardsData(
      noteRef,
      queue,
      type,
      dueTimestamp: dueTimestamp,
      left: left,
      factor: factor,
      newivl: ivl,
      aiText: aiText,
    );
  }

  Future<String?> generateJapaneseHistoryQuestion(String answer) async {
    try {
      print('実行 start');

      final uri = Uri.parse(
        'https://asia-northeast1-history-app-dev-fce4a.cloudfunctions.net/generateJapaneseHistoryQuestion',
      );

      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'answer': answer}),
      );

      print('HTTP status: ${res.statusCode}');
      print('HTTP body: ${res.body}');

      if (res.statusCode != 200) return null;

      final data = jsonDecode(res.body);
      return data['success'] == true ? data['question'] as String : null;
    } catch (e, st) {
      print('🔥 ERROR');
      print(e);
      print(st);
      rethrow;
    }
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
  return StudyingScreenFunctions(ref: ref, repository: ref.watch(cardRepositoryProvider));
});
