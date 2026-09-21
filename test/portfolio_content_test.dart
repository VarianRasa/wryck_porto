import 'package:flutter_test/flutter_test.dart';
import 'package:wryck_porto/data/portfolio_content.dart';
import 'package:wryck_porto/models/portfolio_models.dart';

void main() {
  test('all portfolio entry slugs are unique', () {
    final slugs = portfolioEntries.map((entry) => entry.slug).toList();

    expect(slugs.toSet(), hasLength(slugs.length));
  });

  test('all section references point to existing portfolio entries', () {
    final slugs = portfolioEntries.map((entry) => entry.slug).toSet();

    for (final section in portfolioSections) {
      for (final entrySlug in section.entrySlugs) {
        expect(
          slugs,
          contains(entrySlug),
          reason: '${section.id} references $entrySlug',
        );
      }
    }
  });

  test('all section ids are unique and have editable titles', () {
    final ids = portfolioSections.map((section) => section.id).toList();

    expect(ids.toSet(), hasLength(ids.length));
    for (final section in portfolioSections) {
      expect(section.title.trim(), isNotEmpty);
      expect(section.titleFor(PortfolioLanguage.en).trim(), isNotEmpty);
    }
  });

  test('featured projects and filters reference valid project entries', () {
    final projectSlugs = portfolioEntries
        .where((entry) => entry.kind == PortfolioEntryKind.project)
        .map((entry) => entry.slug)
        .toSet();

    for (final slug in featuredProjectSlugs) {
      expect(projectSlugs, contains(slug), reason: 'featured project $slug');
    }

    for (final filter in projectFilters) {
      for (final slug in filter.projectSlugs) {
        expect(projectSlugs, contains(slug), reason: '${filter.id} uses $slug');
      }
    }
  });

  test('content matches the current CV facts', () {
    final profile = portfolioEntryBySlug['profile']!;
    final education = portfolioEntryBySlug['upnvj-information-system']!;
    final interests = portfolioEntryBySlug['interests']!;
    final certification = portfolioEntryBySlug['certification']!;
    final tools = portfolioEntryBySlug['tools']!;

    expect(profile.summary, contains('lulusan'));
    expect(education.summary, contains('3.89/4.00'));
    expect(education.period, 'Jul 2022 - Sept 2026');
    expect(interests.bullets, contains('Data Analyst; Database Management.'));
    expect(certification.bullets, hasLength(5));
    expect(certification.summary, contains('Junior Web Programmer'));
    expect(tools.summary, contains('AI Agent'));
  });

  test('Smart Employee project includes the current CV contribution', () {
    final project = portfolioEntryBySlug['smart-employee-jsc-redesign']!;

    expect(
      project.bullets,
      contains('Membuat interface menggunakan Figma untuk mendukung redesign.'),
    );
  });

  test('updated entries survive JSON serialization', () {
    final original = portfolioEntryBySlug['certification']!;
    final restored = PortfolioEntry.fromJson(
      Map<String, dynamic>.from(original.toJson()),
    );

    expect(restored.title, original.title);
    expect(restored.bullets, original.bullets);
    expect(restored.detailParagraphs, original.detailParagraphs);
  });
}
