import 'package:flutter/material.dart';
import 'package:japanese_history_app/constant/app_strings.dart';
import 'package:open_mail_app_plus/open_mail_app_plus.dart';

Future mailAppPickerModal(BuildContext context) async {
  final result = await OpenMailAppPlus.openMailApp();
  print('result,$result');
  if (!result.didOpen == true && result.canOpen == true) {
    await showDialog<Widget>(
      context: context,
      builder: (_) {
        return MailAppPickerDialog(mailApps: result.options, title: Strings.mailAppOpenButton);
      },
    );
  }
}
