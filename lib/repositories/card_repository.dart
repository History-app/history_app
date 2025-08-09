import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CardRepository {
  final uid = FirebaseAuth.instance.currentUser?.uid;

  CardRepository() {
    initState();
  }

  void initState() {}

  Future<List<Map<String, dynamic>>> getAllUserLearnedCards() async {
    try {
      if (uid == null) {
        return [];
      }

      int maxRetries = 10;
      int currentRetry = 0;

      while (currentRetry < maxRetries) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('learnedCards')
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          List<Map<String, dynamic>> results = querySnapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();

          return results;
        } else {
          currentRetry++;

          if (currentRetry < maxRetries) {
            int delaySeconds = currentRetry * 2;
            await Future.delayed(Duration(seconds: delaySeconds));
          }
        }
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getUsersCardsData({
    List<Map<String, dynamic>>? allLearnedCards,
    required int nullCount,
  }) async {
    try {
      final cards = allLearnedCards ?? [];
      final limitsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('settings')
          .doc('cardLimits');

      return await FirebaseFirestore.instance
          .runTransaction<List<Map<String, dynamic>>>((transaction) async {
        final limitsDoc = await transaction.get(limitsRef);
        final today = DateTime.now().toIso8601String().substring(0, 10);

        int todayFetchCount = 0;
        String lastFetchDate = '';

        List<String> todaysNullCardIds = [];

        if (limitsDoc.exists) {
          lastFetchDate = limitsDoc.data()?['lastFetchDate'] ?? '';

          if (lastFetchDate == today) {
            todayFetchCount = limitsDoc.data()?['todayFetchCount'] ?? 0;

            todaysNullCardIds =
                List<String>.from(limitsDoc.data()?['todaysNullCardIds'] ?? []);
          }
        }

        if (lastFetchDate != today) {
          todayFetchCount = 0;
          todaysNullCardIds = [];
        }

        final remainingFetchCount = (nullCount) - todayFetchCount;

        List<Map<String, dynamic>> nullLeftCards = [];
        List<Map<String, dynamic>> nonNullLeftCards = [];
        List<Map<String, dynamic>> todaysDisplayedNullCards = [];

        for (var data in cards) {
          // ここで以前のdoc.data()ではなく直接dataを使用
          //todayFetchCountが0ではなく,設定変数よりtodayFetchCountが大きいとき、todaysNullCardIdsを取得し、
          //その設定変数分を配列の前から取得し、newNullCardsに、nullのものだけを格納する
          //todayFetchCOuntが0ではなく、設定変数の方がtodayFetchCountより大きい時、todaysNullCardIdsを取得し、足りないぶん、
          //nullLeftCardから撮ってきて、todaysNullCardsに追加する

          if (!data.containsKey('left') || data['left'] == null) {
            // 今日の新規カード(すでに定義したやつで、まだ表示していないやつ)
            if (todaysNullCardIds.contains(data['id'])) {
              todaysDisplayedNullCards.add(data);
            }
            //今日のノルマ新規カードに入ってすらない、新規カード
            else {
              nullLeftCards.add(data);
            }
          }
          //新規カードですらないカード
          else {
            nonNullLeftCards.add(data);
          }
        }
        if (nullCount > todayFetchCount && todayFetchCount != 0) {
          int needed = nullCount - todayFetchCount;
          final orderedNullLeft = _orderNullLeftCards(nullLeftCards);

          List<Map<String, dynamic>> toAdd =
              orderedNullLeft.take(needed).toList();

          todaysDisplayedNullCards.addAll(toAdd);
        }
        if (nullCount < todayFetchCount) {
          int needed = todayFetchCount - nullCount;

          if (needed <= todaysDisplayedNullCards.length) {
            todaysDisplayedNullCards.removeRange(
              todaysDisplayedNullCards.length - needed,
              todaysDisplayedNullCards.length,
            );
          } else {
            todaysDisplayedNullCards.clear();
          }
        }

        List<Map<String, dynamic>> newNullCards = [];
        List<String> newNullCardIds = [];

        if (todayFetchCount == 0) {
          int fetchCount = nullLeftCards.length < remainingFetchCount
              ? nullLeftCards.length
              : remainingFetchCount;

          final orderedNullLeft = _orderNullLeftCards(nullLeftCards);

          // 2) 取得数だけ先頭から抜き出す
          final actualFetchCount = orderedNullLeft.length < remainingFetchCount
              ? orderedNullLeft.length
              : remainingFetchCount;
          newNullCards = orderedNullLeft.sublist(0, actualFetchCount);
          print('newNullCards: $newNullCards');

          // 3) ID リストの更新（既存 + 新規）

          // 新たに表示するカードのIDを記録
          newNullCardIds =
              newNullCards.map((card) => card['id'].toString()).toList();

          // 更新するカードIDリスト（既存のものと新しいもの）
          List<String> updatedCardIds = [
            ...todaysNullCardIds,
            ...newNullCardIds
          ];

          // 制限情報を更新
          transaction.set(limitsRef, {
            'lastFetchDate': today,
            'todayFetchCount': todayFetchCount + fetchCount,
            'todaysNullCardIds': updatedCardIds, // 表示済みカードIDを保存
            'updatedAt': FieldValue.serverTimestamp()
          });
        }

        // 結果を返す - 今日既に表示したカード + 新しく表示するカード + 通常カード
        return [
          ...todaysDisplayedNullCards,
          ...newNullCards,
          ...nonNullLeftCards
        ];
      });
    } catch (e) {
      print('Error fetching cards: $e');
      return [];
    }
  }

  List<Map<String, dynamic>> _orderNullLeftCards(
      List<Map<String, dynamic>> cards) {
    final group1 = <Map<String, dynamic>>[]; // 1～52
    final group2 = <Map<String, dynamic>>[]; // 53～

    for (var c in cards) {
      final num = _extractNumber(c['id'] as String);
      if (num >= 1 && num <= 52) {
        group1.add(c);
      } else {
        group2.add(c);
      }
    }
    group1.sort(
        (a, b) => _extractNumber(a['id']).compareTo(_extractNumber(b['id'])));
    group2.sort(
        (a, b) => _extractNumber(a['id']).compareTo(_extractNumber(b['id'])));
    return [...group1, ...group2];
  }

  int _extractNumber(String id) {
    final m = RegExp(r'\d+').firstMatch(id);
    return m != null ? int.parse(m.group(0)!) : 0;
  }

  Future<void> saveMemoToFirestore({
    required String cardId,
    required String memo,
  }) async {
    if (uid == null) {
      throw Exception('ユーザーがログインしていません');
    }
    print('Saving memo for cardId: $cardId, memo: $memo');
    final cardRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('learnedCards')
        .doc(cardId);

    await cardRef.update({
      'memo': memo,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Map<String, dynamic> removeNullFields(Map<String, dynamic> data) {
    return data..removeWhere((key, value) => value == null);
  }

  Future<void> updateLearnedCardsData(String noteRef, int newQueue, int newType,
      {Timestamp? dueTimestamp, int? left, int? factor, dynamic newivl}) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('learnedCards')
          .where('noteRef', isEqualTo: noteRef)
          .get();

      final Timestamp dueDate = dueTimestamp ??
          Timestamp.fromDate(DateTime.now().add(Duration(days: 1)));

      // 更新データを作成してからnull値を除外
      Map<String, dynamic> updateData = removeNullFields({
        'queue': newQueue,
        'type': newType,
        'updatedAt': FieldValue.serverTimestamp(),
        'due': dueDate,
        'left': left,
        'factor': factor,
        'ivl': newivl,
      });

      // 各ドキュメントを更新
      for (var doc in querySnapshot.docs) {
        await doc.reference.update(updateData);
      }

      print('カードを更新しました: noteRef=$noteRef, 次回復習日=${dueDate.toDate()}');
    } catch (e) {
      print('Error updating learnedCards data: $e');
    }
  }
}

final cardRepositoryProvider = Provider<CardRepository>((ref) {
  return CardRepository();
});
