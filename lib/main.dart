import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options_dev.dart' as dev;
import 'firebase_options_prod.dart' as prod;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';
import './DB/database_helper.dart';
import 'package:flutter/foundation.dart';
import '/View/bottom_nav_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // const flavor = String.fromEnvironment('FLAVOR'); // dart-define で指定
  // final isProd = flavor.isEmpty || flavor == 'prod';
  // if (Firebase.apps.isEmpty) {
  //   if (isProd) {
  //     // 本番環境: google-services.json / GoogleService-Info.plist に基づく自動初期化
  //     // この場合、options は不要
  //     print("isProd: Initializing Firebase without explicit options.");
  //     await Firebase.initializeApp();
  //   } else {
  //     // 開発環境: dev 用の Firebase 設定を明示的に指定
  //     print("isDev: Initializing Firebase with dev options.");
  //     await Firebase.initializeApp(
  //       options: dev.DefaultFirebaseOptions.currentPlatform,
  //     );
  //   }
  // } else {
  //   // 既に初期化されている場合は何もしないか、特定のアプリインスタンスを取得する
  //   print("Firebase app already initialized.");
  //   // FirebaseApp app = Firebase.app(); // デフォルトアプリを取得
  //   // FirebaseApp otherApp = Firebase.app('otherApp'); // 名前付きアプリを取得
  // }
  // await Firebase.initializeApp(
  //   options: isProd
  //       ? prod.DefaultFirebaseOptions.currentPlatform
  //       : dev.DefaultFirebaseOptions.currentPlatform,
  // );]
  // await _forceResetAuth();
  // await Firebase.initializeApp();
  try {
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    print("匿名ログイン成功: ${userCredential.user?.uid}");
  } catch (e) {
    print("匿名ログインエラー: $e");
  }
  // final dbHelper = DatabaseHelper();
  // await dbHelper.database;

  // final books = await DatabaseHelper().getBooks();
  // Future<bool> isBooks1TableExists() async {
  //   final db = await DatabaseHelper().database;
  //   final result = await db.rawQuery(
  //       "SELECT name FROM sqlite_master WHERE type='table' AND name='books1';");
  //   return result.isNotEmpty;
  // }

  // void checkBooks1Table() async {
  //   final exists = await isBooks1TableExists();
  //   if (exists) {
  //     print('✅ テーブル「books1」は存在します。');
  //   } else {
  //     print('❌ テーブル「books1」は存在しません！');
  //   }
  // }

  // print('ここからデータベースの内容を表示します');
  // checkBooks1Table();
  // for (var book in books) {
  //   print('--- Book ---');
  //   print('ID: ${book.id}');
  //   print('Theme: ${book.theme}');
  //   print('Star: ${book.star}');
  //   print('HNRef: ${book.hnref}');
  //   print('Question: ${book.question}');
  //   print('Answer: ${book.answer}');
  //   print('Notes: ${book.notes}');
  // }
  // _forceResetAuth();
  runApp(const ProviderScope(child: MyApp()));
}

// MyAppクラスを追加
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '日本史学習アプリ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const BottomNavView(),
    );
  }
}

Future<void> _forceResetAuth() async {
  try {
    // 現在のユーザー情報をプリント
    print('現在のユーザー: ${FirebaseAuth.instance.currentUser?.uid}');

    // 強制的にトークンを無効化
    await FirebaseAuth.instance.signOut();

    // if (kIsWeb) {
    //   await FirebaseAuth.instance.setPersistence(Persistence.NONE);
    // }

    print('認証状態をリセットしました');
  } catch (e) {
    print('認証リセット中にエラー: $e');
  }
}
