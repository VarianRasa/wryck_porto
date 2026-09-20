import 'package:flutter/material.dart';

import 'motion.dart';

class TiltCard extends StatefulWidget {
  const TiltCard({
    super.key,
    required this.child,
    this.tiltDepth = 20.0,
    this.scaleDepth = 1.02,
  });

  final Widget child;
  final double tiltDepth;
  final double scaleDepth;

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard> {
  double x = 0.0;
  double y = 0.0;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final reducedMotion =
        MediaQuery.of(context).disableAnimations ||
        MediaQuery.of(context).accessibleNavigation;
    if (reducedMotion) return widget.child;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() {
        isHovered = false;
        x = 0.0;
        y = 0.0;
      }),
      onHover: (details) {
        if (!mounted) return;
        final size = context.size;
        if (size == null || size.width == 0 || size.height == 0) return;

        final dx = details.localPosition.dx - (size.width / 2);
        final dy = details.localPosition.dy - (size.height / 2);
        final nextX = ((dy / (size.height / 2)) * widget.tiltDepth).clamp(
          -12.0,
          12.0,
        );
        final nextY = (-(dx / (size.width / 2)) * widget.tiltDepth).clamp(
          -12.0,
          12.0,
        );
        if ((nextX - x).abs() < 0.5 && (nextY - y).abs() < 0.5) return;
        setState(() {
          x = nextX;
          y = nextY;
        });
      },
      child: TweenAnimationBuilder<double>(
        duration: motionDuration(context, const Duration(milliseconds: 200)),
        curve: Curves.easeOutCubic,
        tween: Tween<double>(begin: 0.0, end: isHovered ? 1.0 : 0.0),
        builder: (context, hoverAmount, _) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX((x * hoverAmount * 3.14159) / 180)
              ..rotateY((y * hoverAmount * 3.14159) / 180)
              ..scaleByDouble(
                1.0 + ((widget.scaleDepth - 1.0) * hoverAmount),
                1.0 + ((widget.scaleDepth - 1.0) * hoverAmount),
                1.0 + ((widget.scaleDepth - 1.0) * hoverAmount),
                1.0,
              ),
            alignment: Alignment.center,
            child: widget.child,
          );
        },
      ),
    );
  }
}
