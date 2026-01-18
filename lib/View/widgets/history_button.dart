import 'package:flutter/material.dart';
import 'package:japanese_history_app/constant/app_size.dart';
import 'package:japanese_history_app/model/color/app_colors.dart';
import 'package:japanese_history_app/configs/app_color.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PrimaryButton extends HookWidget {
  const PrimaryButton({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.onPressed,
    this.color,
  });

  final double width;
  final double height;
  final String text;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed == null
              ? AppColor.gray.shade300
              : color ?? Theme.of(context).primaryColor,
          elevation: 0,
          padding: const EdgeInsets.all(3.0),
          alignment: Alignment.center,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          side: BorderSide(
            color: onPressed == null
                ? AppColor.gray.shade100
                : color ?? Theme.of(context).primaryColor,
            width: onPressed == null ? 0 : 1,
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColor.white),
        ),
      ),
    );
  }
}

class CustomPrimaryButton extends StatelessWidget {
  const CustomPrimaryButton({
    super.key,
    required this.textWidget,
    this.isValid = true,
    this.onPressed,
    this.backgroundColor,
    this.borderColor,
    this.icon,
  });

  final Widget textWidget;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final bool isValid;
  final Widget? icon;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: buttonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(74)),
            side: BorderSide(width: 1, color: borderColor ?? AppColors().outlineColor),
          ),
        ),
        onPressed: isValid ? onPressed : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Padding(padding: const EdgeInsets.only(right: 8), child: icon),
            textWidget,
          ],
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.onPressed,
  });

  final double width;
  final double height;
  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed == null ? AppColor.gray.shade300 : AppColor.white,
          elevation: 0,
          padding: const EdgeInsets.all(3.0),
          alignment: Alignment.center,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          side: BorderSide(
            color: onPressed == null ? AppColor.gray.shade300 : AppColor.gray.shade400,
            width: 0.7,
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: AppColor.gray.shade400, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class DangerButton extends HookWidget {
  const DangerButton({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.onPressed,
    required this.isTap,
  });

  final double width;
  final double height;
  final String text;
  final VoidCallback? onPressed;
  final bool isTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors().primaryRed.withValues(alpha: isTap ? 1 : 0.5),
          elevation: 0,
          padding: const EdgeInsets.all(3.0),
          alignment: Alignment.center,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColor.white),
        ),
      ),
    );
  }
}
