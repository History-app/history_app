import 'package:flutter/material.dart';
import 'package:japanese_history_app/Model/color/app_colors.dart';
import 'package:japanese_history_app/constant/app_strings.dart';
import '../../model/widgets/common_app_bar.dart';

class StudyingNotePage extends StatelessWidget {
  final String noteId; // 遷移元から渡されるパラメータ

  const StudyingNotePage({super.key, required this.noteId});

  @override
  Widget build(BuildContext context) {
    final imagePath = 'assets/notes/$noteId.png';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: Strings.title,
        icon: SizedBox(
          width: 40,
          height: 40,
          child: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 32,
              color: AppColors().primaryRed,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
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
