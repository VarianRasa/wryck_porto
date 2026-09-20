import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../data/portfolio_content.dart' as content;
import '../models/portfolio_models.dart';
import '../services/firebase_portfolio_backend.dart';

class PortfolioController extends ChangeNotifier {
  PortfolioController({PortfolioBackend? backend})
    : _backend = backend ?? const DisabledPortfolioBackend(),
      _contactActions = List<ContactAction>.of(content.contactActions),
      _sections = List<PortfolioSection>.of(content.portfolioSections),
      _pageSettings = PortfolioPageSettings(
        currentlyExploring: content.currentlyExploring,
        featuredProjectSlugs: content.featuredProjectSlugs,
      ),
      _entries = List<PortfolioEntry>.of(content.portfolioEntries);

  final PortfolioBackend _backend;
  List<PortfolioEntry> _entries;
  List<ContactAction> _contactActions;
  List<PortfolioSection> _sections;
  PortfolioPageSettings _pageSettings;

  PortfolioLanguage language = PortfolioLanguage.id;
  ThemeMode themeMode = ThemeMode.light;
  String selectedFilterId = 'all';
  String query = '';
  PortfolioAuthUser? user;
  String? statusMessage;
  bool isBusy = false;

  bool get isFirebaseConfigured => _backend.isConfigured;

  bool get isSignedIn => user != null;

  bool get isLocalDraftMode => user?.isLocalDraft ?? false;

  List<PortfolioEntry> get entries => List.unmodifiable(_entries);

  List<ContactAction> get contactActions => List.unmodifiable(_contactActions);

  List<PortfolioSection> get sections => List.unmodifiable(_sections);

  PortfolioPageSettings get pageSettings => _pageSettings;

  Map<String, PortfolioSection> get sectionById => {
    for (final section in _sections) section.id: section,
  };

  Map<String, PortfolioEntry> get entryBySlug => {
    for (final entry in _entries) entry.slug: entry,
  };

  List<PortfolioEntry> get visibleProjects {
    final selectedFilter = content.projectFilters.firstWhere(
      (filter) => filter.id == selectedFilterId,
      orElse: () => content.projectFilters.first,
    );
    final allowedSlugs = selectedFilter.projectSlugs.toSet();
    final normalizedQuery = query.trim().toLowerCase();

    return _entries.where((entry) {
      if (entry.kind != PortfolioEntryKind.project) {
        return false;
      }
      if (selectedFilter.id != 'all' && !allowedSlugs.contains(entry.slug)) {
        return false;
      }
      if (normalizedQuery.isEmpty) {
        return true;
      }

      final searchable = [
        entry.title,
        entry.titleEn,
        entry.summary,
        entry.summaryEn,
        ...entry.tags,
        ...entry.categories,
      ].whereType<String>().join(' ').toLowerCase();

      return searchable.contains(normalizedQuery);
    }).toList();
  }

  List<PortfolioEntry> get visibleFeaturedProjects {
    final visibleSlugs = visibleProjects.map((entry) => entry.slug).toSet();
    return _pageSettings.featuredProjectSlugs
        .map((slug) => entryBySlug[slug])
        .whereType<PortfolioEntry>()
        .where((entry) => visibleSlugs.contains(entry.slug))
        .toList();
  }

  Future<void> initialize() async {
    user = await _backend.currentUser();
    await loadRemoteEntries();
  }

  Future<void> loadRemoteEntries() async {
    if (!_backend.isConfigured) {
      return;
    }

    await _runBusy(() async {
      final remoteEntries = await _backend.loadEntries();
      if (remoteEntries != null && remoteEntries.isNotEmpty) {
        _entries = _mergeEntries(remoteEntries);
        statusMessage = 'Konten dimuat dari Firestore.';
      }

      final remoteContacts = await _backend.loadContactActions();
      if (remoteContacts != null && remoteContacts.isNotEmpty) {
        _contactActions = _mergeContactActions(remoteContacts);
        statusMessage = 'Konten dimuat dari Firestore.';
      }

      final remoteSections = await _backend.loadSections();
      if (remoteSections != null && remoteSections.isNotEmpty) {
        _sections = _mergeSections(remoteSections);
        statusMessage = 'Konten dimuat dari Firestore.';
      }

      final remotePageSettings = await _backend.loadPageSettings();
      if (remotePageSettings != null) {
        _pageSettings = remotePageSettings;
        statusMessage = 'Konten dimuat dari Firestore.';
      }
    });
  }

  void setLanguage(PortfolioLanguage value) {
    language = value;
    notifyListeners();
  }

  void setThemeMode(ThemeMode value) {
    themeMode = value;
    notifyListeners();
  }

  void setQuery(String value) {
    query = value;
    notifyListeners();
  }

  void setFilter(String value) {
    selectedFilterId = value;
    notifyListeners();
  }

  Future<void> signIn({required String email, required String password}) async {
    await _runBusy(() async {
      user = await _backend.signInWithEmail(email: email, password: password);
      statusMessage = isLocalDraftMode
          ? 'Firebase belum dikonfigurasi. Edit berjalan sebagai local draft.'
          : 'Masuk sebagai ${user!.email}.';
      if (_backend.isConfigured) {
        final remoteEntries = await _backend.loadEntries();
        if (remoteEntries != null && remoteEntries.isNotEmpty) {
          _entries = _mergeEntries(remoteEntries);
        }
        final remoteContacts = await _backend.loadContactActions();
        if (remoteContacts != null && remoteContacts.isNotEmpty) {
          _contactActions = _mergeContactActions(remoteContacts);
        }
        final remoteSections = await _backend.loadSections();
        if (remoteSections != null && remoteSections.isNotEmpty) {
          _sections = _mergeSections(remoteSections);
        }
        final remotePageSettings = await _backend.loadPageSettings();
        if (remotePageSettings != null) {
          _pageSettings = remotePageSettings;
        }
      }
    });
  }

