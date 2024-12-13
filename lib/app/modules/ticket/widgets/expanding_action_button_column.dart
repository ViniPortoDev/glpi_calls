import 'dart:math';

import 'package:flutter/material.dart';

class ExpandingActionButtonColumn extends StatelessWidget {
  final double height;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  const ExpandingActionButtonColumn({
    super.key,
    required this.height,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          90 * (pi / 180.0),
          progress.value * height,
        );
        return Positioned(
          right: offset.dx,
          bottom: offset.dy,
          child: Transform.scale(
            scale: (progress.value),
            child: child,
        ));
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}