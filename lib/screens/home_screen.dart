import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/portfolio_controller.dart';
import '../data/portfolio_content.dart';
import '../models/portfolio_models.dart';
import '../widgets/contact_form_dialog.dart';
import '../widgets/document_shell.dart';
import '../widgets/entry_link.dart';
import '../widgets/fade_in_widget.dart';
import '../widgets/glass_container.dart';
import '../widgets/portfolio_section_view.dart';
import '../widgets/section_heading.dart';
import '../widgets/motion.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.controller});
  final PortfolioController controller;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _profileKey = GlobalKey();
  final _featuredKey = GlobalKey();
  final _sectionKeys = <String, GlobalKey>{};
  bool _isControlPanelCollapsed = false;

  PortfolioController get _controller => widget.controller;
  PortfolioLanguage get _language => _controller.language;
  PortfolioEntry get _profileEntry =>
      _controller.entryBySlug['profile'] ?? portfolioEntryBySlug['profile']!;

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleControllerChanged);
  }

  void _handleControllerChanged() {
    if (mounted) setState(() {});
  }

  void _scrollTo(GlobalKey key) {
    final targetContext = key.currentContext;
    if (targetContext == null) return;
    Scrollable.ensureVisible(
      targetContext,
      duration: reducedMotion(context)
          ? Duration.zero
          : const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  GlobalKey _sectionKey(String id) {
    return _sectionKeys.putIfAbsent(id, () => GlobalKey());
  }

  Future<void> _copyEmail() async {
    final email =
        _contactAction('Email')?.value ?? 'm.varianwarrick04@gmail.com';
    await Clipboard.setData(ClipboardData(text: email));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Email disalin ke clipboard.'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _openCv() async {
    await _launch(
      _contactAction('CV')?.uri ??
          Uri.base.resolve('cv_muhammad_varian_warrick.pdf'),
    );
  }

  Future<void> _openLinkedIn() async {
    await _launch(
      _contactAction('LinkedIn')?.uri ??
          Uri.parse(
            'https://www.linkedin.com/in/muhammad-varian-warrick-4887431b7/',
          ),
    );
  }

  Future<void> _contactMe() async {
    await ContactFormDialog.show(context);
  }

  ContactAction? _contactAction(String label) {
    for (final action in _controller.contactActions) {
      if (action.label == label) return action;
    }
    return null;
  }

  Future<void> _launch(Uri uri) =>
      launchUrl(uri, mode: LaunchMode.platformDefault);

  String _sectionTitle(PortfolioSection section) {
    return section.titleFor(_language);
  }

  String get _summary => _profileEntry.summaryFor(_language);
  String get _headline =>
      _profileEntry.subtitleFor(_language) ??
      (_language == PortfolioLanguage.en
          ? profileHeadlineEn
          : profileHeadlineId);

  List<PortfolioEntry> _entriesForSection(PortfolioSection section) {
    final kinds = switch (section.id) {
      'education' => [PortfolioEntryKind.education],
      'internship' => [PortfolioEntryKind.internship],
      'volunteering' => [PortfolioEntryKind.volunteering],
      'skills' => [PortfolioEntryKind.skill, PortfolioEntryKind.certification],
      'extra' => [PortfolioEntryKind.tools, PortfolioEntryKind.language],
      _ => <PortfolioEntryKind>[],
    };

    final predefinedSlugs = section.entrySlugs.toSet();
    final predefinedEntries = section.entrySlugs
        .map((slug) => _controller.entryBySlug[slug])
        .whereType<PortfolioEntry>()
        .toList();

    final newEntries = _controller.entries.where((entry) {
      return kinds.contains(entry.kind) &&
          !predefinedSlugs.contains(entry.slug);
    }).toList();

    return [...predefinedEntries, ...newEntries];
  }

  @override
  Widget build(BuildContext context) {
    final projectSection = _controller.sections.firstWhere(
      (s) => s.id == 'projects',
    );

    return DocumentShell(
      sideNavigation: _isControlPanelCollapsed
          ? null
          : _ControlPanel(
              controller: _controller,
              searchController: _searchController,
              onProfile: () => _scrollTo(_profileKey),
              onFeatured: () => _scrollTo(_featuredKey),
              onSectionSelected: (id) => _scrollTo(_sectionKey(id)),
              onCopyEmail: _copyEmail,
              onOpenCv: _openCv,
              onOpenLinkedIn: _openLinkedIn,
              onContactMe: _contactMe,
              onCollapse: () {
                setState(() => _isControlPanelCollapsed = true);
              },
            ),
      floatingSideNavigation: _isControlPanelCollapsed
          ? _CollapsedPanelButton(
              onPressed: () {
                setState(() => _isControlPanelCollapsed = false);
              },
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KeyedSubtree(key: _profileKey, child: const SizedBox.shrink()),
          FadeInSlide(
            delay: const Duration(milliseconds: 60),
            child: _HeroSection(
              title: _profileEntry.titleFor(_language),
              headline: _headline,
              summary: _summary,
              language: _language,
              contactActions: _controller.contactActions,
              projectCount: _controller.entries
                  .where((entry) => entry.kind == PortfolioEntryKind.project)
                  .length,
              sectionCount: _controller.sections.length,
              onViewProfile: () => Navigator.of(context).pushNamed(
                '/detail/profile${_language == PortfolioLanguage.en ? '?lang=en' : ''}',
              ),
              onViewProjects: () => _scrollTo(_featuredKey),
            ),
          ),
          const SizedBox(height: 14),
          FadeInSlide(
            delay: const Duration(milliseconds: 260),
            child: _CurrentlyExploring(
              items: _controller.pageSettings.currentlyExploring,
            ),
          ),
          KeyedSubtree(key: _featuredKey, child: const SizedBox.shrink()),
          _FeaturedProjects(
            entries: _controller.visibleFeaturedProjects,
            language: _language,
          ),
          for (final section in _controller.sections)
            KeyedSubtree(
              key: _sectionKey(section.id),
              child: section.id == 'projects'
                  ? PortfolioSectionView.withEntries(
                      section: PortfolioSection(
                        id: projectSection.id,
                        title: _sectionTitle(projectSection),
                        titleEn: projectSection.titleEn,
                        entrySlugs: projectSection.entrySlugs,
                      ),
                      language: _language,
                      entriesOverride: _controller.visibleProjects,
                    )
                  : PortfolioSectionView.withEntries(
                      section: PortfolioSection(
                        id: section.id,
                        title: _sectionTitle(section),
                        titleEn: section.titleEn,
                        entrySlugs: section.entrySlugs,
                      ),
                      language: _language,
                      entriesOverride: _entriesForSection(section),
                    ),
            ),
        ],
      ),
    );
  }
}

