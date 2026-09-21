import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/portfolio_models.dart';
import 'motion.dart';

class ExternalActionLink extends StatefulWidget {
  const ExternalActionLink({super.key, required this.action});

  final ContactAction action;

  @override
  State<ExternalActionLink> createState() => _ExternalActionLinkState();
}

class _ExternalActionLinkState extends State<ExternalActionLink> {
  bool _isHovered = false;

  Uri? _targetUri() {
    final uri = widget.action.uri;
    final label = widget.action.label.toLowerCase();

    if (label == 'telepon') {
      final rawPhone = widget.action.value.trim().isNotEmpty
          ? widget.action.value
          : uri?.toString() ?? '';
      final normalized = rawPhone.replaceAll(RegExp(r'[^0-9+]'), '');
      if (normalized.isEmpty) return uri;

      final whatsappNumber = normalized
          .replaceFirst(RegExp(r'^\+'), '')
          .replaceFirst(RegExp(r'^0'), '62');
      return Uri.parse('https://wa.me/$whatsappNumber');
    }

    if (label == 'email') {
      final rawEmail = widget.action.value.trim().isNotEmpty
          ? widget.action.value
          : uri?.path ?? '';
      final email = rawEmail.replaceFirst('mailto:', '').trim();
      if (email.isEmpty) return uri;

      return Uri.https('mail.google.com', '/mail/', {
        'view': 'cm',
        'fs': '1',
        'to': email,
      });
    }

    return uri;
  }

  Future<void> _open(BuildContext context) async {
    final uri = _targetUri();
    if (uri == null) {
      return;
    }

    final messenger = ScaffoldMessenger.maybeOf(context);
    var opened = false;
    try {
      opened = await launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (_) {
      opened = false;
    }

    if (!opened && messenger != null) {
      messenger.showSnackBar(
        SnackBar(content: Text('Tidak dapat membuka ${widget.action.label}.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasAction = _targetUri() != null;

    final child = MouseRegion(
      onEnter: hasAction ? (_) => setState(() => _isHovered = true) : null,
      onExit: hasAction ? (_) => setState(() => _isHovered = false) : null,
      cursor: hasAction ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: motionDuration(context, const Duration(milliseconds: 200)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _isHovered
              ? theme.colorScheme.primary.withValues(alpha: 0.08)
              : (isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.black.withValues(alpha: 0.02)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _isHovered
                ? theme.colorScheme.primary.withValues(alpha: 0.2)
                : (isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.04)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                widget.action.icon,
                size: 14,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                widget.action.value,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: hasAction
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                  fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (!hasAction) {
      return Semantics(
        label: '${widget.action.label}: ${widget.action.value}',
        child: child,
      );
    }

    return Semantics(
      link: true,
      label: '${widget.action.label}: ${widget.action.value}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _open(context),
          borderRadius: BorderRadius.circular(10),
          child: child,
        ),
      ),
    );
  }
}
