import 'package:flutter/material.dart';

import '../models/portfolio_models.dart';

class PortfolioSectionView extends StatelessWidget {
  const PortfolioSectionView({
    super.key,
    required this.section,
    this.language = PortfolioLanguage.id,
    this.entriesOverride,
  });

  final PortfolioSection section;
  final PortfolioLanguage language;
  final List<PortfolioEntry>? entriesOverride;

  const PortfolioSectionView.withEntries({
    super.key,
    required this.section,
    required this.language,
    required this.entriesOverride,
  });

  @override
  Widget build(BuildContext context) {
    final entries = entriesOverride ?? const <PortfolioEntry>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionIntro(section: section, entries: entries, language: language),
        if (entries.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Belum ada isi pada bagian ini.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          for (final entry in entries)
            _EditorialEntry(
              entry: entry,
              language: language,
              onOpen: () {
                final prefix = entry.kind == PortfolioEntryKind.project
                    ? '/projects/'
                    : '/detail/';
                final langQuery = language == PortfolioLanguage.en
                    ? '?lang=en'
                    : '';
                Navigator.of(
                  context,
                ).pushNamed('$prefix${entry.slug}$langQuery');
              },
            ),
      ],
    );
  }
}

class _SectionIntro extends StatelessWidget {
  const _SectionIntro({
    required this.section,
    required this.entries,
    required this.language,
  });

  final PortfolioSection section;
  final List<PortfolioEntry> entries;
  final PortfolioLanguage language;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 64, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.titleFor(language).toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _sectionDescription(section.id),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (entries.isNotEmpty)
            Text(
              entries.length.toString().padLeft(2, '0'),
              style: theme.textTheme.displaySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.18),
                fontWeight: FontWeight.w700,
                fontSize: 34,
              ),
            ),
        ],
      ),
    );
  }

  String _sectionDescription(String id) {
    return switch (id) {
      'education' =>
        'Fondasi akademik dan area pembelajaran yang membentuk cara kerja.',
      'internship' =>
        'Pengalaman profesional dan kontribusi pada sistem nyata.',
      'projects' =>
        'Selected work across product design, applications, and data.',
      'volunteering' =>
        'Kolaborasi, koordinasi, dan pengalaman membangun bersama tim.',
      'skills' =>
        'Kemampuan inti, minat, dan sertifikasi yang mendukung proses.',
      'extra' => 'Tools dan bahasa yang digunakan untuk bekerja lebih efektif.',
      _ => 'A collection of work, experience, and things worth exploring.',
    };
  }
}

class _EditorialEntry extends StatefulWidget {
  const _EditorialEntry({
    required this.entry,
    required this.language,
    required this.onOpen,
  });

  final PortfolioEntry entry;
  final PortfolioLanguage language;
  final VoidCallback onOpen;

  @override
  State<_EditorialEntry> createState() => _EditorialEntryState();
}

class _EditorialEntryState extends State<_EditorialEntry> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = widget.entry.kind == PortfolioEntryKind.project
        ? theme.colorScheme.primary
        : theme.colorScheme.secondary;
    final summary = widget.entry.summaryFor(widget.language);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onOpen,
            borderRadius: BorderRadius.circular(4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
              decoration: BoxDecoration(
                color: _hovered
                    ? accent.withValues(alpha: 0.07)
                    : theme.colorScheme.surface.withValues(alpha: 0.45),
                border: Border.all(
                  color: _hovered
                      ? accent.withValues(alpha: 0.5)
                      : theme.dividerColor,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final narrow = constraints.maxWidth < 420;
                            final title = Text(
                              widget.entry.titleFor(widget.language),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: _hovered
                                    ? accent
                                    : theme.colorScheme.onSurface,
                              ),
                            );
                            final period = widget.entry.period == null
                                ? null
                                : Text(
                                    widget.entry.period!,
                                    textAlign: narrow
                                        ? TextAlign.left
                                        : TextAlign.right,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      letterSpacing: 0,
                                    ),
                                  );
                            if (narrow) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  title,
                                  if (period != null) ...[
                                    const SizedBox(height: 4),
                                    period,
                                  ],
                                ],
                              );
                            }
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: title),
                                ?period,
                              ],
                            );
                          },
                        ),
                        if (widget.entry.subtitleFor(widget.language) !=
                            null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.entry.subtitleFor(widget.language)!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: accent,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Text(
                          summary,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.entry.tags.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (final tag in widget.entry.tags.take(5))
                                Text(
                                  '#${tag.replaceAll(' ', '')}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontSize: 11,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Icon(
                    Icons.arrow_outward_rounded,
                    size: 19,
                    color: _hovered
                        ? accent
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
