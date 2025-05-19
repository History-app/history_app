import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'app_colors.freezed.dart';

@freezed
class AppColors with _$AppColors {
  const factory AppColors(
      {@Default(Color(0xFFF24326)) Color primaryRed,
      @Default(Color(0xFF302D58)) Color primaryBlack,
      @Default(Color(0xFFFC917F)) Color paleRed,
      @Default(Color(0xFFFDFDFD)) Color paleGrey,
      @Default(Color(0xFFD6D6D6)) Color grey,
      @Default(Color(0xFFB41F06)) Color preRed,
      @Default(Color(0xFFE66650)) Color prePaleRed,
      @Default(Color(0xFF2A3840)) Color preBlue,
      @Default(Color(0xFFA7A8A7)) Color preGrey,
      @Default(Color(0xFF3B82F6)) Color blue,
      @Default(Color(0xFF16A34A)) Color green,
      @Default(Color(0xFFF7C80C)) Color accentYellow,
      @Default(Color(0x61222222)) Color menu_Grey,
      @Default(Color(0x66D6D6D6)) Color pale_profile_grey,
      @Default(Color(0xFF32ADE6)) Color skyBlue}) = _AppColors;
}
