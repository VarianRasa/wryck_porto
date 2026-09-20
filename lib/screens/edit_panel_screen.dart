import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../controllers/portfolio_controller.dart';
import '../models/portfolio_models.dart';
import '../widgets/document_shell.dart';
import '../widgets/entry_detail_view.dart';
import '../widgets/glass_container.dart';
import '../widgets/section_heading.dart';

enum _EditPanelMode { page, entries, contact, messages }

class EditPanelScreen extends StatefulWidget {
  const EditPanelScreen({super.key, required this.controller});

  final PortfolioController controller;

  @override
  State<EditPanelScreen> createState() => _EditPanelScreenState();
}

class _EditPanelScreenState extends State<EditPanelScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _titleController = TextEditingController();
  final _titleEnController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _subtitleEnController = TextEditingController();
  final _periodController = TextEditingController();
  final _locationController = TextEditingController();
  final _summaryController = TextEditingController();
  final _summaryEnController = TextEditingController();
  final _previewAssetPathController = TextEditingController();

  final _bulletsController = TextEditingController();
  final _bulletsEnController = TextEditingController();
  final _detailsController = TextEditingController();
  final _detailsEnController = TextEditingController();

  final _tagsController = TextEditingController();
  final _categoriesController = TextEditingController();
  final _outcomesController = TextEditingController();
  final _learningsController = TextEditingController();

  final _contactLocationController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _contactLinkedInController = TextEditingController();
  final _contactCvUriController = TextEditingController();
  final _sectionTitleController = TextEditingController();
  final _sectionTitleEnController = TextEditingController();
  final _profileTitleController = TextEditingController();
  final _profileTitleEnController = TextEditingController();
  final _profileSubtitleController = TextEditingController();
  final _profileSubtitleEnController = TextEditingController();
  final _profileSummaryController = TextEditingController();
  final _profileSummaryEnController = TextEditingController();
  final _currentlyExploringController = TextEditingController();
  final _featuredProjectsController = TextEditingController();

  String? _selectedSlug;
  String? _selectedSectionId;
  List<PortfolioMediaItem> _mediaItems = const [];
  PortfolioLanguage _editLanguage = PortfolioLanguage.id;
  _EditPanelMode _mode = _EditPanelMode.page;
  bool _isUploadingMedia = false;

  PortfolioController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleControllerChanged);
    _selectedSlug = _controller.entries.first.slug;
    _selectedSectionId = _controller.sections.first.id;
    _loadSelectedEntry();
    _loadContactActions();
    _loadSelectedSection();
    _loadPageSettings();

    // Listeners for Live Preview updates
    _titleController.addListener(() => setState(() {}));
    _titleEnController.addListener(() => setState(() {}));
    _subtitleController.addListener(() => setState(() {}));
    _subtitleEnController.addListener(() => setState(() {}));
    _periodController.addListener(() => setState(() {}));
    _locationController.addListener(() => setState(() {}));
    _summaryController.addListener(() => setState(() {}));
    _summaryEnController.addListener(() => setState(() {}));
    _previewAssetPathController.addListener(() => setState(() {}));
    _bulletsController.addListener(() => setState(() {}));
    _bulletsEnController.addListener(() => setState(() {}));
    _detailsController.addListener(() => setState(() {}));
    _detailsEnController.addListener(() => setState(() {}));
    _tagsController.addListener(() => setState(() {}));
    _categoriesController.addListener(() => setState(() {}));
    _outcomesController.addListener(() => setState(() {}));
    _learningsController.addListener(() => setState(() {}));
    _contactLocationController.addListener(() => setState(() {}));
    _contactPhoneController.addListener(() => setState(() {}));
    _contactEmailController.addListener(() => setState(() {}));
    _contactLinkedInController.addListener(() => setState(() {}));
    _contactCvUriController.addListener(() => setState(() {}));
    _profileTitleController.addListener(() => setState(() {}));
    _profileTitleEnController.addListener(() => setState(() {}));
    _profileSubtitleController.addListener(() => setState(() {}));
    _profileSubtitleEnController.addListener(() => setState(() {}));
    _profileSummaryController.addListener(() => setState(() {}));
    _profileSummaryEnController.addListener(() => setState(() {}));
    _currentlyExploringController.addListener(() => setState(() {}));
    _featuredProjectsController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _emailController.dispose();
    _passwordController.dispose();
    _titleController.dispose();
    _titleEnController.dispose();
    _subtitleController.dispose();
    _subtitleEnController.dispose();
    _periodController.dispose();
    _locationController.dispose();
    _summaryController.dispose();
    _summaryEnController.dispose();
    _previewAssetPathController.dispose();
    _bulletsController.dispose();
    _bulletsEnController.dispose();
    _detailsController.dispose();
    _detailsEnController.dispose();
    _tagsController.dispose();
    _categoriesController.dispose();
    _outcomesController.dispose();
    _learningsController.dispose();
    _contactLocationController.dispose();
    _contactPhoneController.dispose();
    _contactEmailController.dispose();
    _contactLinkedInController.dispose();
    _contactCvUriController.dispose();
    _sectionTitleController.dispose();
    _sectionTitleEnController.dispose();
    _profileTitleController.dispose();
    _profileTitleEnController.dispose();
    _profileSubtitleController.dispose();
    _profileSubtitleEnController.dispose();
    _profileSummaryController.dispose();
    _profileSummaryEnController.dispose();
    _currentlyExploringController.dispose();
    _featuredProjectsController.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    if (!mounted) return;

    var reloadEntry = false;
    var reloadSection = false;
    if (_selectedSlug != null &&
        _controller.entryBySlug[_selectedSlug] == null) {
      _selectedSlug = _controller.entries.firstOrNull?.slug;
      reloadEntry = true;
    }
    if (_selectedSectionId != null &&
        _controller.sectionById[_selectedSectionId] == null) {
      _selectedSectionId = _controller.sections.firstOrNull?.id;
      reloadSection = true;
    }
    if (reloadEntry) _loadSelectedEntry();
    if (reloadSection) _loadSelectedSection();
    setState(() {});
  }

  Future<void> _signIn() async {
    await _controller.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (!mounted) return;
    _loadSelectedEntry();
    _loadContactActions();
    _loadSelectedSection();
    _loadPageSettings();
    setState(() {});
  }

  void _loadSelectedEntry() {
    final entry = _controller.entryBySlug[_selectedSlug];
    if (entry == null) return;

    _titleController.text = entry.title;
    _titleEnController.text = entry.titleEn ?? '';
    _subtitleController.text = entry.subtitle ?? '';
    _subtitleEnController.text = entry.subtitleEn ?? '';
    _periodController.text = entry.period ?? '';
    _locationController.text = entry.location ?? '';
    _summaryController.text = entry.summary;
    _summaryEnController.text = entry.summaryEn ?? '';
    _previewAssetPathController.text = entry.previewAssetPath ?? '';
    _bulletsController.text = entry.bullets.join('\n');
    _bulletsEnController.text = entry.bulletsEn.join('\n');
    _detailsController.text = entry.detailParagraphs.join('\n\n');
    _detailsEnController.text = entry.detailParagraphsEn.join('\n\n');
    _tagsController.text = entry.tags.join('\n');
    _categoriesController.text = entry.categories.join('\n');
    _outcomesController.text = entry.outcomes.join('\n');
    _learningsController.text = entry.learnings.join('\n');
    _mediaItems = List<PortfolioMediaItem>.of(entry.mediaItems);
  }

  void _loadContactActions() {
    for (final action in _controller.contactActions) {
      switch (action.label) {
        case 'Lokasi':
          _contactLocationController.text = action.value;
          break;
        case 'Telepon':
          _contactPhoneController.text = action.value;
          break;
        case 'Email':
          _contactEmailController.text = action.value;
          break;
        case 'LinkedIn':
          _contactLinkedInController.text = action.value;
          break;
        case 'CV':
          _contactCvUriController.text = action.uri?.toString() ?? '';
          break;
      }
    }
  }

  PortfolioSection? _selectedSection() {
    if (_selectedSectionId == null) return null;
    return _controller.sectionById[_selectedSectionId];
  }

  void _loadSelectedSection() {
    final section = _selectedSection();
    if (section == null) return;

    _sectionTitleController.text = section.title;
    _sectionTitleEnController.text = section.titleEn ?? '';
  }

  void _loadPageSettings() {
    final profile = _controller.entryBySlug['profile'];
    if (profile != null) {
      _profileTitleController.text = profile.title;
      _profileTitleEnController.text = profile.titleEn ?? '';
      _profileSubtitleController.text = profile.subtitle ?? '';
      _profileSubtitleEnController.text = profile.subtitleEn ?? '';
      _profileSummaryController.text = profile.summary;
      _profileSummaryEnController.text = profile.summaryEn ?? '';
    }

    _currentlyExploringController.text = _controller
        .pageSettings
        .currentlyExploring
        .join('\n');
    _featuredProjectsController.text = _controller
        .pageSettings
        .featuredProjectSlugs
        .join('\n');
  }

  PortfolioEntry? _getCurrentEditedEntry() {
    final entry = _controller.entryBySlug[_selectedSlug];
    if (entry == null) return null;

    return PortfolioEntry(
      slug: entry.slug,
      kind: entry.kind,
      title: _titleController.text.trim().isEmpty
          ? 'Untitled'
          : _titleController.text.trim(),
      titleEn: _nullableText(_titleEnController),
      subtitle: _nullableText(_subtitleController),
      subtitleEn: _nullableText(_subtitleEnController),
      period: _nullableText(_periodController),
      location: _nullableText(_locationController),
      summary: _summaryController.text.trim(),
      summaryEn: _nullableText(_summaryEnController),
      previewAssetPath: _nullableText(_previewAssetPathController),
      bullets: _lines(_bulletsController),
      bulletsEn: _lines(_bulletsEnController),
      detailParagraphs: _paragraphs(_detailsController),
      detailParagraphsEn: _paragraphs(_detailsEnController),
      tags: _lines(_tagsController),
      categories: _lines(_categoriesController),
      outcomes: _lines(_outcomesController),
      learnings: _lines(_learningsController),
      mediaItems: List<PortfolioMediaItem>.of(_mediaItems),
    );
  }

  Future<void> _saveSelectedEntry() async {
    final entry = _getCurrentEditedEntry();
    if (entry == null) return;
    await _controller.saveEntry(entry);
  }

  Future<void> _saveSelectedSection() async {
    final section = _selectedSection();
    if (section == null) return;

    final title = _sectionTitleController.text.trim();
    await _controller.saveSection(
      section.copyWith(
        title: title.isEmpty ? section.title : title,
        titleEn: _nullableText(_sectionTitleEnController),
        replaceTitleEn: true,
      ),
    );
  }

  Future<void> _savePageSettings() async {
    final profile = _controller.entryBySlug['profile'];
    if (profile != null) {
      await _controller.saveEntry(
        PortfolioEntry(
          slug: profile.slug,
          kind: profile.kind,
          title: _profileTitleController.text.trim().isEmpty
              ? profile.title
              : _profileTitleController.text.trim(),
          titleEn: _nullableText(_profileTitleEnController),
          subtitle: _nullableText(_profileSubtitleController),
          subtitleEn: _nullableText(_profileSubtitleEnController),
          period: profile.period,
          location: profile.location,
          summary: _profileSummaryController.text.trim().isEmpty
              ? profile.summary
              : _profileSummaryController.text.trim(),
          summaryEn: _nullableText(_profileSummaryEnController),
          bullets: profile.bullets,
          bulletsEn: profile.bulletsEn,
          detailParagraphs: profile.detailParagraphs,
          detailParagraphsEn: profile.detailParagraphsEn,
          tags: profile.tags,
          categories: profile.categories,
          outcomes: profile.outcomes,
          learnings: profile.learnings,
          mediaItems: profile.mediaItems,
          previewAssetPath: profile.previewAssetPath,
        ),
      );
    }

    await _saveSelectedSection();

    await _controller.savePageSettings(
      _controller.pageSettings.copyWith(
        currentlyExploring: _lines(_currentlyExploringController),
        featuredProjectSlugs: _lines(_featuredProjectsController),
      ),
    );
  }

  Future<void> _createNewEntry() async {
    final newSlug = 'entry-${DateTime.now().millisecondsSinceEpoch}';
    final newEntry = PortfolioEntry(
      slug: newSlug,
      kind: PortfolioEntryKind.project,
      title: 'Judul Baru',
      summary: 'Ringkasan konten baru...',
      detailParagraphs: const [],
    );
    await _controller.saveEntry(newEntry);
    setState(() {
      _selectedSlug = newSlug;
      _loadSelectedEntry();
    });
  }

  Future<void> _deleteEntry() async {
    if (_selectedSlug == null || _selectedSlug == 'profile') {
      return; // protect profile
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Portofolio?'),
        content: const Text('Data ini akan dihapus secara permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _controller.deleteEntry(_selectedSlug!);
    }
  }

  Future<void> _saveContactActions() {
    final updatedActions = _controller.contactActions
        .map((action) {
          return switch (action.label) {
            'Lokasi' => action.copyWith(
              value: _contactLocationController.text.trim(),
            ),
            'Telepon' => action.copyWith(
              value: _contactPhoneController.text.trim(),
              uri: _phoneUri(_contactPhoneController.text),
              replaceUri: true,
            ),
            'Email' => action.copyWith(
              value: _contactEmailController.text.trim(),
              uri: _emailUri(_contactEmailController.text),
              replaceUri: true,
            ),
            'LinkedIn' => action.copyWith(
              value: _contactLinkedInController.text.trim(),
              uri: _webUri(_contactLinkedInController.text),
              replaceUri: true,
            ),
            'CV' => action.copyWith(
              uri: _cvUri(_contactCvUriController.text),
              replaceUri: true,
            ),
            _ => action,
          };
        })
        .toList(growable: false);

    return _controller.saveContactActions(updatedActions);
  }

  Uri? _phoneUri(String phone) {
    final normalized = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    if (normalized.isEmpty) return null;

    final whatsappNumber = normalized
        .replaceFirst(RegExp(r'^\+'), '')
        .replaceFirst(RegExp(r'^0'), '62');
    return Uri.parse('https://wa.me/$whatsappNumber');
  }

  Uri? _emailUri(String email) {
    final normalized = email.trim();
    return normalized.isEmpty
        ? null
        : Uri.https('mail.google.com', '/mail/', {
            'view': 'cm',
            'fs': '1',
            'to': normalized,
          });
  }

  Uri? _webUri(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return null;
    if (normalized.startsWith('http://') || normalized.startsWith('https://')) {
      return Uri.tryParse(normalized);
    }
    return Uri.tryParse('https://$normalized');
  }

  Uri? _cvUri(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return Uri.base.resolve('cv_muhammad_varian_warrick.pdf');
    }
    final parsed = Uri.tryParse(normalized);
    if (parsed == null) {
      return Uri.base.resolve('cv_muhammad_varian_warrick.pdf');
    }
    return parsed.hasScheme ? parsed : Uri.base.resolve(normalized);
  }

  String? _nullableText(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  List<String> _lines(TextEditingController controller) {
    return controller.text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  List<String> _paragraphs(TextEditingController controller) {
    return controller.text
        .split(RegExp(r'\n\s*\n'))
        .map((paragraph) => paragraph.trim())
        .where((paragraph) => paragraph.isNotEmpty)
        .toList();
  }

  Future<void> _addManualMedia() async {
    final item = await showDialog<PortfolioMediaItem>(
      context: context,
      builder: (context) => const _MediaItemDialog(),
    );
    if (item == null) return;

    setState(() {
      _mediaItems = [..._mediaItems, item];
    });
  }

  Future<void> _editMediaItem(int index) async {
    final existing = _mediaItems[index];
    final item = await showDialog<PortfolioMediaItem>(
      context: context,
      builder: (context) => _MediaItemDialog(initialItem: existing),
    );
    if (item == null) return;

    setState(() {
      _mediaItems = [
        ..._mediaItems.take(index),
        item,
        ..._mediaItems.skip(index + 1),
      ];
    });
  }

  void _removeMediaItem(int index) {
    setState(() {
      _mediaItems = [
        ..._mediaItems.take(index),
        ..._mediaItems.skip(index + 1),
      ];
    });
  }

  Future<void> _uploadMediaFile() async {
    final slug = _selectedSlug;
    if (slug == null || _isUploadingMedia) return;

    if (!_controller.isFirebaseConfigured) {
      _showSnack(
        'Upload file membutuhkan Firebase aktif. Silakan gunakan "Tambah Link / URL".',
        isError: true,
      );
      return;
    }

    FilePickerResult? result;
    try {
      result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        withData: true,
        allowedExtensions: const [
          'jpg',
          'jpeg',
          'png',
          'gif',
          'webp',
          'bmp',
          'svg',
          'heic',
          'mp4',
          'mov',
          'webm',
          'mkv',
          'avi',
          'pdf',
          'doc',
          'docx',
          'ppt',
          'pptx',
          'xls',
          'xlsx',
          'csv',
          'txt',
          'zip',
          'rar',
        ],
      );
    } catch (error) {
      if (!mounted) return;
      _showSnack('Gagal membuka file picker: $error', isError: true);
      return;
    }

    if (result == null || result.files.isEmpty) return;

    final file = result.files.single;
    final bytes = file.bytes;

    if (bytes == null || bytes.isEmpty) {
      _showSnack(
        'Isi file tidak bisa dibaca. Pastikan browser mengizinkan akses file atau coba file lain.',
        isError: true,
      );
      return;
    }

    // Validasi ukuran file (batas 25 MB).
    const maxBytes = 25 * 1024 * 1024;
    if (bytes.length > maxBytes) {
      _showSnack(
        'Ukuran file ${_formatBytes(bytes.length)} melebihi batas 25 MB. '
        'Silakan kompres atau pilih file yang lebih kecil.',
        isError: true,
      );
      return;
    }

    setState(() => _isUploadingMedia = true);
    _showSnack('Mengunggah ${file.name}...');

    final url = await _controller.uploadEntryMedia(
      entrySlug: slug,
      fileName: file.name,
      bytes: Uint8List.fromList(bytes),
      contentType: _contentTypeForFile(file.name),
    );

    if (!mounted) return;
    setState(() => _isUploadingMedia = false);

    if (url == null) {
      _showSnack(
        _controller.statusMessage ?? 'Upload gagal. Coba lagi.',
        isError: true,
      );
      return;
    }

    final title = file.name.replaceFirst(RegExp(r'\.[^.]+$'), '');
    setState(() {
      _mediaItems = [
        ..._mediaItems,
        PortfolioMediaItem(
          kind: _mediaKindFromFileName(file.name),
          title: title.isEmpty ? file.name : title,
          url: url,
          fileName: file.name,
          contentType: _contentTypeForFile(file.name),
        ),
      ];
    });

    // Auto-save entry agar URL media langsung ter-persist ke Firestore
    // dan tidak hilang jika user lupa menekan tombol simpan.
    try {
      await _saveSelectedEntry();
      if (!mounted) return;
      _showSnack('File "${file.name}" berhasil diupload & entry tersimpan.');
    } catch (error) {
      if (!mounted) return;
      _showSnack(
        'Upload sukses tapi auto-save gagal: $error. '
        'Silakan tekan tombol Simpan.',
        isError: true,
      );
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  PortfolioMediaKind _mediaKindFromFileName(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)) {
      return PortfolioMediaKind.image;
    }
    if (['mp4', 'mov', 'webm'].contains(extension)) {
      return PortfolioMediaKind.video;
    }
    return PortfolioMediaKind.document;
  }

  String? _contentTypeForFile(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return switch (extension) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      'bmp' => 'image/bmp',
      'svg' => 'image/svg+xml',
      'heic' => 'image/heic',
      'mp4' => 'video/mp4',
      'mov' => 'video/quicktime',
      'webm' => 'video/webm',
      'mkv' => 'video/x-matroska',
      'avi' => 'video/x-msvideo',
      'pdf' => 'application/pdf',
      'doc' => 'application/msword',
      'docx' =>
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'ppt' => 'application/vnd.ms-powerpoint',
      'pptx' =>
        'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      'xls' => 'application/vnd.ms-excel',
      'xlsx' =>
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'csv' => 'text/csv',
      'txt' => 'text/plain',
      'zip' => 'application/zip',
      'rar' => 'application/vnd.rar',
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.isSignedIn) {
      return DocumentShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: 'Kembali',
                  onPressed: () =>
                      Navigator.of(context).pushReplacementNamed('/'),
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 8),
                Text(
                  'Edit Panel',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _LoginForm(
              emailController: _emailController,
              passwordController: _passwordController,
              isBusy: _controller.isBusy,
              firebaseConfigured: _controller.isFirebaseConfigured,
              onSignIn: _signIn,
            ),
          ],
        ),
      );
    }

    final isDesktop = MediaQuery.of(context).size.width > 1000;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Pane: Editor
            Container(
              width: isDesktop ? 600 : MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Theme.of(
                      context,
                    ).dividerColor.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: Column(
                children: [
                  _buildEditorHeader(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: _buildEditorForm(context),
                    ),
                  ),
                ],
              ),
            ),

            // Right Pane: Live Preview
            if (isDesktop)
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(
                                context,
                              ).dividerColor.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.visibility_outlined,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Live Preview',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 40,
                            ),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 800,
                                ),
                                child: _buildLivePreview(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLivePreview(BuildContext context) {
    final theme = Theme.of(context);

    if (_mode == _EditPanelMode.entries) {
      final entry = _getCurrentEditedEntry();
      return entry != null
          ? EntryDetailView(entry: entry, language: _editLanguage)
          : const SizedBox.shrink();
    }

    if (_mode == _EditPanelMode.messages) {
      return Center(
        child: Text(
          'Select a message to view details.',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    if (_mode == _EditPanelMode.contact) {
      final contactRows = [
        ('Lokasi', _contactLocationController.text),
        ('Telepon', _contactPhoneController.text),
        ('Email', _contactEmailController.text),
        ('LinkedIn', _contactLinkedInController.text),
        (
          'CV PDF',
          _contactCvUriController.text.isEmpty
              ? 'cv_muhammad_varian_warrick.pdf'
              : _contactCvUriController.text,
        ),
      ];

      return GlassContainer(
        padding: const EdgeInsets.all(28),
        borderRadius: 18,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(title: 'CONTACT PREVIEW'),
            const SizedBox(height: 16),
            for (final row in contactRows) ...[
              Text(
                row.$1,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(row.$2.isEmpty ? '-' : row.$2),
              const SizedBox(height: 14),
            ],
          ],
        ),
      );
    }

    final featuredSlugs = _lines(_featuredProjectsController);
    final exploringItems = _lines(_currentlyExploringController);
    final title =
        _editLanguage == PortfolioLanguage.en &&
            _profileTitleEnController.text.trim().isNotEmpty
        ? _profileTitleEnController.text.trim()
        : _profileTitleController.text.trim();
    final subtitle =
        _editLanguage == PortfolioLanguage.en &&
            _profileSubtitleEnController.text.trim().isNotEmpty
        ? _profileSubtitleEnController.text.trim()
        : _profileSubtitleController.text.trim();
    final summary =
        _editLanguage == PortfolioLanguage.en &&
            _profileSummaryEnController.text.trim().isNotEmpty
        ? _profileSummaryEnController.text.trim()
        : _profileSummaryController.text.trim();

    return GlassContainer(
      padding: const EdgeInsets.all(28),
      borderRadius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(title: 'HOMEPAGE PREVIEW'),
          const SizedBox(height: 16),
          Text(
            title.isEmpty ? 'Muhammad Varian Warrick' : title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
          const SizedBox(height: 18),
          Text(
            summary.isEmpty ? 'Ringkasan profil akan tampil di sini.' : summary,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
          const SizedBox(height: 24),
          Text(
            'Currently Exploring',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final item in exploringItems) Chip(label: Text(item)),
              if (exploringItems.isEmpty)
                const Chip(label: Text('Belum ada item')),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Featured Project Slugs',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(featuredSlugs.isEmpty ? '-' : featuredSlugs.join(', ')),
        ],
      ),
    );
  }

  Widget _buildEditorHeader(BuildContext context) {
    final saveLabel = switch (_mode) {
      _EditPanelMode.page =>
        _controller.isFirebaseConfigured
            ? 'Simpan Halaman'
            : 'Simpan Halaman Draft',
      _EditPanelMode.entries =>
        _controller.isFirebaseConfigured ? 'Simpan' : 'Simpan Draft',
      _EditPanelMode.contact =>
        _controller.isFirebaseConfigured
            ? 'Simpan Kontak'
            : 'Simpan Kontak Draft',
      _EditPanelMode.messages => 'Mark all as read',
    };
    final saveAction = switch (_mode) {
      _EditPanelMode.page => _savePageSettings,
      _EditPanelMode.entries => _saveSelectedEntry,
      _EditPanelMode.contact => _saveContactActions,
      _EditPanelMode.messages => () async {},
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Kembali',
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed('/'),
                icon: const Icon(Icons.arrow_back),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: _controller.isBusy ? null : saveAction,
                icon: const Icon(Icons.save_outlined, size: 18),
                label: Text(saveLabel),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _controller.isBusy
                    ? null
                    : () => _controller.signOut(),
                icon: const Icon(Icons.logout),
                tooltip: 'Keluar',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<_EditPanelMode>(
                segments: const [
                  ButtonSegment(
                    value: _EditPanelMode.page,
                    icon: Icon(Icons.dashboard_customize_outlined),
                    label: Text('Halaman Porto'),
                  ),
                  ButtonSegment(
                    value: _EditPanelMode.entries,
                    icon: Icon(Icons.article_outlined),
                    label: Text('Detail Entry'),
                  ),
                  ButtonSegment(
                    value: _EditPanelMode.contact,
                    icon: Icon(Icons.contact_mail_outlined),
                    label: Text('Kontak'),
                  ),
                  ButtonSegment(
                    value: _EditPanelMode.messages,
                    icon: Icon(Icons.message_outlined),
                    label: Text('Pesan'),
                  ),
                ],
                selected: {_mode},
                onSelectionChanged: (selection) {
                  setState(() {
                    _mode = selection.first;
                  });
                },
              ),
            ),
          ),
          if (_mode == _EditPanelMode.entries) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).dividerColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedSlug,
                        isExpanded: true,
                        icon: const Icon(Icons.expand_more),
                        items: [
                          for (final entry in _controller.entries)
                            DropdownMenuItem(
                              value: entry.slug,
                              child: Text(
                                entry.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedSlug = value;
                              _loadSelectedEntry();
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: _createNewEntry,
                  icon: const Icon(Icons.add),
                  tooltip: 'Tambah Baru',
                ),
                if (_selectedSlug != 'profile') ...[
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    style: IconButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.errorContainer.withValues(alpha: 0.5),
                    ),
                    onPressed: _deleteEntry,
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Hapus',
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitleEditor(BuildContext context) {
    if (_controller.sections.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final selectedSection = _selectedSection();

    return GlassContainer(
      padding: const EdgeInsets.all(18),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.format_list_bulleted_rounded,
                color: theme.colorScheme.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Daftar Isi & Judul Section',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: selectedSection?.id,
            decoration: const InputDecoration(labelText: 'Pilih bagian CV'),
            items: [
              for (final section in _controller.sections)
                DropdownMenuItem(
                  value: section.id,
                  child: Text(section.titleFor(_editLanguage)),
                ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _selectedSectionId = value;
                _loadSelectedSection();
              });
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _sectionTitleController,
            decoration: const InputDecoration(
              labelText: 'Judul section / daftar isi (ID)',
              prefixIcon: Icon(Icons.title_rounded),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _sectionTitleEnController,
            decoration: const InputDecoration(
              labelText: 'Judul section / table of contents (EN)',
              prefixIcon: Icon(Icons.translate_rounded),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.tonalIcon(
              onPressed: _controller.isBusy ? null : _saveSelectedSection,
              icon: const Icon(Icons.save_as_outlined, size: 18),
              label: Text(
                _controller.isFirebaseConfigured
                    ? 'Simpan Judul Section'
                    : 'Simpan Judul Draft',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactEditor(BuildContext context) {
    final theme = Theme.of(context);

    return GlassContainer(
      padding: const EdgeInsets.all(18),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.contact_mail_outlined,
                color: theme.colorScheme.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Kontak & Action Links',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _contactLocationController,
            decoration: const InputDecoration(
              labelText: 'Lokasi',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _contactPhoneController,
            decoration: const InputDecoration(
              labelText: 'Telepon',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _contactEmailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _contactLinkedInController,
            decoration: const InputDecoration(
              labelText: 'LinkedIn display atau URL',
              prefixIcon: Icon(Icons.work_outline),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _contactCvUriController,
            decoration: const InputDecoration(
              labelText: 'CV PDF URL atau path',
              prefixIcon: Icon(Icons.picture_as_pdf_outlined),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.tonalIcon(
              onPressed: _controller.isBusy ? null : _saveContactActions,
              icon: const Icon(Icons.save_outlined, size: 18),
              label: Text(
                _controller.isFirebaseConfigured
                    ? 'Simpan Kontak'
                    : 'Simpan Kontak Draft',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageSettingsForm(BuildContext context) {
    final theme = Theme.of(context);
    final availableProjectSlugs = _controller.entries
        .where((entry) => entry.kind == PortfolioEntryKind.project)
        .map((entry) => entry.slug)
        .join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitleEditor(context),
        const SizedBox(height: 24),
        GlassContainer(
          padding: const EdgeInsets.all(18),
          borderRadius: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.dashboard_customize_outlined,
                    color: theme.colorScheme.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Hero / Profil Homepage',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _profileTitleController,
                decoration: const InputDecoration(
                  labelText: 'Nama / headline utama (ID)',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _profileTitleEnController,
                decoration: const InputDecoration(
                  labelText: 'Name / main headline (EN)',
                  prefixIcon: Icon(Icons.translate_rounded),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _profileSubtitleController,
                decoration: const InputDecoration(
                  labelText: 'Subheadline homepage (ID)',
                  prefixIcon: Icon(Icons.short_text_rounded),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _profileSubtitleEnController,
                decoration: const InputDecoration(
                  labelText: 'Homepage subheadline (EN)',
                  prefixIcon: Icon(Icons.translate_rounded),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _profileSummaryController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Ringkasan profil homepage (ID)',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _profileSummaryEnController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Homepage profile summary (EN)',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.translate_rounded),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        GlassContainer(
          padding: const EdgeInsets.all(18),
          borderRadius: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome_outlined,
                    color: theme.colorScheme.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Sorotan Homepage',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _currentlyExploringController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Currently Exploring (satu item per baris)',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.explore_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _featuredProjectsController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Featured Project Slugs (satu slug per baris)',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.star_outline_rounded),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                availableProjectSlugs.isEmpty
                    ? 'Belum ada project slug.'
                    : 'Slug project tersedia: $availableProjectSlugs',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonalIcon(
                  onPressed: _controller.isBusy ? null : _savePageSettings,
                  icon: const Icon(Icons.save_outlined, size: 18),
                  label: Text(
                    _controller.isFirebaseConfigured
                        ? 'Simpan Halaman Porto'
                        : 'Simpan Halaman Draft',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMediaEditor(BuildContext context) {
    final theme = Theme.of(context);

    return GlassContainer(
      padding: const EdgeInsets.all(18),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.perm_media_outlined,
                color: theme.colorScheme.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Media, Dokumen & Link Detail',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan gambar, GIF, video, dokumen, atau link untuk ditampilkan di halaman detail entry ini.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.tonalIcon(
                onPressed: _controller.isBusy || _isUploadingMedia
                    ? null
                    : _addManualMedia,
                icon: const Icon(Icons.add_link_rounded, size: 18),
                label: const Text('Tambah Link / URL'),
              ),
              FilledButton.icon(
                onPressed:
                    !_controller.isFirebaseConfigured ||
                        _controller.isBusy ||
                        _isUploadingMedia
                    ? null
                    : _uploadMediaFile,
                icon: _isUploadingMedia
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.upload_file_rounded, size: 18),
                label: Text(_isUploadingMedia ? 'Uploading...' : 'Upload File'),
              ),
            ],
          ),
          if (!_controller.isFirebaseConfigured) ...[
            const SizedBox(height: 10),
            Text(
              'Upload file membutuhkan Firebase aktif. Kamu tetap bisa menambahkan URL manual.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (_mediaItems.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.35,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Text(
                'Belum ada media atau link untuk detail ini.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            for (int i = 0; i < _mediaItems.length; i++) ...[
              _MediaEditorTile(
                item: _mediaItems[i],
                onEdit: () => _editMediaItem(i),
                onDelete: () => _removeMediaItem(i),
              ),
              if (i < _mediaItems.length - 1) const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }

  Widget _buildEditorForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_controller.statusMessage != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _controller.statusMessage!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        if (_mode == _EditPanelMode.page) ...[
          _buildPageSettingsForm(context),
          const SizedBox(height: 100),
        ] else if (_mode == _EditPanelMode.contact) ...[
          _buildContactEditor(context),
          const SizedBox(height: 100),
        ] else if (_mode == _EditPanelMode.messages) ...[
          const _MessagesList(),
          const SizedBox(height: 100),
        ] else ...[
          SegmentedButton<PortfolioLanguage>(
            segments: const [
              ButtonSegment(value: PortfolioLanguage.id, label: Text('ID')),
              ButtonSegment(value: PortfolioLanguage.en, label: Text('EN')),
            ],
            selected: {_editLanguage},
            onSelectionChanged: (s) => setState(() => _editLanguage = s.first),
          ),
          const SizedBox(height: 32),

          // Notion-style inputs
          _DocsInput(
            hint: _editLanguage == PortfolioLanguage.en
                ? 'Project Title'
                : 'Judul Proyek',
            controller: _editLanguage == PortfolioLanguage.en
                ? _titleEnController
                : _titleController,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          _DocsInput(
            hint: _editLanguage == PortfolioLanguage.en
                ? 'Subtitle (optional)'
                : 'Subjudul (opsional)',
            controller: _editLanguage == PortfolioLanguage.en
                ? _subtitleEnController
                : _subtitleController,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 24),
          if (_editLanguage == PortfolioLanguage.id) ...[
            Row(
              children: [
                Icon(
                  Icons.date_range_outlined,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _DocsInput(
                    hint: 'Periode (misal: 2023 - 2024)',
                    controller: _periodController,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _DocsInput(
                    hint: 'Lokasi',
                    controller: _locationController,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          _DocsInput(
            hint: 'Summary (Ringkasan singkat)',
            controller: _editLanguage == PortfolioLanguage.en
                ? _summaryEnController
                : _summaryController,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
            maxLines: null,
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          if (_editLanguage == PortfolioLanguage.id) ...[
            const SectionHeading(title: 'PREVIEW IMAGE PATH'),
            _DocsInput(
              hint: 'assets/images/nama_file.png',
              controller: _previewAssetPathController,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
          ],

          _buildMediaEditor(context),
          const SizedBox(height: 24),

          const SectionHeading(title: 'OVERVIEW / DETAIL PARAGRAPHS'),
          _DocsInput(
            hint:
                'Tulis paragraf detail di sini. Pisahkan paragraf dengan baris kosong (Enter 2x).',
            controller: _editLanguage == PortfolioLanguage.en
                ? _detailsEnController
                : _detailsController,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.6),
            maxLines: null,
          ),

          const SizedBox(height: 24),
          const SectionHeading(title: 'BULLETS / NOTES'),
          _DocsInput(
            hint:
                'Tulis poin-poin. Setiap baris baru akan menjadi satu peluru (bullet).',
            controller: _editLanguage == PortfolioLanguage.en
                ? _bulletsEnController
                : _bulletsController,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.6),
            maxLines: null,
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          const SectionHeading(title: 'TAGS & METADATA'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tags (Satu per baris)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    _DocsInput(
                      hint: 'Misal: Flutter\nDart',
                      controller: _tagsController,
                      maxLines: null,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Categories (Satu per baris)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    _DocsInput(
                      hint: 'Misal: Mobile\nWeb',
                      controller: _categoriesController,
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Outcomes (Satu per baris)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    _DocsInput(
                      hint: 'Hasil proyek...',
                      controller: _outcomesController,
                      maxLines: null,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Learnings (Satu per baris)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    _DocsInput(
                      hint: 'Hal yang dipelajari...',
                      controller: _learningsController,
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 100), // spacing
        ],
      ],
    );
  }
}

class _DocsInput extends StatelessWidget {
  const _DocsInput({
    required this.hint,
    required this.controller,
    this.style,
    this.maxLines = 1,
  });

  final String hint;
  final TextEditingController controller;
  final TextStyle? style;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: style,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: style?.copyWith(
          color:
              style?.color?.withValues(alpha: 0.3) ??
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        border: InputBorder.none,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }
}

class _MediaEditorTile extends StatelessWidget {
  const _MediaEditorTile({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final PortfolioMediaItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _mediaKindIcon(item.kind),
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.url,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit media',
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 18),
          ),
          IconButton(
            tooltip: 'Hapus media',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, size: 18),
            color: theme.colorScheme.error,
          ),
        ],
      ),
    );
  }
}

class _MediaItemDialog extends StatefulWidget {
  const _MediaItemDialog({this.initialItem});

  final PortfolioMediaItem? initialItem;

  @override
  State<_MediaItemDialog> createState() => _MediaItemDialogState();
}

class _MediaItemDialogState extends State<_MediaItemDialog> {
  late PortfolioMediaKind _kind;
  late final TextEditingController _titleController;
  late final TextEditingController _urlController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    _kind = item?.kind ?? PortfolioMediaKind.link;
    _titleController = TextEditingController(text: item?.title ?? '');
    _urlController = TextEditingController(text: item?.url ?? '');
    _descriptionController = TextEditingController(
      text: item?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final url = _urlController.text.trim();
    if (title.isEmpty || url.isEmpty) return;

    final normalizedUrl =
        url.startsWith('http://') || url.startsWith('https://')
        ? url
        : 'https://$url';

    Navigator.of(context).pop(
      PortfolioMediaItem(
        kind: _kind,
        title: title,
        url: normalizedUrl,
        description: _nullableDialogText(_descriptionController),
        fileName: widget.initialItem?.fileName,
        contentType: widget.initialItem?.contentType,
      ),
    );
  }

  String? _nullableDialogText(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.initialItem == null
            ? 'Tambah Media / Link'
            : 'Edit Media / Link',
      ),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<PortfolioMediaKind>(
                initialValue: _kind,
                decoration: const InputDecoration(
                  labelText: 'Jenis',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: [
                  for (final kind in PortfolioMediaKind.values)
                    DropdownMenuItem(
                      value: kind,
                      child: Text(kind.labelFor(PortfolioLanguage.id)),
                    ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _kind = value);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  prefixIcon: Icon(Icons.title_rounded),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'URL',
                  prefixIcon: Icon(Icons.link_rounded),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi singkat (opsional)',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.save_outlined, size: 18),
          label: const Text('Simpan'),
        ),
      ],
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

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.emailController,
    required this.passwordController,
    required this.isBusy,
    required this.firebaseConfigured,
    required this.onSignIn,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isBusy;
  final bool firebaseConfigured;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeading(title: 'LOGIN ADMIN'),
          Text(
            firebaseConfigured
                ? 'Masuk memakai Firebase Authentication Email/Password.'
                : 'Firebase belum dikonfigurasi. Login ini membuka local draft mode untuk mengedit isi CV di sesi berjalan.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
            ),
            obscureText: true,
            onSubmitted: (_) => isBusy ? null : onSignIn(),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isBusy ? null : onSignIn,
            icon: const Icon(Icons.login),
            label: const Text(
              'Masuk dengan Email',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessagesList extends StatelessWidget {
  const _MessagesList();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeading(title: 'PESAN MASUK'),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('messages')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data?.docs ?? [];
            if (docs.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('Belum ada pesan masuk.'),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data() as Map<String, dynamic>;
                final createdAt = data['createdAt'] as Timestamp?;
                final dateStr = createdAt != null
                    ? '${createdAt.toDate().toLocal()}'.split('.')[0]
                    : '';

                return GlassContainer(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              data['name'] ?? 'Unknown',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            dateStr,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                      if (data['email'] != null &&
                          data['email'].toString().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              data['email'],
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 12),
                      Text(
                        data['message'] ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
