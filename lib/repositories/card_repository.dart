import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Model/ era/ eras.dart';

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

  Future<List<Map<String, dynamic>>> getUsersCardsData(
      {List<Map<String, dynamic>>? allLearnedCards, required int nullCount, startEraLabel}) async {
    try {
      //ここの時点で、cardsを篩にかける(いつの時代からそのcardsを勉強しているかで篩にかける)

      // 元リストを安全にコピー
      // Dart
      // 元リストを安全にコピー
      final cards = allLearnedCards ?? [];

      // // left が null の要素を抽出して id の数値部分でソート

      print('cards[0]: ${cards[0]}');
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
            print('todayFetchCount: $todayFetchCount');

            todaysNullCardIds = List<String>.from(limitsDoc.data()?['todaysNullCardIds'] ?? []);
          }
        }

        if (lastFetchDate != today) {
          todayFetchCount = 0;
          todaysNullCardIds = [];
        }
        print('nullCount! $nullCount');
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

          // orderedNullLeft.sort(_startPurposeEra);
          // print('orderdNullLeft,$orderedNullLeft');
          List<Map<String, dynamic>> toAdd = orderedNullLeft.take(needed).toList();

          todaysDisplayedNullCards.addAll(toAdd);
          print('todaysDisplayedNullCards,$todaysDisplayedNullCards');

          // todaysDisplayedNullCards.sort(_startPurposeEra);
          // print('todaysDisplayednullCards,$todaysDisplayedNullCards');
          print('ここだ');
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

        //ここでtodaysDisplayedNullCardsの順番を変えてみる
        // todaysDisplayedNullCards.sort(_startPurposeEra);
        List<Map<String, dynamic>> newNullCards = [];
        List<String> newNullCardIds = [];

        if (todayFetchCount == 0) {
          int fetchCount = nullLeftCards.length < remainingFetchCount
              ? nullLeftCards.length
              : remainingFetchCount;
          final orderedNullLeft = _orderNullLeftCards(nullLeftCards);

          if (startEraLabel != null) {
            print('こここ');
            final startId = minIdStringForEraByMapping(cards, startEraLabel);
            if (startId != null) {
              final startNum = _extractNumber(startId);
              orderedNullLeft
                  .sort((a, b) => _extractNumber(a['id']).compareTo(_extractNumber(b['id'])));
              final high = orderedNullLeft
                  .where((c) => _extractNumber(c['id'].toString()) >= startNum)
                  .toList();
              final low = orderedNullLeft
                  .where((c) => _extractNumber(c['id'].toString()) < startNum)
                  .toList();
              final rotated = [...high, ...low];
              orderedNullLeft
                ..clear()
                ..addAll(rotated);
            }
          }

          // 2) 取得数だけ先頭から抜き出す
          final actualFetchCount = orderedNullLeft.length < remainingFetchCount
              ? orderedNullLeft.length
              : remainingFetchCount;
          newNullCards = orderedNullLeft.sublist(0, actualFetchCount);

          // 3) ID リストの更新（既存 + 新規）

          // 新たに表示するカードのIDを記録
          newNullCardIds = newNullCards.map((card) => card['id'].toString()).toList();

          List<String> updatedCardIds = [...todaysNullCardIds, ...newNullCardIds];

          // 制限情報を更新
          transaction.set(limitsRef, {
            'lastFetchDate': today,
            'todayFetchCount': todayFetchCount + fetchCount,
            'todaysNullCardIds': updatedCardIds,
            'updatedAt': FieldValue.serverTimestamp()
          });
        }

        // 結果を返す - 今日既に表示したカード + 新しく表示するカード + 通常カード
        return [...todaysDisplayedNullCards, ...newNullCards, ...nonNullLeftCards];
      });
    } catch (e) {
      print('Error fetching cards: $e');
      return [];
    }
  }

  List<Map<String, dynamic>> _orderNullLeftCards(List<Map<String, dynamic>> cards) {
    final group1 = <Map<String, dynamic>>[];
    final group2 = <Map<String, dynamic>>[];

    for (var c in cards) {
      final num = _extractNumber(c['id'] as String);
      if (num >= 1 && num <= 52) {
        group1.add(c);
      } else {
        group2.add(c);
      }
    }
    group1.sort((a, b) => _extractNumber(a['id']).compareTo(_extractNumber(b['id'])));
    group2.sort((a, b) => _extractNumber(a['id']).compareTo(_extractNumber(b['id'])));
    return [...group1, ...group2];
  }

  //lastFetchDateをリセットする関数
  Future<void> resetLastFetchDate() async {
    if (uid == null) {
      // ユーザー未ログイン時は何もしない
      return;
    }

    try {
      final limitsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('settings')
          .doc('cardLimits');

      await limitsRef.set({
        'lastFetchDate': '',
      }, SetOptions(merge: true));
    } catch (e) {
      // 必要ならエラーハンドリングを追加
      print('resetLastFetchDate error: $e');
    }
  }

//　時代別に始める
  int _startPurposeEra(Map<String, dynamic> a, Map<String, dynamic> b) {
    final idA = a['id']?.toString() ?? '';
    final idB = b['id']?.toString() ?? '';
    final numA = int.tryParse(RegExp(r'\d+').firstMatch(idA)?.group(0) ?? '') ?? 0;
    final numB = int.tryParse(RegExp(r'\d+').firstMatch(idB)?.group(0) ?? '') ?? 0;
    return numB.compareTo(numA); // 昇順（降順なら return numB.compareTo(numA)）
  }

  int _extractNumber(String id) {
    final m = RegExp(r'\d+').firstMatch(id);
    return m != null ? int.parse(m.group(0)!) : 0;
  }

  // 指定時代の次の時代開始数（存在しなければ大きな値）
  int _nextEraStartNumber(String eraLabel) {
    final idx = kEras.indexOf(eraLabel);
    if (idx == -1) return 1 << 30;
    // kEras の順序に従って次の時代の開始数を返す
    for (int i = idx + 1; i < kEras.length; i++) {
      final next = eraStartNumbers[kEras[i]];
      if (next != null) return next;
    }
    return 1 << 30;
  }

  String? minIdStringForEraByMapping(List<Map<String, dynamic>> cards, String eraLabel) {
    String? minId;
    int? minNum;
    for (final c in cards) {
      try {
        if (_cardInEraByMapping(c, eraLabel)) {
          final idStr = c['id']?.toString() ?? '';
          final n = _extractNumber(idStr);
          if (n <= 0) continue;
          if (minNum == null || n < minNum) {
            minNum = n;
            minId = idStr;
          }
        }
      } catch (_) {}
    }
    return minId;
  }

  // カードがマップに基づいて指定時代に属するか判定
  bool _cardInEraByMapping(Map<String, dynamic> c, String eraLabel) {
    final idStr = c['id']?.toString() ?? '';
    if (idStr.isEmpty) return false;
    final n = _extractNumber(idStr);
    final start = eraStartNumbers[eraLabel];
    if (start == null) return false;
    final nextStart = _nextEraStartNumber(eraLabel);
    return n >= start && n < nextStart;
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

      final Timestamp dueDate =
          dueTimestamp ?? Timestamp.fromDate(DateTime.now().add(Duration(days: 1)));

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
