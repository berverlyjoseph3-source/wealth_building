import 'package:flutter/material.dart';

class NumberPad extends StatelessWidget {
  final int currentValue;
  final Function(int) onChanged;

  const NumberPad({super.key, required this.currentValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          currentValue == 0 ? 'Enter answer' : currentValue.toString(),
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(10, (index) {
            final number = index == 9 ? 0 : index + 1; // 0 at the end
            return NumberButton(
              number: number,
              onPressed: () => onChanged(currentValue * 10 + number),
            );
          }),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.backspace),
              onPressed: () => onChanged(currentValue ~/ 10),
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => onChanged(0),
            ),
          ],
        )
      ],
    );
  }
}

class NumberButton extends StatelessWidget {
  final int number;
  final VoidCallback onPressed;

  const NumberButton({super.key, required this.number, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(
          number.toString(),
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}