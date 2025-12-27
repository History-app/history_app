import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeaturePromotionCard extends StatelessWidget {
  const FeaturePromotionCard({
    super.key,
    required this.title,
    required this.description,
    required this.backgroundColor,
    this.imageAssetPath,
    this.onTap,
  });

  final String title;
  final String description;
  final Color backgroundColor;
  final String? imageAssetPath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 186,
        height: 92,
        padding: const EdgeInsets.only(
          left: 14,
          top: 12,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    height: 1,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  description,
                  style: const TextStyle(
                    height: 1.15,
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 55,
                height: 52,
                child: imageAssetPath != null
                    ? Image.asset(
                        imageAssetPath!,
                        fit: BoxFit.contain,
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
