import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/View/bottom_nav_view.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MVVM BottomNav Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BottomNavView(),
    );
  }
}
