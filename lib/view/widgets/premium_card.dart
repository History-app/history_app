import 'package:flutter/material.dart';
import 'package:japanese_history_app/common/ui_helper.dart';
import 'package:japanese_history_app/constant/app_strings.dart';

class PremiumCard extends StatelessWidget {
  const PremiumCard({
    super.key,
    required this.title,
    required this.backgroundColor,
    this.imageAssetPath,
    this.onTap,
  });

  final Widget title;
  final Color backgroundColor;
  final String? imageAssetPath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            // 左側テキスト群
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                title, // ← そのまま使う
                verticalSpaceSmall,
                _AuthorChip(
                  accentColor: backgroundColor,
                ),
              ],
            ),
            // 右下キャラクター
            if (imageAssetPath != null)
              Positioned(
                right: -20,
                bottom: -15,
                child: Image.asset(
                  imageAssetPath!,
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AuthorChip extends StatelessWidget {
  const _AuthorChip({
    required this.accentColor,
  });

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        Strings.authorCreditText,
        textAlign: TextAlign.center,
        textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1),
        style: TextStyle(color: accentColor, fontWeight: FontWeight.w600, fontSize: 16),
      ),
    );
  }
}
