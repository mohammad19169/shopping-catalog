import 'package:flutter/material.dart';

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeAnimation({
    super.key,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: (500 * delay).round()),
      curve: Curves.easeOut,
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}