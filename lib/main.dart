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

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    final UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
    print("匿名ログイン成功: ${userCredential.user?.uid}");
  } catch (e) {
    print("匿名ログインエラー: $e");
  }
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

    print('認証状態をリセットしました');
  } catch (e) {
    print('認証リセット中にエラー: $e');
  }
}
