import 'package:flutter/material.dart';

bool reducedMotion(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  final accessibilityFeatures = View.of(
    context,
  ).platformDispatcher.accessibilityFeatures;
  return mediaQuery.disableAnimations ||
      mediaQuery.accessibleNavigation ||
      accessibilityFeatures.reduceMotion;
}

Duration motionDuration(BuildContext context, Duration normal) {
  return reducedMotion(context) ? Duration.zero : normal;
}
