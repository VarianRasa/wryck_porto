import 'package:flutter/material.dart';

class AnimatedGradientText extends StatelessWidget {
  const AnimatedGradientText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.gradientColors,
    this.duration = const Duration(seconds: 3),
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final List<Color>? gradientColors;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors =
        gradientColors ??
        (theme.brightness == Brightness.dark
            ? const [Color(0xff9aa8ff), Color(0xff5cc8d7)]
            : const [Color(0xff3156b5), Color(0xff167b84)]);

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: colors,
      ).createShader(bounds),
      child: Text(text, style: style, textAlign: textAlign),
    );
  }
}
