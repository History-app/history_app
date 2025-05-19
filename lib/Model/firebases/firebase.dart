import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Card/cards_data_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:logging/logging.dart';

final currentUser = FirebaseAuth.instance.currentUser;

final userId = currentUser?.uid;
// 特定のノート（book1/chapter1/note1）のデータを取得する関数

final cardsDataNotifierProvider =
    NotifierProvider<CardsDataNotifier, CardsDataState>(CardsDataNotifier.new);

class CardsDataNotifier extends Notifier<CardsDataState> {
  @override
  CardsDataState build() {
    return const CardsDataState();
  }
  //ここでメモを保存する関数を作成する

  Future<void> saveMemo({required String cardId, required String memo}) async {
    try {
      if (userId == null) {
        print('エラー: ユーザーがログインしていません。');
        return;
      }

      // Firestoreの参照を取得
      final cardRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('learnedCards')
          .doc(cardId);

      // メモと更新日時を保存
      await cardRef.update({
        'memo': memo,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final updatedCards =
          List<Map<String, dynamic>>.from(state.usersMultipleCards);
      for (int i = 0; i < updatedCards.length; i++) {
        if (updatedCards[i]['id'] == cardId) {
          updatedCards[i]['memo'] = memo;
          break;
        }
      }

      // 状態を更新
      state = state.copyWith(usersMultipleCards: updatedCards);

      print('メモが正常に保存されました: cardId=$cardId');
    } catch (e) {
      print('メモの保存中にエラーが発生しました: $e');
      // エラー処理をここに追加（UIへの通知など）
    }
  }

  Future<void> fetchCardsData() async {
    //ここで全てのカードデータを取得する
    final allLearnedCards = await fetchAllLearnedCards();

    final cardsData = await getUsersCardsData(allLearnedCards);
    print('取得したカード${cardsData}');
    state = state.copyWith(cards: cardsData);
    calculateCardStats();
  }

  Future<void> fetchTodaysReviewNoteRefs() async {
    final todaysReviewRefs = await getTodaysReviewData(state.cards);
    state = state.copyWith(todaysReviewNoteRefs: todaysReviewRefs);
  }

  void incrementLeftValueCount(dynamic key, [int increment = 1]) {
    // 現在のマップをコピー
    final currentDistribution =
        Map<dynamic, int>.from(state.leftValueDistribution);

    // キーが存在する場合は値を増やす、存在しない場合は新しく追加
    currentDistribution[key] = (currentDistribution[key] ?? 0) + increment;

    // 新しいマップでstateを更新
    state = state.copyWith(leftValueDistribution: currentDistribution);
  }

  void decrementLeftValueCount(dynamic key, [int decrement = 1]) {
    // 現在のマップをコピー
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

  Future<void> fetchUsersMultipleCards() async {
    print('これがstate.todaysReviewNoteRefsです');
    print(state.todaysReviewNoteRefs);
    final multipleCardsData =
        await getUsersMultipleCardsData(state.todaysReviewNoteRefs);
    print('取得したmultipleCardsData$multipleCardsData');
    state = state.copyWith(usersMultipleCards: multipleCardsData);
  }

  void updateNotes(List<Map<String, dynamic>> allNotes) {
    state = state.copyWith(allNotes: allNotes);
  }

  void updateLeftValueDistribution(Map<dynamic, int> distribution) {
    state = state.copyWith(leftValueDistribution: distribution);
  }

  void setLeftValueDistribution(Map<dynamic, int> distribution) {
    state = state.copyWith(leftValueDistribution: distribution);
  }

  fetchAllLearnedCards() async {
    final allCards = await getAllUserLearnedCards();
    state = state.copyWith(allLearnedCards: allCards);

    return allCards;
  }

  // 統計情報を計算するメソッド
  void calculateCardStats() {
    final allCards = state.allLearnedCards;
    if (allCards.isEmpty) return;

    // 分布情報を計算
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

    // 状態を更新
    state = state.copyWith(
        newCardCount: newCardCount,
        learningCardCount: learningCardCount,
        reviewCardCount: reviewCardCount,
        totalCardCount: totalCardCount);
  }

  void moveCardBetweenCategories(int from, int to) {
    // 現在の値を取得
    int newCount = state.newCardCount;
    int learningCount = state.learningCardCount;
    int reviewCount = state.reviewCardCount;

    // 移動元からカードを減らす
    switch (from) {
      case 0: // 新規カード
        if (newCount > 0) {
          newCount--;
        } else {
          print('警告: 新規カードが0のため減算できません');
          return; // 何も変更せずに終了
        }
        break;

      case 1: // 学習中カード
        if (learningCount > 0) {
          learningCount--;
        } else {
          print('警告: 学習中カードが0のため減算できません');
          return;
        }
        break;

      case 2: // 復習カード
        if (reviewCount > 0) {
          reviewCount--;
        } else {
          print('警告: 復習カードが0のため減算できません');
          return;
        }
        break;

      default:
        print('エラー: 不正なfrom値です (0, 1, 2のいずれかを指定)');
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
        print('エラー: 不正なto値です (1または2を指定)');
        return;
    }

    // 状態を更新
    state = state.copyWith(
      newCardCount: newCount,
      learningCardCount: learningCount,
      reviewCardCount: reviewCount,
      // 合計は変わらないので更新不要
    );

    print('カードを移動しました - 新規: $newCount, 学習中: $learningCount, 復習: $reviewCount');
  }
}

Future<List<Map<String, dynamic>>> getAllUserLearnedCards() async {
  try {
    if (userId == null) {
      print('ユーザーIDがnullです。ログイン状態を確認してください。');
      return [];
    }

    // 最大リトライ回数
    int maxRetries = 3;
    int currentRetry = 0;

    while (currentRetry < maxRetries) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('learnedCards')
          .get();

      // データが存在する場合は結果を返す
      if (querySnapshot.docs.isNotEmpty) {
        // 各ドキュメントのデータとIDを取得して返す
        List<Map<String, dynamic>> results = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          // ドキュメントIDを含める（必要に応じて）
          data['id'] = doc.id;
          return data;
        }).toList();

        print('取得したカード数: ${results.length}');
        return results;
      } else {
        // データが存在しない場合
        currentRetry++;
        print('カードデータが見つかりません。リトライ ${currentRetry}/${maxRetries}');

        if (currentRetry < maxRetries) {
          // 待機時間を指数バックオフで増加（例: 1秒、2秒、4秒...）
          int delaySeconds = currentRetry * 2;
          print('${delaySeconds}秒後に再試行します...');
          await Future.delayed(Duration(seconds: delaySeconds));
        }
      }
    }

    // すべてのリトライが失敗した場合
    print('最大リトライ回数に達しました。カードデータを取得できませんでした。');
    return [];
  } catch (e) {
    print('カードデータ取得中にエラーが発生しました: $e');
    return [];
  }
}

