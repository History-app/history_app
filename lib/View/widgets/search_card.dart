import 'package:flutter/material.dart';
import '../../Model/widgets/ search_app_bar.dart'; // 新しいファイルをインポート
import 'package:gap/gap.dart';

class SearchAppBarPage extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onBackPressed;

  const SearchAppBarPage({
    super.key,
    required this.controller,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    // 表示したいデータ（例：左が質問、右が説明）
    final List<List<String>> data = [
      ['地球上に...のことか。', '約700...'],
      ['第四紀に...というか。', '更新世(...'],
      ['更新世は...というか。', '氷河時代'],
      ['氷河時代...と呼ぶか。', '氷期'],
      ['氷河時代...と呼ぶか。', '間氷期'],
      ['更新世の...の化石か。', 'ナウマン...'],
      ['人類は進...にあげよ。', '猿人・原...'],
      ['日本列島...あったか。', '新人'],
      ['静岡県浜...というか。', '浜北人'],
      ['沖縄県で...つあげよ。', '港川人・...'],
      ['東アジア...というか。', '古モンゴ...'],
      ['モンゴロ...というか。', '新モンゴ...'],
      ['日本語の...とは何か。', 'アルタイ...'],
      ['人類の文...というか。', '石器時代'],
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SearchAppBar(
        controller: controller,
        onBackPressed: onBackPressed,
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Container(
            height: 30,
            padding: const EdgeInsets.only(
              left: 8,
              // vertical: 12
            ),
            decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.grey, width: 0.25)),
              color: Colors.white,
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150,
                  child: Text(
                    data[index][0],
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Gap(143),
                Text(
                  data[index][1],
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
