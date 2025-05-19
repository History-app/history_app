import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/modal.dart';
import 'showing_note.dart';

class SvgNoteList extends StatelessWidget {
  const SvgNoteList({Key? key}) : super(key: key);

  // 画像アイテムを生成する共通メソッド
  Widget _buildImageItem(BuildContext context, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowingNotePage(noteId: imagePath),
          ),
        );
      },
      child: Container(
        width: 100,
        height: 149,
        child: SvgPicture.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 176,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 20, right: 20),
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              child: Wrap(
                spacing: 20, // ここで間隔を設定
                children: [
                  // 共通メソッドを使用して各SVG画像をタップ可能に
                  _buildImageItem(context, 'assets/note in List.svg'),
                  _buildImageItem(context, 'assets/note in List2.svg'),
                  // _buildImageItem(context, 'assets/note in List3.svg'),
                  // _buildImageItem(context, 'assets/note in List4.svg'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
