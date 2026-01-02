import 'package:flutter/material.dart';
import 'package:japanese_history_app/model/color/app_colors.dart';
import '/View/bottom_nav_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '日本史学習アプリ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        progressIndicatorTheme: ProgressIndicatorThemeData(color: AppColors().primaryRed),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const BottomNavView(),
    );
  }
}
