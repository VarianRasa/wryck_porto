import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/portfolio_models.dart';
import 'fade_in_widget.dart';
import 'section_heading.dart';

class EntryDetailView extends StatelessWidget {
  const EntryDetailView({
    super.key,
    required this.entry,
    required this.language,
  });

  final PortfolioEntry entry;
  final PortfolioLanguage language;

  String get _detailTitle {
    if (language == PortfolioLanguage.id) return entry.kind.detailTitle;
    return switch (entry.kind) {
      PortfolioEntryKind.profile => 'Profile Detail',
      PortfolioEntryKind.education => 'Education Detail',
      PortfolioEntryKind.internship => 'Internship Detail',
      PortfolioEntryKind.project => 'Project Detail',
      PortfolioEntryKind.volunteering => 'Volunteering Detail',
      PortfolioEntryKind.skill => 'Skill Detail',
      PortfolioEntryKind.certification => 'Certification Detail',
      PortfolioEntryKind.tools => 'Tools Detail',
      PortfolioEntryKind.language => 'Language Detail',
    };
  }

  Color _accentColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return switch (entry.kind) {
      PortfolioEntryKind.project =>
        isDark ? const Color(0xffa78bfa) : const Color(0xff5c3fd4),
      PortfolioEntryKind.education =>
        isDark ? const Color(0xff60a5fa) : const Color(0xff3b82f6),
      PortfolioEntryKind.internship =>
        isDark ? const Color(0xff34d399) : const Color(0xff0d9488),
      _ => isDark ? const Color(0xffa78bfa) : const Color(0xff5c3fd4),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = _accentColor(context);
    final mutedStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      height: 1.6,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category badge
        FadeInSlide(
          delay: const Duration(milliseconds: 100),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _detailTitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: accent,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                fontSize: 11,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Title
        FadeInSlide(
          delay: const Duration(milliseconds: 200),
          child: Text(
            entry.titleFor(language),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(height: 10),
        FadeInSlide(
          delay: const Duration(milliseconds: 300),
          child: _MetadataLine(entry: entry, language: language, accent: accent),
        ),
        const SizedBox(height: 24),
        // Summary
        FadeInSlide(
          delay: const Duration(milliseconds: 400),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.02)
                  : Colors.black.withValues(alpha: 0.015),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : Colors.black.withValues(alpha: 0.04),
              ),
            ),
            child: Text(entry.summaryFor(language),
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.7)),
          ),
        ),
        if (entry.previewAssetPath != null && entry.previewAssetPath!.isNotEmpty) ...[
          const SectionHeading(title: 'PROJECT PREVIEW'),
          FadeInSlide(
            delay: const Duration(milliseconds: 500),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                entry.previewAssetPath!,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  width: double.infinity,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: Text('Gambar tidak ditemukan:\n${entry.previewAssetPath}', textAlign: TextAlign.center),
                  ),
                ),
              ),
            ),
          ),
        ],
        if (entry.mediaItems.isNotEmpty) ...[
          SectionHeading(
            title: language == PortfolioLanguage.en
                ? 'MEDIA, DOCUMENTS AND LINKS'
                : 'MEDIA, DOKUMEN DAN LINK',
          ),
          _MediaGallery(
            items: entry.mediaItems,
            language: language,
            accent: accent,
          ),
        ],
        if (entry.detailParagraphsFor(language).isNotEmpty) ...[
          const SectionHeading(title: 'OVERVIEW'),
          for (final paragraph in entry.detailParagraphsFor(language))
            FadeInSlide(
              delay: const Duration(milliseconds: 500),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Text(paragraph,
                    textAlign: TextAlign.justify, style: mutedStyle),
              ),
            ),
        ],
        if (entry.bulletsFor(language).isNotEmpty) ...[
          SectionHeading(
            title: language == PortfolioLanguage.en
                ? 'CONTRIBUTIONS AND NOTES'
                : 'KONTRIBUSI DAN CATATAN',
          ),
          for (int i = 0; i < entry.bulletsFor(language).length; i++)
            FadeInSlide(
              delay: Duration(milliseconds: 500 + i * 80),
              child: _BulletItem(
                text: entry.bulletsFor(language)[i],
                accent: accent,
                style: mutedStyle,
              ),
            ),
        ],
        if (entry.outcomes.isNotEmpty) ...[
          SectionHeading(
            title: language == PortfolioLanguage.en
                ? 'OUTCOMES'
                : 'HASIL / OUTCOMES',
          ),
          for (int i = 0; i < entry.outcomes.length; i++)
            FadeInSlide(
              delay: Duration(milliseconds: 500 + i * 80),
              child: _BulletItem(
                text: entry.outcomes[i],
                accent: accent,
                style: mutedStyle,
                icon: Icons.check_circle_outline_rounded,
              ),
            ),
        ],
        if (entry.learnings.isNotEmpty) ...[
          SectionHeading(
            title: language == PortfolioLanguage.en
                ? 'LEARNINGS'
                : 'HAL YANG DIPELAJARI',
          ),
          for (int i = 0; i < entry.learnings.length; i++)
            FadeInSlide(
              delay: Duration(milliseconds: 500 + i * 80),
              child: _BulletItem(
                text: entry.learnings[i],
                accent: accent,
                style: mutedStyle,
                icon: Icons.lightbulb_outline_rounded,
              ),
            ),
        ],
        if (entry.tags.isNotEmpty) ...[
          SectionHeading(
            title: language == PortfolioLanguage.en
                ? 'RELATED SKILLS / TOOLS'
                : 'SKILL / TOOLS TERKAIT',
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tag in entry.tags)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accent.withValues(alpha: 0.12),
                        accent.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: accent.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Text(
                    tag,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _BulletItem extends StatelessWidget {
  const _BulletItem({
    required this.text,
    required this.accent,
    this.style,
    this.icon = Icons.arrow_right_rounded,
  });
  final String text;
  final Color accent;
  final TextStyle? style;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: style)),
        ],
      ),
    );
  }
}

