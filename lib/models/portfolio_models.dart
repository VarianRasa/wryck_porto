import 'package:flutter/widgets.dart';

enum PortfolioEntryKind {
  profile('Profil', 'Detail Profil'),
  education('Pendidikan', 'Detail Pendidikan'),
  internship('Internship', 'Detail Internship'),
  project('Proyek', 'Detail Proyek'),
  volunteering('Volunteering', 'Detail Volunteering'),
  skill('Skill', 'Detail Skill'),
  certification('Sertifikasi', 'Detail Sertifikasi'),
  tools('Tools', 'Detail Tools'),
  language('Bahasa', 'Detail Bahasa');

  const PortfolioEntryKind(this.label, this.detailTitle);

  final String label;
  final String detailTitle;

  static PortfolioEntryKind fromName(String? name) {
    return PortfolioEntryKind.values.firstWhere(
      (kind) => kind.name == name,
      orElse: () => PortfolioEntryKind.project,
    );
  }
}

enum PortfolioLanguage {
  id('ID'),
  en('EN');

  const PortfolioLanguage(this.label);

  final String label;
}

enum PortfolioMediaKind {
  image('Gambar', 'Image'),
  video('Video', 'Video'),
  document('Dokumen', 'Document'),
  link('Link', 'Link');

  const PortfolioMediaKind(this.labelId, this.labelEn);

  final String labelId;
  final String labelEn;

  String labelFor(PortfolioLanguage language) {
    return language == PortfolioLanguage.en ? labelEn : labelId;
  }

  static PortfolioMediaKind fromName(String? name) {
    return PortfolioMediaKind.values.firstWhere(
      (kind) => kind.name == name,
      orElse: () => PortfolioMediaKind.link,
    );
  }
}

class PortfolioMediaItem {
  const PortfolioMediaItem({
    required this.kind,
    required this.title,
    required this.url,
    this.description,
    this.fileName,
    this.contentType,
  });

  final PortfolioMediaKind kind;
  final String title;
  final String url;
  final String? description;
  final String? fileName;
  final String? contentType;

  Uri? get uri => Uri.tryParse(url);

  PortfolioMediaItem copyWith({
    PortfolioMediaKind? kind,
    String? title,
    String? url,
    String? description,
    String? fileName,
    String? contentType,
    bool replaceDescription = false,
    bool replaceFileName = false,
    bool replaceContentType = false,
  }) {
    return PortfolioMediaItem(
      kind: kind ?? this.kind,
      title: title ?? this.title,
      url: url ?? this.url,
      description:
          replaceDescription ? description : description ?? this.description,
      fileName: replaceFileName ? fileName : fileName ?? this.fileName,
      contentType:
          replaceContentType ? contentType : contentType ?? this.contentType,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'kind': kind.name,
      'title': title,
      'url': url,
      'description': description,
      'fileName': fileName,
      'contentType': contentType,
    };
  }

  static PortfolioMediaItem fromJson(Map<String, dynamic> json) {
    String readString(String key, String fallbackValue) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
      return fallbackValue;
    }

    String? readNullableString(String key) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
      return null;
    }

    final url = readString('url', '');
    return PortfolioMediaItem(
      kind: PortfolioMediaKind.fromName(readNullableString('kind')),
      title: readString('title', readNullableString('fileName') ?? url),
      url: url,
      description: readNullableString('description'),
      fileName: readNullableString('fileName'),
      contentType: readNullableString('contentType'),
    );
  }
}

class PortfolioEntry {
  const PortfolioEntry({
    required this.slug,
    required this.kind,
    required this.title,
    required this.summary,
    required this.detailParagraphs,
    this.titleEn,
    this.subtitleEn,
    this.summaryEn,
    this.bulletsEn = const [],
    this.detailParagraphsEn = const [],
    this.subtitle,
    this.period,
    this.location,
    this.bullets = const [],
    this.tags = const [],
    this.categories = const [],
    this.outcomes = const [],
    this.learnings = const [],
    this.mediaItems = const [],
    this.previewAssetPath,
  });

  final String slug;
  final PortfolioEntryKind kind;
  final String title;
  final String? titleEn;
  final String? subtitle;
  final String? subtitleEn;
  final String? period;
  final String? location;
  final String summary;
  final String? summaryEn;
  final List<String> bullets;
  final List<String> bulletsEn;
  final List<String> detailParagraphs;
  final List<String> detailParagraphsEn;
  final List<String> tags;
  final List<String> categories;
  final List<String> outcomes;
  final List<String> learnings;
  final List<PortfolioMediaItem> mediaItems;
  final String? previewAssetPath;

  String titleFor(PortfolioLanguage language) {
    return language == PortfolioLanguage.en ? titleEn ?? title : title;
  }

  String? subtitleFor(PortfolioLanguage language) {
    return language == PortfolioLanguage.en ? subtitleEn ?? subtitle : subtitle;
  }

