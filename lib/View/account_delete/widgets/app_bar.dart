// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
// Project imports:
import 'package:japanese_history_app/model/color/app_colors.dart';
import 'package:japanese_history_app/constant/app_strings.dart';

class AccountDeleteAppBar extends HookWidget implements PreferredSizeWidget {
  const AccountDeleteAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final appBarHeight = MediaQuery.of(context).padding.top + 68;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(width: 1, color: AppColors().preGrey)),
            boxShadow: <BoxShadow>[
              BoxShadow(color: AppColors().preGrey, blurRadius: 1, offset: const Offset(0, 1)),
            ],
          ),
          height: appBarHeight,
          padding: EdgeInsets.only(top: statusBarHeight),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 15),
                child: IconButton(
                  icon: Icon(Icons.chevron_left, size: 38, color: AppColors().primaryRed),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                child: Text(
                  Strings.accountDeleteTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.8,
                    color: AppColors().primaryRed,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(68);
}
