import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Color/app_colors.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onLeadingPressed;
  final VoidCallback? exLeadingPressed;
  final VoidCallback? onActionPressed;
  final VoidCallback? exActionPressed;
  final String? leadingIconPath;
  final String? actionIconPath;
  final String? exleadingIconPath;
  final String? exactionIconPath;

  const CommonAppBar({
    super.key,
    this.title,
    this.leadingIconPath,
    this.exLeadingPressed,
    this.exActionPressed,
    this.actionIconPath,
    this.onLeadingPressed,
    this.onActionPressed,
    this.exleadingIconPath,
    this.exactionIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0.0,
      leadingWidth: 100,
      leading: Row(
        children: [
          // メインのleadingアイコン
          if (leadingIconPath != null)
            IconButton(
              icon: SvgPicture.asset(leadingIconPath!),
              iconSize: 24,
              onPressed: onLeadingPressed,
            ),
          // 追加のleadingアイコン
          if (exleadingIconPath != null)
            IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              iconSize: 24,
              icon: SvgPicture.asset(exleadingIconPath!),
              onPressed: exLeadingPressed,
            ),
        ],
      ),
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w700, // Semibold
                  fontSize: 17,
                  color: AppColors().primaryRed // 静的定数としてアクセス
                  ),
            )
          : null,
      centerTitle: true,
      actions: [
        if (actionIconPath != null)
          IconButton(
            icon: SvgPicture.asset(actionIconPath!),
            iconSize: 24,
            onPressed: onActionPressed,
          ),
        // 追加のactionアイコン
        if (exactionIconPath != null)
          IconButton(
            icon: SvgPicture.asset(exactionIconPath!),
            iconSize: 24,
            onPressed: exActionPressed,
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Container(
          color: AppColors().grey,
          height: 0.5,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 0.5);
}