  String summaryFor(PortfolioLanguage language) {
    return language == PortfolioLanguage.en ? summaryEn ?? summary : summary;
  }

  List<String> bulletsFor(PortfolioLanguage language) {
    return language == PortfolioLanguage.en && bulletsEn.isNotEmpty
        ? bulletsEn
        : bullets;
  }

  List<String> detailParagraphsFor(PortfolioLanguage language) {
    return language == PortfolioLanguage.en && detailParagraphsEn.isNotEmpty
        ? detailParagraphsEn
        : detailParagraphs;
  }

  PortfolioEntry copyWith({
    String? slug,
    PortfolioEntryKind? kind,
    String? title,
    String? titleEn,
    String? subtitle,
    String? subtitleEn,
    String? period,
    String? location,
    String? summary,
    String? summaryEn,
    List<String>? bullets,
    List<String>? bulletsEn,
    List<String>? detailParagraphs,
    List<String>? detailParagraphsEn,
    List<String>? tags,
    List<String>? categories,
    List<String>? outcomes,
    List<String>? learnings,
    List<PortfolioMediaItem>? mediaItems,
    String? previewAssetPath,
  }) {
    return PortfolioEntry(
      slug: slug ?? this.slug,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      titleEn: titleEn ?? this.titleEn,
      subtitle: subtitle ?? this.subtitle,
      subtitleEn: subtitleEn ?? this.subtitleEn,
      period: period ?? this.period,
      location: location ?? this.location,
      summary: summary ?? this.summary,
      summaryEn: summaryEn ?? this.summaryEn,
      bullets: bullets ?? this.bullets,
      bulletsEn: bulletsEn ?? this.bulletsEn,
      detailParagraphs: detailParagraphs ?? this.detailParagraphs,
      detailParagraphsEn: detailParagraphsEn ?? this.detailParagraphsEn,
      tags: tags ?? this.tags,
      categories: categories ?? this.categories,
      outcomes: outcomes ?? this.outcomes,
      learnings: learnings ?? this.learnings,
      mediaItems: mediaItems ?? this.mediaItems,
      previewAssetPath: previewAssetPath ?? this.previewAssetPath,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'slug': slug,
      'kind': kind.name,
      'title': title,
      'titleEn': titleEn,
      'subtitle': subtitle,
      'subtitleEn': subtitleEn,
      'period': period,
      'location': location,
      'summary': summary,
      'summaryEn': summaryEn,
      'bullets': bullets,
      'bulletsEn': bulletsEn,
      'detailParagraphs': detailParagraphs,
      'detailParagraphsEn': detailParagraphsEn,
      'tags': tags,
      'categories': categories,
      'outcomes': outcomes,
      'learnings': learnings,
      'mediaItems': mediaItems.map((item) => item.toJson()).toList(),
      'previewAssetPath': previewAssetPath,
    };
  }

  static PortfolioEntry fromJson(
    Map<String, dynamic> json, {
    PortfolioEntry? fallback,
  }) {
    List<String> readList(String key, List<String> fallbackValue) {
      final value = json[key];
      if (value is List) {
        return value.whereType<String>().toList();
      }
      return fallbackValue;
    }

    String? readNullableString(String key, String? fallbackValue) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
      return fallbackValue;
    }

    return PortfolioEntry(
      slug: readNullableString('slug', fallback?.slug) ?? '',
      kind: PortfolioEntryKind.fromName(
        readNullableString('kind', fallback?.kind.name),
      ),
      title: readNullableString('title', fallback?.title) ?? '',
      titleEn: readNullableString('titleEn', fallback?.titleEn),
      subtitle: readNullableString('subtitle', fallback?.subtitle),
      subtitleEn: readNullableString('subtitleEn', fallback?.subtitleEn),
      period: readNullableString('period', fallback?.period),
      location: readNullableString('location', fallback?.location),
      summary: readNullableString('summary', fallback?.summary) ?? '',
      summaryEn: readNullableString('summaryEn', fallback?.summaryEn),
      bullets: readList('bullets', fallback?.bullets ?? const []),
      bulletsEn: readList('bulletsEn', fallback?.bulletsEn ?? const []),
      detailParagraphs: readList(
        'detailParagraphs',
        fallback?.detailParagraphs ?? const [],
      ),
      detailParagraphsEn: readList(
        'detailParagraphsEn',
        fallback?.detailParagraphsEn ?? const [],
      ),
      tags: readList('tags', fallback?.tags ?? const []),
      categories: readList('categories', fallback?.categories ?? const []),
      outcomes: readList('outcomes', fallback?.outcomes ?? const []),
      learnings: readList('learnings', fallback?.learnings ?? const []),
      mediaItems: _readMediaItems(json, fallback?.mediaItems ?? const []),
      previewAssetPath: readNullableString(
        'previewAssetPath',
        fallback?.previewAssetPath,
      ),
    );
  }

  static List<PortfolioMediaItem> _readMediaItems(
    Map<String, dynamic> json,
    List<PortfolioMediaItem> fallbackValue,
  ) {
    final value = json['mediaItems'];
    if (value is! List) {
      return fallbackValue;
    }

    return value.whereType<Map>().map((rawItem) {
      return PortfolioMediaItem.fromJson(Map<String, dynamic>.from(rawItem));
    }).where((item) => item.url.trim().isNotEmpty).toList(growable: false);
  }
}

