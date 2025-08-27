import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final Color backgroundColor;
  final Color progressColor;

  const ProgressBar({
    super.key,
    required this.value,
    this.height = 20,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: constraints.maxWidth * value.clamp(0.0, 1.0),
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              );
            },
          ),
          Center(
            child: Text(
              '${(value * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                color: value > 0.5 ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}