// --- Private Widgets ---

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.title,
    required this.headline,
    required this.summary,
    required this.language,
    required this.contactActions,
    required this.projectCount,
    required this.sectionCount,
    required this.onViewProfile,
    required this.onViewProjects,
  });

  final String title;
  final String headline;
  final String summary;
  final PortfolioLanguage language;
  final List<ContactAction> contactActions;
  final int projectCount;
  final int sectionCount;
  final VoidCallback onViewProfile;
  final VoidCallback onViewProjects;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 720;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'MW / PORTFOLIO 2026',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    letterSpacing: 1.7,
                  ),
                ),
                const Spacer(),
                _AvailabilityMark(language: language),
              ],
            ),
            const SizedBox(height: 52),
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: _buildCopy(context, true)),
                  const SizedBox(width: 38),
                  SizedBox(width: 188, child: _buildPortraitColumn(context)),
                ],
              )
            else ...[
              _buildPortraitColumn(context),
              const SizedBox(height: 28),
              _buildCopy(context, false),
            ],
            const SizedBox(height: 42),
            Divider(color: theme.dividerColor),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'SCROLL TO EXPLORE',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.3,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_downward_rounded,
                  size: 17,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildCopy(BuildContext context, bool isWide) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headline,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: theme.textTheme.displayMedium?.copyWith(
            fontSize: isWide ? 68 : 48,
            height: 0.97,
          ),
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 570),
          child: Text(
            summary,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.7,
            ),
          ),
        ),
        const SizedBox(height: 26),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: onViewProfile,
              icon: const Icon(Icons.arrow_outward_rounded, size: 17),
              label: Text(
                language == PortfolioLanguage.en
                    ? 'View profile'
                    : 'Lihat profil',
              ),
            ),
            OutlinedButton.icon(
              onPressed: onViewProjects,
              icon: const Icon(Icons.grid_view_rounded, size: 17),
              label: const Text('Explore work'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _HeroContactLine(actions: contactActions),
        const SizedBox(height: 28),
        _HeroMetrics(projectCount: projectCount, sectionCount: sectionCount),
      ],
    );
  }

  Widget _buildPortraitColumn(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [const _HeroPortrait()],
    );
  }
}

class _AvailabilityMark extends StatelessWidget {
  const _AvailabilityMark({required this.language});

  final PortfolioLanguage language;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          language == PortfolioLanguage.en
              ? 'OPEN TO WORK'
              : 'TERBUKA UNTUK KERJA',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}

