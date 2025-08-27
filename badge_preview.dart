import 'package:flutter/material.dart';
import 'package:trachtenberg_math/models/badge_model.dart';

class BadgePreview extends StatelessWidget {
  final Badge badge;
  final bool isUnlocked;
  final double size;

  const BadgePreview({
    super.key,
    required this.badge,
    required this.isUnlocked,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isUnlocked ? badge.description : 'Locked: ${badge.unlockCondition}',
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnlocked ? Colors.amber[100] : Colors.grey[300],
              border: Border.all(
                color: isUnlocked ? Colors.amber : Colors.grey,
                width: 3,
              ),
            ),
            child: Center(
              child: isUnlocked
                  ? Image.asset(badge.iconAsset, width: size * 0.7)
                  : const Icon(Icons.lock, size: 30),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            badge.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
              color: isUnlocked ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}