import 'package:flutter/material.dart';
import '../../Model/widgets/common_app_bar.dart';

class StudyingNotePage extends StatelessWidget {
  final String noteId; // 遷移元から渡されるパラメータ

  const StudyingNotePage({super.key, required this.noteId});

  @override
  Widget build(BuildContext context) {
    final imagePath = 'assets/notes/$noteId.png';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: 'これだけ日本史',
        leadingIconPath: 'assets/arrow_back_ios.svg',
        onLeadingPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Image.asset(imagePath),
          ],
        ),
      ),
    );
  }
}
