import 'package:flutter/material.dart';

class FuturisticBackground extends StatelessWidget {
  const FuturisticBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [const Color(0xff121614), const Color(0xff0e1210)]
                    : [const Color(0xfff1f0e8), const Color(0xffe9e8df)],
              ),
            ),
          ),
        ),
        Positioned(
          top: -160,
          right: -100,
          child: _AccentOrb(
            color: theme.colorScheme.primary,
            size: 420,
            opacity: isDark ? 0.08 : 0.05,
          ),
        ),
        Positioned(
          top: 480,
          left: -240,
          child: _AccentOrb(
            color: theme.colorScheme.secondary,
            size: 520,
            opacity: isDark ? 0.055 : 0.035,
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _PaperGrainPainter(
                lineColor: (isDark ? Colors.white : Colors.black).withValues(
                  alpha: isDark ? 0.022 : 0.018,
                ),
                dotColor: theme.colorScheme.primary.withValues(alpha: 0.035),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _AccentOrb extends StatelessWidget {
  const _AccentOrb({
    required this.color,
    required this.size,
    required this.opacity,
  });

  final Color color;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: opacity),
              blurRadius: size * 0.65,
              spreadRadius: size * 0.12,
            ),
          ],
        ),
        child: SizedBox.square(dimension: size),
      ),
    );
  }
}

class _PaperGrainPainter extends CustomPainter {
  _PaperGrainPainter({required this.lineColor, required this.dotColor});

  final Color lineColor;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 0.7;
    final dotPaint = Paint()..color = dotColor;

    const step = 52.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
    for (double y = 20; y < size.height; y += step * 2) {
      for (double x = 18; x < size.width; x += step * 2) {
        canvas.drawCircle(Offset(x, y), 1.1, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_PaperGrainPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.dotColor != dotColor;
  }
}