class _MediaGallery extends StatelessWidget {
  const _MediaGallery({
    required this.items,
    required this.language,
    required this.accent,
  });

  final List<PortfolioMediaItem> items;
  final PortfolioLanguage language;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 640;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final item in items)
              SizedBox(
                width: isNarrow ? constraints.maxWidth : (constraints.maxWidth - 12) / 2,
                child: _MediaCard(
                  item: item,
                  language: language,
                  accent: accent,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _MediaCard extends StatefulWidget {
  const _MediaCard({
    required this.item,
    required this.language,
    required this.accent,
  });

  final PortfolioMediaItem item;
  final PortfolioLanguage language;
  final Color accent;

  @override
  State<_MediaCard> createState() => _MediaCardState();
}

class _MediaCardState extends State<_MediaCard> {
  bool _hovered = false;

  Future<void> _open() async {
    final uri = widget.item.uri;
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.platformDefault);
  }

  bool get _isImage => widget.item.kind == PortfolioMediaKind.image;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: _open,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: _hovered
                ? widget.accent.withValues(alpha: 0.08)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.black.withValues(alpha: 0.015)),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? widget.accent.withValues(alpha: 0.22)
                  : theme.dividerColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isImage) _MediaImagePreview(item: widget.item),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: widget.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _mediaKindIcon(widget.item.kind),
                        color: widget.accent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.kind.labelFor(widget.language),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: widget.accent,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (widget.item.description != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              widget.item.description!,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(
                      Icons.open_in_new_rounded,
                      color: _hovered
                          ? widget.accent
                          : theme.colorScheme.onSurfaceVariant,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MediaImagePreview extends StatelessWidget {
  const _MediaImagePreview({required this.item});

  final PortfolioMediaItem item;

  @override
  Widget build(BuildContext context) {
    final isNetwork = item.url.startsWith('http://') || item.url.startsWith('https://');
    final theme = Theme.of(context);
    final image = isNetwork
        ? Image.network(
            item.url,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) =>
                _BrokenMediaPreview(theme: theme),
          )
        : Image.asset(
            item.url,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) =>
                _BrokenMediaPreview(theme: theme),
          );

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: image,
      ),
    );
  }
}

class _BrokenMediaPreview extends StatelessWidget {
  const _BrokenMediaPreview({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.broken_image_outlined,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

IconData _mediaKindIcon(PortfolioMediaKind kind) {
  return switch (kind) {
    PortfolioMediaKind.image => Icons.image_outlined,
    PortfolioMediaKind.video => Icons.play_circle_outline_rounded,
    PortfolioMediaKind.document => Icons.description_outlined,
    PortfolioMediaKind.link => Icons.link_rounded,
  };
}

class _MetadataLine extends StatelessWidget {
  const _MetadataLine({
    required this.entry,
    required this.language,
    required this.accent,
  });
  final PortfolioEntry entry;
  final PortfolioLanguage language;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parts = [
      if (entry.subtitleFor(language) != null) entry.subtitleFor(language)!,
      if (entry.period != null) entry.period!,
      if (entry.location != null) entry.location!,
    ];
    if (parts.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        for (int i = 0; i < parts.length; i++) ...[
          if (i > 0)
            Text('·',
                style: TextStyle(
                    color: accent.withValues(alpha: 0.5),
                    fontWeight: FontWeight.bold)),
          Text(
            parts[i],
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}
