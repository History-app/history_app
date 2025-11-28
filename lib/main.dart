import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options_dev.dart' as dev;
import 'firebase_options_prod.dart' as prod;
import 'my_app.dart';

const String flavor = String.fromEnvironment('FLAVOR', defaultValue: 'prod');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseOptions options;

  switch (flavor) {
    case 'dev':
      options = dev.DefaultFirebaseOptions.currentPlatform;
      break;
    case 'prod':
    default:
      options = prod.DefaultFirebaseOptions.currentPlatform;
  }

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: options);
    }
  } catch (e) {}

  final app = Firebase.app();

  try {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    // _forceResetAuth();
  } catch (e) {}

  runApp(const ProviderScope(child: MyApp()));
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
