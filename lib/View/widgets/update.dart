import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

const appStoreURL = 'https://apps.apple.com/jp/app/id6744389554?mt=8';
const androidStore =
    'https://play.google.com/store/apps/details?id=io.github.yutotaniguchi.japanesehistoryapp&hl=ja';

/// ダイアログを表示
void showUpdateDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      const title = 'バージョン更新のお知らせ';
      const message = '新しいバージョンのアプリが利用可能です。ストアより更新版を入手して、ご利用下さい。';
      const btnLabel = '今すぐ更新';
      return CupertinoAlertDialog(
        title: const Text(title),
        content: const Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text(
              btnLabel,
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              try {
                final isAndroid = !kIsWeb && Platform.isAndroid;
                final url = isAndroid ? androidStore : appStoreURL;
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {}
              } catch (e) {}
            },
          ),
        ],
      );
    },
  );
}
