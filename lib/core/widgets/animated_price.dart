import 'package:flutter/material.dart';

class AnimatedPrice extends StatelessWidget {
  final double value;
  final TextStyle style;
  final int fractionDigits;
  final Duration duration;

  const AnimatedPrice({
    super.key,
    required this.value,
    required this.style,
    this.fractionDigits = 2,
    this.duration = const Duration(milliseconds: 350),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: value, end: value),
      duration: duration,
      builder: (context, animatedValue, _) {
        return Text(
          animatedValue.toStringAsFixed(fractionDigits),
          style: style,
        );
      },
    );
  }
}
