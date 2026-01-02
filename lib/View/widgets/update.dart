import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:japanese_history_app/constant/app_strings.dart';

const appStoreURL = 'https://apps.apple.com/jp/app/id6744389554?mt=8';
const androidStore =
    'https://play.google.com/store/apps/details?id=io.github.yutotaniguchi.japanesehistoryapp&hl=ja';

/// ダイアログを表示
void showUpdateDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const Text(Strings.versionUpdateNotice),
        content: const Text(Strings.updateAvailableMessage),
        actions: <Widget>[
          TextButton(
            child: const Text(
              Strings.updateNowLabel,
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
