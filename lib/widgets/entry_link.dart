import 'package:flutter/material.dart';

import '../models/portfolio_models.dart';
import 'motion.dart';

class EntryLink extends StatefulWidget {
  const EntryLink({
    super.key,
    required this.entry,
    this.compact = false,
    this.language = PortfolioLanguage.id,
  });

  final PortfolioEntry entry;
  final bool compact;
  final PortfolioLanguage language;

  const EntryLink.withLanguage({
    super.key,
    required this.entry,
    required this.language,
    this.compact = false,
  });

  @override
  State<EntryLink> createState() => _EntryLinkState();
}

class _EntryLinkState extends State<EntryLink> {
  bool _isHovered = false;

  Color _accentColor(BuildContext context) {
    final theme = Theme.of(context);
    return widget.entry.kind == PortfolioEntryKind.project
        ? theme.colorScheme.primary
        : theme.colorScheme.secondary;
  }

  void _open(BuildContext context) {
    final prefix = widget.entry.kind == PortfolioEntryKind.project
        ? '/projects/'
        : '/detail/';
    final langQuery = widget.language == PortfolioLanguage.en ? '?lang=en' : '';
    Navigator.of(context).pushNamed('$prefix${widget.entry.slug}$langQuery');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = _accentColor(context);
    final mutedStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      height: 1.45,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Semantics(
        link: true,
        button: true,
        label: 'Buka detail ${widget.entry.titleFor(widget.language)}',
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _open(context),
              borderRadius: BorderRadius.circular(4),
              child: AnimatedContainer(
                duration: motionDuration(
                  context,
                  const Duration(milliseconds: 190),
                ),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.fromLTRB(
                  widget.compact ? 14 : 20,
                  widget.compact ? 12 : 18,
                  widget.compact ? 14 : 20,
                  widget.compact ? 12 : 18,
                ),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? accent.withValues(alpha: 0.07)
                      : theme.colorScheme.surface.withValues(alpha: 0.52),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: _isHovered
                        ? accent.withValues(alpha: 0.52)
                        : theme.dividerColor,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 10,
                            runSpacing: 5,
                            children: [
                              Text(
                                widget.entry.titleFor(widget.language),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: _isHovered
                                      ? accent
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                              if (widget.entry.period != null)
                                Text(
                                  widget.entry.period!,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: accent,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                            ],
                          ),
                          if (widget.entry.subtitleFor(widget.language) !=
                                  null ||
                              widget.entry.location != null) ...[
                            const SizedBox(height: 5),
                            Text(
                              [
                                if (widget.entry.subtitleFor(widget.language) !=
                                    null)
                                  widget.entry.subtitleFor(widget.language)!,
                                if (widget.entry.location != null)
                                  widget.entry.location!,
                              ].join('  /  '),
                              style: mutedStyle?.copyWith(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                          if (!widget.compact) ...[
                            const SizedBox(height: 9),
                            Text(
                              widget.entry.summaryFor(widget.language),
                              style: mutedStyle,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          if (widget.entry.categories.isNotEmpty &&
                              !widget.compact) ...[
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                for (final category in widget.entry.categories)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: accent.withValues(alpha: 0.09),
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(
                                        color: accent.withValues(alpha: 0.22),
                                      ),
                                    ),
                                    child: Text(
                                      category,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: accent,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    AnimatedSlide(
                      duration: motionDuration(
                        context,
                        const Duration(milliseconds: 190),
                      ),
                      offset: reducedMotion(context) || !_isHovered
                          ? Offset.zero
                          : const Offset(0.18, 0),
                      child: Icon(
                        Icons.arrow_outward_rounded,
                        size: 19,
                        color: _isHovered
                            ? accent
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