  Future<void> signOut() async {
    await _runBusy(() async {
      await _backend.signOut();
      user = null;
      statusMessage = 'Keluar dari edit panel.';
    });
  }

  Future<void> saveEntry(PortfolioEntry updatedEntry) async {
    final index = _entries.indexWhere(
      (entry) => entry.slug == updatedEntry.slug,
    );
    if (index == -1) {
      _entries = [..._entries, updatedEntry];
    } else {
      _entries = [
        ..._entries.take(index),
        updatedEntry,
        ..._entries.skip(index + 1),
      ];
    }
    notifyListeners();

    await _runBusy(() async {
      if (_backend.isConfigured) {
        await _backend.saveEntries(_entries);
        statusMessage = 'Perubahan disimpan ke Firestore.';
      } else {
        statusMessage = 'Perubahan tersimpan sebagai local draft sesi ini.';
      }
    });
  }

  Future<void> deleteEntry(String slug) async {
    final index = _entries.indexWhere((entry) => entry.slug == slug);
    if (index == -1) return;

    _entries = [..._entries.take(index), ..._entries.skip(index + 1)];
    notifyListeners();

    await _runBusy(() async {
      if (_backend.isConfigured) {
        await _backend.saveEntries(_entries);
        statusMessage = 'Konten dihapus dari Firestore.';
      } else {
        statusMessage = 'Konten dihapus dari local draft sesi ini.';
      }
    });
  }

  Future<void> saveContactActions(List<ContactAction> updatedActions) async {
    _contactActions = updatedActions;
    notifyListeners();

    await _runBusy(() async {
      if (_backend.isConfigured) {
        await _backend.saveContactActions(_contactActions);
        statusMessage = 'Kontak disimpan ke Firestore.';
      } else {
        statusMessage = 'Kontak tersimpan sebagai local draft sesi ini.';
      }
    });
  }

  Future<void> saveSection(PortfolioSection updatedSection) async {
    final index = _sections.indexWhere(
      (section) => section.id == updatedSection.id,
    );
    if (index == -1) {
      _sections = [..._sections, updatedSection];
    } else {
      _sections = [
        ..._sections.take(index),
        updatedSection,
        ..._sections.skip(index + 1),
      ];
    }
    notifyListeners();

    await _runBusy(() async {
      if (_backend.isConfigured) {
        await _backend.saveSections(_sections);
        statusMessage = 'Judul section disimpan ke Firestore.';
      } else {
        statusMessage = 'Judul section tersimpan sebagai local draft sesi ini.';
      }
    });
  }

  Future<void> savePageSettings(PortfolioPageSettings settings) async {
    _pageSettings = settings;
    notifyListeners();

    await _runBusy(() async {
      if (_backend.isConfigured) {
        await _backend.savePageSettings(_pageSettings);
        statusMessage = 'Pengaturan halaman porto disimpan ke Firestore.';
      } else {
        statusMessage =
            'Pengaturan halaman porto tersimpan sebagai local draft sesi ini.';
      }
    });
  }

  Future<String?> uploadEntryMedia({
    required String entrySlug,
    required String fileName,
    required Uint8List bytes,
    String? contentType,
  }) async {
    isBusy = true;
    statusMessage = null;
    notifyListeners();

    try {
      final url = await _backend.uploadEntryMedia(
        entrySlug: entrySlug,
        fileName: fileName,
        bytes: bytes,
        contentType: contentType,
      );
      statusMessage = 'Media berhasil diupload.';
      return url;
    } on PortfolioBackendException catch (error) {
      statusMessage = error.message;
      return null;
    } catch (error) {
      statusMessage = 'Terjadi kesalahan saat upload media: $error';
      return null;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  List<PortfolioEntry> _mergeEntries(List<PortfolioEntry> remoteEntries) {
    final remoteBySlug = {for (final entry in remoteEntries) entry.slug: entry};
    return _entries
        .map((entry) => remoteBySlug[entry.slug] ?? entry)
        .toList(growable: false);
  }

  List<ContactAction> _mergeContactActions(List<ContactAction> remoteActions) {
    final remoteByLabel = {
      for (final action in remoteActions) action.label: action,
    };
    return _contactActions
        .map((action) => remoteByLabel[action.label] ?? action)
        .toList(growable: false);
  }

  List<PortfolioSection> _mergeSections(List<PortfolioSection> remoteSections) {
    final remoteById = {
      for (final section in remoteSections) section.id: section,
    };
    return _sections
        .map((section) => remoteById[section.id] ?? section)
        .toList(growable: false);
  }

  Future<void> _runBusy(Future<void> Function() action) async {
    isBusy = true;
    statusMessage = null;
    notifyListeners();

    try {
      await action();
    } on PortfolioBackendException catch (error) {
      statusMessage = error.message;
    } catch (error) {
      statusMessage = 'Terjadi kesalahan: $error';
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }
}