class _HeroContactLine extends StatelessWidget {
  const _HeroContactLine({required this.actions});

  final List<ContactAction> actions;

  @override
  Widget build(BuildContext context) {
    final visibleActions = actions
        .where(
          (action) => action.label == 'Email' || action.label == 'LinkedIn',
        )
        .toList();
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        for (final action in visibleActions)
          Text(
            action.value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              decoration: TextDecoration.underline,
              decorationColor: Theme.of(context).colorScheme.primary,
            ),
          ),
      ],
    );
  }
}

class _HeroMetrics extends StatelessWidget {
  const _HeroMetrics({required this.projectCount, required this.sectionCount});

  final int projectCount;
  final int sectionCount;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 30,
      runSpacing: 12,
      children: [
        _HeroMetric(value: '$projectCount+', label: 'Projects'),
        _HeroMetric(value: '$sectionCount', label: 'CV sections'),
        _HeroMetric(value: 'ID / EN', label: 'Languages'),
      ],
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _HeroPortrait extends StatelessWidget {
  const _HeroPortrait();

  static const _assetPath = 'assets/images/profile_portrait.png';
  static const _semanticLabel = 'Foto profil Muhammad Varian Warrick';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 220.0;
        final portraitWidth = availableWidth >= 280
            ? 220.0
            : (availableWidth * 0.62).clamp(150.0, 210.0);

        return Center(
          child: Semantics(
            key: const ValueKey('profile-portrait'),
            container: true,
            image: true,
            label: _semanticLabel,
            child: SizedBox(
              width: portraitWidth,
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(
                        alpha: isDark ? 0.28 : 0.18,
                      ),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(
                          alpha: isDark ? 0.16 : 0.10,
                        ),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Image.asset(
                      _assetPath,
                      excludeFromSemantics: true,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.person_outline_rounded,
                            size: 52,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle({required this.language, required this.onChanged});
  final PortfolioLanguage language;
  final ValueChanged<PortfolioLanguage> onChanged;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SegmentedButton<PortfolioLanguage>(
        segments: const [
          ButtonSegment(value: PortfolioLanguage.id, label: Text('ID')),
          ButtonSegment(value: PortfolioLanguage.en, label: Text('EN')),
        ],
        selected: {language},
        onSelectionChanged: (s) => onChanged(s.first),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onCopyEmail,
    required this.onOpenCv,
    required this.onOpenLinkedIn,
    required this.onContactMe,
  });
  final VoidCallback onCopyEmail;
  final VoidCallback onOpenCv;
  final VoidCallback onOpenLinkedIn;
  final VoidCallback onContactMe;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        _ActionButton(
          icon: Icons.copy_rounded,
          label: 'Copy Email',
          onPressed: onCopyEmail,
        ),
        _ActionButton(
          icon: Icons.work_outline_rounded,
          label: 'LinkedIn',
          onPressed: onOpenLinkedIn,
        ),
        _ActionButton(
          icon: Icons.mail_outline_rounded,
          label: 'Contact',
          onPressed: onContactMe,
          filled: true,
        ),
        _ActionButton(
          icon: Icons.picture_as_pdf_outlined,
          label: 'CV / PDF',
          onPressed: onOpenCv,
          tonal: true,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.filled = false,
    this.tonal = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool filled;
  final bool tonal;

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label),
      );
    }
    if (tonal) {
      return FilledButton.tonalIcon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label),
      );
    }
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle({required this.themeMode, required this.onChanged});
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onChanged;
  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      segments: const [
        ButtonSegment(
          value: ThemeMode.light,
          icon: Icon(Icons.light_mode_rounded, size: 16),
          label: Text('Light'),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          icon: Icon(Icons.dark_mode_rounded, size: 16),
          label: Text('Dark'),
        ),
      ],
      selected: {themeMode},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}

