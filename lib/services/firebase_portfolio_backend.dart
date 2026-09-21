import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../data/portfolio_content.dart';
import '../models/portfolio_models.dart';

class PortfolioAuthUser {
  const PortfolioAuthUser({required this.email, required this.isLocalDraft});

  final String email;
  final bool isLocalDraft;
}

abstract class PortfolioBackend {
  bool get isConfigured;

  Future<PortfolioAuthUser?> currentUser();

  Future<PortfolioAuthUser> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<List<PortfolioEntry>?> loadEntries();

  Future<void> saveEntries(List<PortfolioEntry> entries);

  Future<List<ContactAction>?> loadContactActions();

  Future<void> saveContactActions(List<ContactAction> actions);

  Future<List<PortfolioSection>?> loadSections();

  Future<void> saveSections(List<PortfolioSection> sections);

  Future<PortfolioPageSettings?> loadPageSettings();

  Future<void> savePageSettings(PortfolioPageSettings settings);

  Future<String> uploadEntryMedia({
    required String entrySlug,
    required String fileName,
    required Uint8List bytes,
    String? contentType,
  });
}

class DisabledPortfolioBackend implements PortfolioBackend {
  const DisabledPortfolioBackend();

  @override
  bool get isConfigured => false;

  @override
  Future<PortfolioAuthUser?> currentUser() async => null;

  @override
  Future<PortfolioAuthUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw const PortfolioBackendException(
        'Email dan password wajib diisi.',
      );
    }

    return PortfolioAuthUser(email: email.trim(), isLocalDraft: true);
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<List<PortfolioEntry>?> loadEntries() async => null;

  @override
  Future<void> saveEntries(List<PortfolioEntry> entries) async {}

  @override
  Future<List<ContactAction>?> loadContactActions() async => null;

  @override
  Future<void> saveContactActions(List<ContactAction> actions) async {}

  @override
  Future<List<PortfolioSection>?> loadSections() async => null;

  @override
  Future<void> saveSections(List<PortfolioSection> sections) async {}

  @override
  Future<PortfolioPageSettings?> loadPageSettings() async => null;

  @override
  Future<void> savePageSettings(PortfolioPageSettings settings) async {}

  @override
  Future<String> uploadEntryMedia({
    required String entrySlug,
    required String fileName,
    required Uint8List bytes,
    String? contentType,
  }) async {
    throw const PortfolioBackendException(
      'Firebase Storage belum dikonfigurasi. Upload file hanya tersedia saat Firebase aktif.',
    );
  }
}

