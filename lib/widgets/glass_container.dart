import 'dart:ui';

import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 16.0,
    this.blur = 12.0,
    this.opacity,
    this.borderColor,
    this.gradient,
    this.neonGlow = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double blur;
  final double? opacity;
  final Color? borderColor;
  final Gradient? gradient;
  final bool neonGlow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceOpacity = opacity ?? (isDark ? 0.18 : 0.65);
    final border = borderColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.white.withValues(alpha: 0.5));

    Widget content = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: gradient ??
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xff1e1b2e).withValues(alpha: surfaceOpacity),
                          const Color(0xff1a1a2e).withValues(alpha: surfaceOpacity * 0.7),
                        ]
                      : [
                          Colors.white.withValues(alpha: surfaceOpacity),
                          Colors.white.withValues(alpha: surfaceOpacity * 0.6),
                        ],
                ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: border, width: 1.2),
          ),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );

    if (neonGlow && isDark) {
      content = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.15),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: content,
      );
    }

    return content;
  }
}
