import 'package:flutter/material.dart';

import '../controllers/portfolio_controller.dart';
import '../models/portfolio_models.dart';
import '../widgets/document_shell.dart';
import '../widgets/entry_detail_view.dart';
import '../widgets/fade_in_widget.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    super.key,
    required this.slug,
    required this.controller,
    this.language = PortfolioLanguage.id,
  });

  final String slug;
  final PortfolioController controller;
  final PortfolioLanguage language;

  void _goBack(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final entry = controller.entryBySlug[slug];
    if (entry == null) {
      return _NotFoundDetail(slug: slug, onBack: () => _goBack(context));
    }
    return _EntryDetail(
      entry: entry,
      language: language,
      onBack: () => _goBack(context),
    );
  }
}

class _EntryDetail extends StatelessWidget {
  const _EntryDetail({
    required this.entry,
    required this.language,
    required this.onBack,
  });

  final PortfolioEntry entry;
  final PortfolioLanguage language;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DocumentShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          FadeInSlide(
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : Colors.black.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                tooltip: 'Kembali',
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back),
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          EntryDetailView(entry: entry, language: language),
        ],
      ),
    );
  }
}

class _NotFoundDetail extends StatelessWidget {
  const _NotFoundDetail({required this.slug, required this.onBack});
  final String slug;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DocumentShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            tooltip: 'Kembali',
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(height: 24),
          Text(
            'Konten tidak ditemukan',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tidak ada detail portofolio untuk "$slug".',
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
