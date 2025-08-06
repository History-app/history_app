// lib/models/text_styles.dart
import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle hiraginoW4 = TextStyle(
    fontFamily: 'Hiragino Sans',
    fontWeight: FontWeight.w400,
  );
  static const TextStyle hiraginoW6 = TextStyle(
    fontFamily: 'Hiragino Sans',
    fontWeight: FontWeight.w600,
  );
  static const TextStyle hiraginoW7 = TextStyle(
    fontFamily: 'Hiragino Sans',
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );
  static const TextStyle notoSansDisplay = TextStyle(
    fontFamily: 'Noto Sans',
    fontWeight: FontWeight.w600, // Displayスタイルなら通常は w400（調整可能）
    fontSize: 16,
  );
  static const TextStyle sfProSemibold24 = TextStyle(
    fontFamily: 'SF Pro',
    fontWeight: FontWeight.w600, // Semibold
  );

  static const TextStyle sfProRegular24 = TextStyle(
    fontFamily: 'SF Pro',
    fontWeight: FontWeight.w400, // Regular
  );

  static const TextStyle sourceSansProBold24 = TextStyle(
    fontFamily: 'Source Sans Pro',
    fontWeight: FontWeight.w700, // Bold
    fontSize: 24,
    height: 1.0, // 24px / 24px = 1.0
    letterSpacing: 1.0, // 1px
  );

  // 他のTextStyleもここに追加可能
}
