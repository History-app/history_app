import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

const appStoreURL = 'https://apps.apple.com/jp/app/id6744389554?mt=8';

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
              if (await canLaunch(appStoreURL)) {
                await launch(
                  appStoreURL,
                  forceSafariVC: true,
                  forceWebView: true,
                );
              } else {
                throw Error();
              }
            },
          ),
        ],
      );
    },
  );
}