class FirebasePortfolioBackend implements PortfolioBackend {
  const FirebasePortfolioBackend({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  })  : _auth = auth,
        _firestore = firestore,
        _storage = storage;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  static Future<PortfolioBackend> create() async {
    final options = FirebaseRuntimeConfig.fromEnvironment();
    if (options == null) {
      return const DisabledPortfolioBackend();
    }

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: options);
      }
      return FirebasePortfolioBackend(
        auth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
        storage: FirebaseStorage.instance,
      );
    } catch (_) {
      return const DisabledPortfolioBackend();
    }
  }

  @override
  bool get isConfigured => true;

  DocumentReference<Map<String, dynamic>> get _contentDocument =>
      _firestore.collection('portfolio').doc('content');

  @override
  Future<PortfolioAuthUser?> currentUser() async {
    final user = _auth.currentUser;
    if (user?.email == null) {
      return null;
    }

    return PortfolioAuthUser(email: user!.email!, isLocalDraft: false);
  }

  @override
  Future<PortfolioAuthUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final userEmail = credential.user?.email ?? email.trim();
      return PortfolioAuthUser(email: userEmail, isLocalDraft: false);
    } on FirebaseAuthException catch (error) {
      throw PortfolioBackendException(error.message ?? error.code);
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<List<PortfolioEntry>?> loadEntries() async {
    final snapshot = await _contentDocument.get();
    final data = snapshot.data();
    final rawEntries = data?['entries'];
    if (rawEntries is! List) {
      return null;
    }

    return rawEntries.whereType<Map>().map((rawEntry) {
      final json = Map<String, dynamic>.from(rawEntry);
      final fallback = portfolioEntryBySlug[json['slug']];
      return PortfolioEntry.fromJson(json, fallback: fallback);
    }).toList();
  }

  @override
  Future<void> saveEntries(List<PortfolioEntry> entries) {
    return _contentDocument.set({
      'entries': entries.map((entry) => entry.toJson()).toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<List<ContactAction>?> loadContactActions() async {
    final snapshot = await _contentDocument.get();
    final data = snapshot.data();
    final rawContacts = data?['contacts'];
    if (rawContacts is! List) {
      return null;
    }

    final fallbackByLabel = {
      for (final action in contactActions) action.label: action,
    };

    return rawContacts.whereType<Map>().map((rawContact) {
      final json = Map<String, dynamic>.from(rawContact);
      final fallback = fallbackByLabel[json['label']];
      if (fallback == null) {
        return null;
      }
      return ContactAction.fromJson(json, fallback: fallback);
    }).whereType<ContactAction>().toList();
  }

  @override
  Future<void> saveContactActions(List<ContactAction> actions) {
    return _contentDocument.set({
      'contacts': actions.map((action) => action.toJson()).toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<List<PortfolioSection>?> loadSections() async {
    final snapshot = await _contentDocument.get();
    final data = snapshot.data();
    final rawSections = data?['sections'];
    if (rawSections is! List) {
      return null;
    }

    final fallbackById = {
      for (final section in portfolioSections) section.id: section,
    };

    return rawSections.whereType<Map>().map((rawSection) {
      final json = Map<String, dynamic>.from(rawSection);
      final fallback = fallbackById[json['id']];
      if (fallback == null) {
        return null;
      }
      return PortfolioSection.fromJson(json, fallback: fallback);
    }).whereType<PortfolioSection>().toList();
  }

  @override
  Future<void> saveSections(List<PortfolioSection> sections) {
    return _contentDocument.set({
      'sections': sections.map((section) => section.toJson()).toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<PortfolioPageSettings?> loadPageSettings() async {
    final snapshot = await _contentDocument.get();
    final data = snapshot.data();
    final rawSettings = data?['pageSettings'];
    if (rawSettings is! Map) {
      return null;
    }

    return PortfolioPageSettings.fromJson(
      Map<String, dynamic>.from(rawSettings),
      fallback: PortfolioPageSettings(
        currentlyExploring: currentlyExploring,
        featuredProjectSlugs: featuredProjectSlugs,
      ),
    );
  }

  @override
  Future<void> savePageSettings(PortfolioPageSettings settings) {
    return _contentDocument.set({
      'pageSettings': settings.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<String> uploadEntryMedia({
    required String entrySlug,
    required String fileName,
    required Uint8List bytes,
    String? contentType,
  }) async {
    final safeSlug = _safePathSegment(entrySlug);
    final safeFileName = _safePathSegment(fileName);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ref = _storage.ref('portfolio-media/$safeSlug/$timestamp-$safeFileName');
    final metadata = SettableMetadata(contentType: contentType);

    await ref.putData(bytes, metadata);
    return ref.getDownloadURL();
  }

  String _safePathSegment(String value) {
    final normalized = value
        .trim()
        .replaceAll(RegExp(r'[^a-zA-Z0-9._-]+'), '-')
        .replaceAll(RegExp(r'-+'), '-');
    return normalized.isEmpty ? 'file' : normalized;
  }
}

class FirebaseRuntimeConfig {
  const FirebaseRuntimeConfig._();

  static FirebaseOptions? fromEnvironment() {
    const apiKey = String.fromEnvironment(
      'FIREBASE_API_KEY',
      defaultValue: 'AIzaSyAvV3d3FvTb9CWcLJOOSKblCRUkuWuJvMk',
    );
    const appId = String.fromEnvironment(
      'FIREBASE_APP_ID',
      defaultValue: '1:915202842096:web:774291ba698b8cd39b1135',
    );
    const messagingSenderId = String.fromEnvironment(
      'FIREBASE_MESSAGING_SENDER_ID',
      defaultValue: '915202842096',
    );
    const projectId = String.fromEnvironment(
      'FIREBASE_PROJECT_ID',
      defaultValue: 'wryck-porto',
    );
    const authDomain = String.fromEnvironment(
      'FIREBASE_AUTH_DOMAIN',
      defaultValue: 'wryck-porto.firebaseapp.com',
    );
    const storageBucket = String.fromEnvironment(
      'FIREBASE_STORAGE_BUCKET',
      defaultValue: 'wryck-porto.firebasestorage.app',
    );

    final requiredValues = [apiKey, appId, messagingSenderId, projectId];
    if (requiredValues.any((value) => value.trim().isEmpty)) {
      return null;
    }

    return const FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      authDomain: authDomain,
      storageBucket: storageBucket,
    );
  }
}

class PortfolioBackendException implements Exception {
  const PortfolioBackendException(this.message);

  final String message;

  @override
  String toString() => message;
}
