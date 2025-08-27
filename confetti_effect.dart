import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class ConfettiEffect extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool isStopped;

  const ConfettiEffect({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 3),
    this.isStopped = false,
  });

  @override
  State<ConfettiEffect> createState() => _ConfettiEffectState();
}

class _ConfettiEffectState extends State<ConfettiEffect> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: widget.duration);
    if (!widget.isStopped) {
      _confettiController.play();
    }
  }

  @override
  void didUpdateWidget(covariant ConfettiEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isStopped) {
      _confettiController.play();
    } else {
      _confettiController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.1,
            shouldLoop: false,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }
}