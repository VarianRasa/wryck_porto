import 'package:flutter/material.dart';

import '../models/portfolio_models.dart';
import 'external_action_link.dart';

class ContactBar extends StatelessWidget {
  const ContactBar({
    super.key,
    required this.actions,
    this.alignment = WrapAlignment.center,
  });

  final List<ContactAction> actions;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: alignment,
      spacing: 10,
      runSpacing: 6,
      children: [
        for (final action in actions)
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: ExternalActionLink(action: action),
          ),
      ],
    );
  }
}
