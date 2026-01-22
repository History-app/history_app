// Flutter imports:
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OverLayLoading extends StatelessWidget {
  const OverLayLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.6)),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
        ],
      ),
    );
  }
}

class OverLayLoadingModal extends StatelessWidget {
  const OverLayLoadingModal({super.key});
  @override
  Widget build(BuildContext context) {
    return const Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
        ],
      ),
    );
  }
}