class PortfolioSection {
  const PortfolioSection({
    required this.id,
    required this.title,
    required this.entrySlugs,
    this.titleEn,
  });

  final String id;
  final String title;
  final String? titleEn;
  final List<String> entrySlugs;

  String titleFor(PortfolioLanguage language) {
    return language == PortfolioLanguage.en ? titleEn ?? title : title;
  }

  PortfolioSection copyWith({
    String? id,
    String? title,
    String? titleEn,
    List<String>? entrySlugs,
    bool replaceTitleEn = false,
  }) {
    return PortfolioSection(
      id: id ?? this.id,
      title: title ?? this.title,
      titleEn: replaceTitleEn ? titleEn : titleEn ?? this.titleEn,
      entrySlugs: entrySlugs ?? this.entrySlugs,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'titleEn': titleEn,
      'entrySlugs': entrySlugs,
    };
  }

  static PortfolioSection fromJson(
    Map<String, dynamic> json, {
    PortfolioSection? fallback,
  }) {
    List<String> readList(String key, List<String> fallbackValue) {
      final value = json[key];
      if (value is List) {
        return value.whereType<String>().toList();
      }
      return fallbackValue;
    }

    String? readNullableString(String key, String? fallbackValue) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
      return fallbackValue;
    }

    return PortfolioSection(
      id: readNullableString('id', fallback?.id) ?? '',
      title: readNullableString('title', fallback?.title) ?? '',
      titleEn: readNullableString('titleEn', fallback?.titleEn),
      entrySlugs: readList('entrySlugs', fallback?.entrySlugs ?? const []),
    );
  }
}

class ContactAction {
  const ContactAction({
    required this.label,
    required this.value,
    required this.icon,
    this.uri,
  });

  final String label;
  final String value;
  final IconData icon;
  final Uri? uri;

  ContactAction copyWith({
    String? label,
    String? value,
    IconData? icon,
    Uri? uri,
    bool replaceUri = false,
  }) {
    return ContactAction(
      label: label ?? this.label,
      value: value ?? this.value,
      icon: icon ?? this.icon,
      uri: replaceUri ? uri : uri ?? this.uri,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'label': label,
      'value': value,
      'uri': uri?.toString(),
    };
  }

  static ContactAction fromJson(
    Map<String, dynamic> json, {
    required ContactAction fallback,
  }) {
    String readString(String key, String fallbackValue) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
      return fallbackValue;
    }

    final uriValue = json['uri'];
    final parsedUri = uriValue is String && uriValue.trim().isNotEmpty
        ? Uri.tryParse(uriValue)
        : fallback.uri;

    return fallback.copyWith(
      label: readString('label', fallback.label),
      value: readString('value', fallback.value),
      uri: parsedUri,
    );
  }
}

class ProjectFilter {
  const ProjectFilter({
    required this.id,
    required this.label,
    required this.projectSlugs,
  });

  final String id;
  final String label;
  final List<String> projectSlugs;
}

class PortfolioPageSettings {
  const PortfolioPageSettings({
    required this.currentlyExploring,
    required this.featuredProjectSlugs,
  });

  final List<String> currentlyExploring;
  final List<String> featuredProjectSlugs;

  PortfolioPageSettings copyWith({
    List<String>? currentlyExploring,
    List<String>? featuredProjectSlugs,
  }) {
    return PortfolioPageSettings(
      currentlyExploring: currentlyExploring ?? this.currentlyExploring,
      featuredProjectSlugs: featuredProjectSlugs ?? this.featuredProjectSlugs,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'currentlyExploring': currentlyExploring,
      'featuredProjectSlugs': featuredProjectSlugs,
    };
  }

  static PortfolioPageSettings fromJson(
    Map<String, dynamic> json, {
    required PortfolioPageSettings fallback,
  }) {
    List<String> readList(String key, List<String> fallbackValue) {
      final value = json[key];
      if (value is List) {
        return value.whereType<String>().toList();
      }
      return fallbackValue;
    }

    return PortfolioPageSettings(
      currentlyExploring: readList(
        'currentlyExploring',
        fallback.currentlyExploring,
      ),
      featuredProjectSlugs: readList(
        'featuredProjectSlugs',
        fallback.featuredProjectSlugs,
      ),
    );
  }
}
