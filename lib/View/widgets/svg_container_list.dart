import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/modal.dart';

class SvgContainerList extends StatelessWidget {
  const SvgContainerList({Key? key}) : super(key: key);

  // 画像アイテムを生成する共通メソッド
  Widget _buildImageItem(BuildContext context, String imagePath,
      {bool isSvg = false}) {
    return GestureDetector(
      onTap: () {
        AccountDeletedModal.show(context);
      },
      child: Container(
        width: 100,
        height: 149,
        child: isSvg
            ? SvgPicture.asset(
                imagePath,
                fit: BoxFit.contain,
              )
            : Image.asset(
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
                  _buildImageItem(context, 'assets/Paleolithic.png'),
                  _buildImageItem(context, 'assets/Jomon period.png'),
                  _buildImageItem(context, 'assets/text in List3.svg',
                      isSvg: true),
                  _buildImageItem(context, 'assets/text in List4.svg',
                      isSvg: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
