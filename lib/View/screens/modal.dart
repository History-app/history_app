import 'package:flutter/material.dart';
import 'package:japanese_history_app/constant/app_strings.dart';

class CommonsModal extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const CommonsModal({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
        width: 360,
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: const Color(0x80374142), // 50%透明の #374142
              offset: Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              width: 320,
              height: 51,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFFA4B6B8), width: 1),
              ),
              child: TextButton(
                onPressed: () {
                  onPressed();
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 100),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  Strings.backToTopLabel,
                  style: TextStyle(color: Color(0xFF768D8F), fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 呼び出し用
  static void show(BuildContext context, {required String title, required VoidCallback onPressed}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CommonsModal(title: title, onPressed: onPressed),
    );
  }
}