class _ControlPanel extends StatelessWidget {
  const _ControlPanel({
    required this.controller,
    required this.searchController,
    required this.onProfile,
    required this.onFeatured,
    required this.onSectionSelected,
    required this.onCopyEmail,
    required this.onOpenCv,
    required this.onOpenLinkedIn,
    required this.onContactMe,
    required this.onCollapse,
  });
  final PortfolioController controller;
  final TextEditingController searchController;
  final VoidCallback onProfile, onFeatured;
  final ValueChanged<String> onSectionSelected;
  final VoidCallback onCopyEmail, onOpenCv, onOpenLinkedIn, onContactMe;
  final VoidCallback onCollapse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompact = MediaQuery.sizeOf(context).width <= 1180;
    return GlassContainer(
      neonGlow: !isCompact,
      padding: EdgeInsets.all(isCompact ? 12 : 14),
      borderRadius: isCompact ? 16 : 22,
      child: isCompact
          ? _buildCompactPanel(context, theme)
          : _buildDesktopPanel(context, theme),
    );
  }

  Widget _buildCompactPanel(BuildContext context, ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PanelHeader(onCollapse: onCollapse),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _LanguageToggle(
                language: controller.language,
                onChanged: controller.setLanguage,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ThemeToggle(
                themeMode: controller.themeMode,
                onChanged: controller.setThemeMode,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _ProjectControls(
          controller: searchController,
          selectedFilterId: controller.selectedFilterId,
          onSearchChanged: controller.setQuery,
          onFilterChanged: controller.setFilter,
        ),
        const SizedBox(height: 10),
        _QuickActions(
          onCopyEmail: onCopyEmail,
          onOpenCv: onOpenCv,
          onOpenLinkedIn: onOpenLinkedIn,
          onContactMe: onContactMe,
        ),
        const SizedBox(height: 8),
        FilledButton.tonalIcon(
          onPressed: () => Navigator.of(context).pushNamed('/admin'),
          icon: const Icon(Icons.edit_note_rounded, size: 18),
          label: const Text('Edit Panel'),
        ),
      ],
    );
  }

  Widget _buildDesktopPanel(BuildContext context, ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PanelHeader(onCollapse: onCollapse),
        const SizedBox(height: 14),
        _PanelTitle('Daftar Isi'),
        _NavTextButton(label: 'Profil', onPressed: onProfile),
        _NavTextButton(label: 'Featured', onPressed: onFeatured),
        for (final section in controller.sections)
          _NavTextButton(
            label: section.titleFor(controller.language),
            onPressed: () => onSectionSelected(section.id),
          ),
        const SizedBox(height: 16),
        _PanelTitle('Translate'),
        _LanguageToggle(
          language: controller.language,
          onChanged: controller.setLanguage,
        ),
        const SizedBox(height: 16),
        _PanelTitle('Theme'),
        _ThemeToggle(
          themeMode: controller.themeMode,
          onChanged: controller.setThemeMode,
        ),
        const SizedBox(height: 16),
        _PanelTitle('Search & Filter'),
        _ProjectControls(
          controller: searchController,
          selectedFilterId: controller.selectedFilterId,
          onSearchChanged: controller.setQuery,
          onFilterChanged: controller.setFilter,
        ),
        const SizedBox(height: 16),
        _PanelTitle('Actions'),
        _QuickActions(
          onCopyEmail: onCopyEmail,
          onOpenCv: onOpenCv,
          onOpenLinkedIn: onOpenLinkedIn,
          onContactMe: onContactMe,
        ),
        const SizedBox(height: 10),
        FilledButton.tonalIcon(
          onPressed: () => Navigator.of(context).pushNamed('/admin'),
          icon: const Icon(Icons.edit_note_rounded, size: 18),
          label: const Text('Edit Panel'),
        ),
        if (controller.statusMessage != null) ...[
          const SizedBox(height: 10),
          Text(
            controller.statusMessage!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ],
    );
  }
}

class _CollapsedPanelButton extends StatelessWidget {
  const _CollapsedPanelButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'portfolio-side-panel-toggle',
      tooltip: 'Buka panel samping',
      onPressed: onPressed,
      shape: const CircleBorder(),
      child: const Icon(Icons.tune_rounded),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.onCollapse});

  final VoidCallback onCollapse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.space_dashboard_outlined,
            color: theme.colorScheme.primary,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Navigasi',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              Text(
                'Daftar isi & tools',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          tooltip: 'Minimize panel',
          onPressed: onCollapse,
          icon: const Icon(Icons.keyboard_double_arrow_right_rounded, size: 18),
        ),
      ],
    );
  }
}

