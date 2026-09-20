import 'package:flutter/material.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 64, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontSize: 11,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Divider(height: 1, thickness: 1, color: theme.dividerColor),
          ),
        ],
      ),
    );
  }
}
