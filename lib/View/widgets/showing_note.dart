import 'package:flutter/material.dart';
import '../../Model/widgets/common_app_bar.dart';

class ShowingNotePage extends StatelessWidget {
  final String noteId; // 遷移元から渡されるパラメータ

  const ShowingNotePage({super.key, required this.noteId});

  @override
  Widget build(BuildContext context) {
    // noteIdに基づいて表示内容を決定
    // final imagePath = 'assets/notes/$noteId.png';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: 'ノート一覧',
        leadingIconPath: 'assets/arrow_back_ios.svg',
        onLeadingPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            if (noteId == 'assets/note in List.svg') ...[
              Image.asset('assets/notes/11.png'),
              Image.asset('assets/notes/10.png'),
              Image.asset('assets/notes/1.png'),
              Image.asset('assets/notes/2.png'),
              Image.asset('assets/notes/5.png'),
              Image.asset('assets/notes/8.png'),
            ],
            if (noteId == 'assets/note in List2.svg') ...[
              Image.asset('assets/notes/1.png'),
              Image.asset('assets/notes/2.png'),
              Image.asset('assets/notes/3.png'),
              Image.asset('assets/notes/4.png'),
              Image.asset('assets/notes/5.png'),
              Image.asset('assets/notes/6.png'),
              Image.asset('assets/notes/7.png'),
              Image.asset('assets/notes/9.png'),
            ]
          ],
        ),
      ),
    );
  }
}