class _PanelTitle extends StatelessWidget {
  const _PanelTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cleanTitle = _cleanPanelText(title);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            _panelTitleIcon(cleanTitle),
            size: 15,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 7),
          Text(
            cleanTitle,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTextButton extends StatefulWidget {
  const _NavTextButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  State<_NavTextButton> createState() => _NavTextButtonState();
}

class _NavTextButtonState extends State<_NavTextButton> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cleanLabel = _formatPanelLabel(_cleanPanelText(widget.label));
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: _hovered
                    ? theme.colorScheme.primary.withValues(alpha: 0.08)
                    : theme.colorScheme.surface.withValues(alpha: 0.34),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _hovered
                      ? theme.colorScheme.primary.withValues(alpha: 0.18)
                      : theme.dividerColor.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _hovered
                          ? theme.colorScheme.primary.withValues(alpha: 0.14)
                          : theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _navIcon(cleanLabel),
                      size: 16,
                      color: _hovered
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      cleanLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _hovered
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                        height: 1.2,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _hovered ? 1 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
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

String _cleanPanelText(String value) {
  final withoutBrokenEmoji = value.replaceAll(RegExp(r'[^\x20-\x7E]+'), ' ');
  return withoutBrokenEmoji
      .replaceAll(RegExp(r'^[\s\-]+'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

IconData _panelTitleIcon(String title) {
  final lower = title.toLowerCase();
  if (lower.contains('translate')) return Icons.language_rounded;
  if (lower.contains('theme')) return Icons.palette_outlined;
  if (lower.contains('search')) return Icons.manage_search_rounded;
  if (lower.contains('action')) return Icons.bolt_rounded;
  return Icons.menu_book_rounded;
}

IconData _navIcon(String label) {
  final lower = label.toLowerCase();
  if (lower.contains('profil')) return Icons.person_outline_rounded;
  if (lower.contains('featured')) return Icons.star_outline_rounded;
  if (lower.contains('pendidikan') || lower.contains('education')) {
    return Icons.school_outlined;
  }
  if (lower.contains('internship')) return Icons.business_center_outlined;
  if (lower.contains('project')) return Icons.folder_copy_outlined;
  if (lower.contains('volunteering')) return Icons.diversity_3_outlined;
  if (lower.contains('skill')) return Icons.psychology_alt_outlined;
  if (lower.contains('qualification') || lower.contains('extra')) {
    return Icons.workspace_premium_outlined;
  }
  return Icons.article_outlined;
}

String _formatPanelLabel(String value) {
  final normalized = value.trim().replaceAll(RegExp(r'\s+'), ' ');
  if (normalized.isEmpty) return value;

  final isAllCaps = normalized == normalized.toUpperCase();
  if (!isAllCaps) return normalized;

  return normalized
      .toLowerCase()
      .split(' ')
      .map((word) {
        if (word.isEmpty) return word;
        final parts = word.split('/');
        if (parts.length > 1) {
          return parts.map((part) => part.toUpperCase()).join('/');
        }
        return '${word[0].toUpperCase()}${word.substring(1)}';
      })
      .join(' ');
}

class _CurrentlyExploring extends StatelessWidget {
  const _CurrentlyExploring({required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading(title: 'Currently Exploring'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final item in items)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            const Color(0xffa78bfa).withValues(alpha: 0.15),
                            const Color(0xff60a5fa).withValues(alpha: 0.1),
                          ]
                        : [
                            const Color(0xff5c3fd4).withValues(alpha: 0.08),
                            const Color(0xff3b82f6).withValues(alpha: 0.05),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xffa78bfa).withValues(alpha: 0.2)
                        : const Color(0xff5c3fd4).withValues(alpha: 0.12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _FeaturedProjects extends StatelessWidget {
  const _FeaturedProjects({required this.entries, required this.language});
  final List<PortfolioEntry> entries;
  final PortfolioLanguage language;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 58, bottom: 20),
          child: Row(
            children: [
              Text(
                'Featured Projects',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  letterSpacing: 1.8,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: Divider(color: theme.dividerColor)),
            ],
          ),
        ),
        if (entries.isEmpty)
          Text(
            'Tidak ada proyek yang cocok dengan pencarian atau filter.',
            style: Theme.of(context).textTheme.bodyMedium,
          )
        else
          for (var index = 0; index < entries.length; index++)
            _FeaturedProjectRow(
              index: index + 1,
              entry: entries[index],
              language: language,
            ),
      ],
    );
  }
}

class _FeaturedProjectRow extends StatelessWidget {
  const _FeaturedProjectRow({
    required this.index,
    required this.entry,
    required this.language,
  });

  final int index;
  final PortfolioEntry entry;
  final PortfolioLanguage language;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 34,
            child: Text(
              index.toString().padLeft(2, '0'),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: EntryLink.withLanguage(entry: entry, language: language),
          ),
        ],
      ),
    );
  }
}

class _ProjectControls extends StatelessWidget {
  const _ProjectControls({
    required this.controller,
    required this.selectedFilterId,
    required this.onSearchChanged,
    required this.onFilterChanged,
  });
  final TextEditingController controller;
  final String selectedFilterId;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            onChanged: onSearchChanged,
            decoration: const InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search_rounded),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final filter in projectFilters)
                ChoiceChip(
                  label: Text(filter.label),
                  selected: selectedFilterId == filter.id,
                  onSelected: (_) => onFilterChanged(filter.id),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