// int _extractNumberFromId(String id) {
//   final regex = RegExp(r'\d+');
//   final match = regex.firstMatch(id);
//   return match != null ? int.parse(match.group(0)!) : 0;
// }

// /// ナチュラルソート（数値順）で並べ替える
// List<Map<String, dynamic>> _sortCardsNaturalOrder(
//     List<Map<String, dynamic>> cards) {
//   cards.sort((a, b) {
//     final idA = a['id'] as String;
//     final idB = b['id'] as String;
//     return _extractNumberFromId(idA).compareTo(_extractNumberFromId(idB));
//   });
//   return cards;
// }

/// ID文字列から数値部分だけ取り出す
int _extractNumber(String id) {
  final m = RegExp(r'\d+').firstMatch(id);
  return m != null ? int.parse(m.group(0)!) : 0;
}

/// nullLeftCards を「1～52」と「53～」の 2 グループに分けてソート＆結合
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

Future<List<Map<String, dynamic>>> getUsersCardsData(
    [List<Map<String, dynamic>>? allLearnedCards]) async {
  try {
    final cards = allLearnedCards ?? [];
    // 1. ユーザーの制限情報とセッション情報を格納するドキュメントへの参照
    final limitsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('cardLimits');

    // 2. トランザクションを使用
    return await FirebaseFirestore.instance
        .runTransaction<List<Map<String, dynamic>>>((transaction) async {
      // 制限情報ドキュメントを取得
      final limitsDoc = await transaction.get(limitsRef);
      final today = DateTime.now().toIso8601String().substring(0, 10);

      int todayFetchCount = 0;
      String lastFetchDate = '';
      // 今日表示したnullカードのIDリスト
      List<String> todaysNullCardIds = [];

      if (limitsDoc.exists) {
        lastFetchDate = limitsDoc.data()?['lastFetchDate'] ?? '';

        if (lastFetchDate == today) {
          todayFetchCount = limitsDoc.data()?['todayFetchCount'] ?? 0;
          // 保存されている表示済みカードIDを取得
          todaysNullCardIds =
              List<String>.from(limitsDoc.data()?['todaysNullCardIds'] ?? []);
        }
      }

      // 日付が変わればリセット
      if (lastFetchDate != today) {
        todayFetchCount = 0;
        todaysNullCardIds = [];
      }

      final remainingFetchCount = 5 - todayFetchCount;

      // 全カードを取得

      List<Map<String, dynamic>> nullLeftCards = [];
      List<Map<String, dynamic>> nonNullLeftCards = [];
      // 今日既に表示したnullカード
      List<Map<String, dynamic>> todaysDisplayedNullCards = [];

      // 先ほどと同じヘルパー

      for (var data in cards) {
        // ここで以前のdoc.data()ではなく直接dataを使用

        if (!data.containsKey('left') || data['left'] == null) {
          // 既に今日表示済みのカードかどうか確認
          if (todaysNullCardIds.contains(data['id'])) {
            todaysDisplayedNullCards.add(data);
          } else {
            nullLeftCards.add(data);
          }
        } else {
          nonNullLeftCards.add(data);
        }
      }
      print('todaysDisplayedNullCards:$todaysDisplayedNullCards');
      print('nullLeftCards: $nullLeftCards');
      // 取得可能数に制限
      List<Map<String, dynamic>> newNullCards = [];
      List<String> newNullCardIds = [];

      if (remainingFetchCount > 0) {
        int fetchCount = nullLeftCards.length < remainingFetchCount
            ? nullLeftCards.length
            : remainingFetchCount;

        // newNullCards = nullLeftCards.sublist(0, fetchCount);

        final orderedNullLeft = _orderNullLeftCards(nullLeftCards);

        // 2) 取得数だけ先頭から抜き出す
        final actualFetchCount = orderedNullLeft.length < remainingFetchCount
            ? orderedNullLeft.length
            : remainingFetchCount;
        newNullCards = orderedNullLeft.sublist(0, actualFetchCount);

        // 3) ID リストの更新（既存 + 新規）
        newNullCardIds = newNullCards.map((c) => c['id'].toString()).toList();

        // 新たに表示するカードのIDを記録
        newNullCardIds =
            newNullCards.map((card) => card['id'].toString()).toList();

        // 更新するカードIDリスト（既存のものと新しいもの）
        List<String> updatedCardIds = [...todaysNullCardIds, ...newNullCardIds];

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

//現在の日付より前のカードのnoteRefを取得する関数
Future<List<String>> getTodaysReviewData(
    List<Map<String, dynamic>> cardsData) async {
  try {
    // 現在の時刻を取得
    final now = DateTime.now();

    // 条件に合うカードをフィルタリング
    List<Map<String, dynamic>> filteredCards = cardsData.where((card) {
      if (card['due'] == null) {
        return true; // dueがnullの場合も含める
      } else {
        DateTime dueDate = (card['due'] as Timestamp).toDate();
        return dueDate.isBefore(now);
      }
    }).toList();

    // フィルタリングされたカードからnoteRefのみを含む文字列リストを生成
    List<String> results =
        filteredCards.map((card) => card['noteRef'] as String).toList();

    return results; // noteRefのみのリストを返す
  } catch (e) {
    print('復習データのフィルタリング中にエラーが発生しました: $e');
    return [];
  }
}

// 修正後: List<Map<String, dynamic>> を返す
Future<List<Map<String, dynamic>>> getNotesByNoteRef(String noteRef) async {
  // 検索するチャプターのリスト
  final List<String> chapters = [
    'chapter1',
    'chapter2',
    'chapter3',
  ];

  try {
    // 各チャプターを順番に検索
    for (String chapter in chapters) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('books')
          .doc('book1')
          .collection('chapters')
          .doc(chapter) // 動的にチャプター変更
          .collection('notes')
          .doc(noteRef)
          .get();

      if (docSnapshot.exists) {
        print('ノートが見つかりました: $noteRef (in $chapter)');
        return [docSnapshot.data()!];
      }
    }

    print('どのチャプターでもノートが見つかりませんでした: $noteRef');
    return [];
  } catch (e) {
    print('ノート検索エラー: $e');
    return [];
  }
}

// null値を持つフィールドを除外するヘルパー関数
Map<String, dynamic> removeNullFields(Map<String, dynamic> data) {
  return data..removeWhere((key, value) => value == null);
}

// 関数を使用した更新
Future<void> updateLearnedCardsData(String noteRef, int newQueue, int newType,
    {Timestamp? dueTimestamp, int? left, int? factor, dynamic? newivl}) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
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

//特定のusersの全てのlearnedCardsのデータを取得する関数
Future<List<Map<String, dynamic>>> getUsersMultipleCardsData(
    List<String> noteRefs) async {
  try {
    // 空のリストチェック
    if (noteRefs.isEmpty) return [];

    List<Map<String, dynamic>> results = [];

    // 各noteRefに対して順番にクエリを実行
    for (String noteRef in noteRefs) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('learnedCards')
          .where('noteRef', isEqualTo: noteRef) // whereInではなくisEqualToを使用
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // このnoteRefに対応するドキュメントをresultsに追加
        Map<String, dynamic> data = querySnapshot.docs.first.data();

        // ドキュメントIDを追加
        data['id'] = querySnapshot.docs.first.id;

        results.add(data);
        // Use a logging framework instead of print for production
        print('これが$data');
      } else {
        // ドキュメントが見つからない場合の処理（必要に応じて）
        print('noteRef: $noteRef に対応するカードが見つかりませんでした');
      }
    }

    return results;
  } catch (e) {
    print('Error fetching cards: $e');
    return [];
  }
}

//アプリ起動時に呼ぶ
Future<bool> versionCheck() async {
  try {
    // アプリのバージョンを取得
    final info = await PackageInfo.fromPlatform();
    final currentVersion = Version.parse(info.version);

    // Firestoreからアップデートしたいバージョンを取得
    final doc = await FirebaseFirestore.instance
        .collection('config')
        .doc('hPYRQlZmrx8WWejONhcy')
        .get();
    final newVersion =
        Version.parse(doc.data()!['ios_force_app_version'] as String);

    // 比較結果を返す（UIロジックは含めない）
    return currentVersion < newVersion;
  } catch (e) {
    return false; // エラー時はアップデート不要と判断
  }
}
  
  // FIXME ストアにアプリを登録したらurlが入れられる
  