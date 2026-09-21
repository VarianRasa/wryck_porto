import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wryck_porto/main.dart';

void main() {
  testWidgets('homepage renders the CV portfolio sections', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Muhammad Varian Warrick'), findsOneWidget);
    expect(find.byKey(const ValueKey('profile-portrait')), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('PENDIDIKAN'), findsOneWidget);
    expect(find.text('INTERNSHIP EXPERIENCE'), findsOneWidget);
    expect(find.text('PROJECT EXPERIENCE'), findsOneWidget);
    expect(find.text('VOLUNTEERING EXPERIENCE'), findsOneWidget);
    expect(find.text('SKILLS, INTEREST, AND OTHER EXPERIENCE'), findsOneWidget);
    expect(find.text('EXTRA QUALIFICATION'), findsOneWidget);
  });

  testWidgets('project items open a full detail page and can go back', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Necliv Application').first);
    await tester.tap(find.text('Necliv Application').first);
    await tester.pumpAndSettle();

    expect(find.text('Detail Proyek'), findsOneWidget);
    expect(find.text('Necliv Application'), findsWidgets);
    expect(find.textContaining('FlutterFlow'), findsWidgets);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Muhammad Varian Warrick'), findsOneWidget);
    expect(find.text('PROJECT EXPERIENCE'), findsOneWidget);
  });

  testWidgets('unknown detail route shows a not found state', (tester) async {
    await tester.pumpWidget(const MyApp(initialRoute: '/detail/tidak-ada'));

    expect(find.text('Konten tidak ditemukan'), findsOneWidget);
    expect(find.textContaining('tidak-ada'), findsOneWidget);
  });

  testWidgets('homepage exposes portfolio polish controls', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Featured Projects'), findsOneWidget);
    expect(find.text('Currently Exploring'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('UI/UX'), findsWidgets);
    expect(find.text('Data'), findsWidgets);
    expect(find.text('ID'), findsOneWidget);
    expect(find.text('EN'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('Edit Panel'), findsOneWidget);
    expect(find.text('Copy Email'), findsOneWidget);
    expect(find.text('LinkedIn'), findsOneWidget);
    expect(find.text('Contact'), findsOneWidget);
    expect(find.text('CV / PDF'), findsOneWidget);
  });

  testWidgets('search and category filter narrow visible projects', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextField), 'warehouse');
    await tester.pumpAndSettle();

    expect(find.text('Project Data Warehouse and OLAP'), findsWidgets);
    expect(find.text('Necliv Application'), findsNothing);

    await tester.enterText(find.byType(TextField), '');
    await tester.tap(find.widgetWithText(ChoiceChip, 'Data'));
    await tester.pumpAndSettle();

    expect(find.text('Project Data Warehouse and OLAP'), findsWidgets);
    expect(find.text('ChemTwist Application UI'), findsNothing);
  });

  testWidgets('English toggle swaps visible portfolio copy', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('EN'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Bachelor of Information Systems graduate'),
      findsOneWidget,
    );
    expect(find.text('EDUCATION'), findsOneWidget);
  });

  testWidgets('project route supports readable project deep links', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MyApp(initialRoute: '/projects/necliv-application'),
    );

    expect(find.text('Detail Proyek'), findsOneWidget);
    expect(find.text('Necliv Application'), findsWidgets);
  });

  testWidgets('admin route shows email login and editable CV fields', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp(initialRoute: '/admin'));

    expect(find.text('Edit Panel'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Masuk dengan Email'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Email'),
      'admin@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Password'),
      'password',
    );
    await tester.tap(find.text('Masuk dengan Email'));
    await tester.pumpAndSettle();

    expect(find.text('Halaman Porto'), findsOneWidget);
    expect(find.text('Detail Entry'), findsOneWidget);
    expect(find.text('Kontak'), findsOneWidget);
    expect(find.text('Daftar Isi & Judul Section'), findsOneWidget);
    expect(find.text('Hero / Profil Homepage'), findsOneWidget);
    expect(find.text('Judul section / daftar isi (ID)'), findsOneWidget);
    expect(
      find.text('Currently Exploring (satu item per baris)'),
      findsOneWidget,
    );
    expect(
      find.text('Featured Project Slugs (satu slug per baris)'),
      findsOneWidget,
    );
    expect(find.text('Simpan Judul Draft'), findsOneWidget);
    expect(find.text('Simpan Halaman Draft'), findsWidgets);

    await tester.tap(find.text('Kontak'));
    await tester.pumpAndSettle();

    expect(find.text('Kontak & Action Links'), findsOneWidget);
    expect(find.text('Simpan Kontak Draft'), findsWidgets);

    await tester.tap(find.text('Detail Entry'));
    await tester.pumpAndSettle();

    expect(find.text('Simpan Draft'), findsOneWidget);
    expect(find.text('OVERVIEW / DETAIL PARAGRAPHS'), findsOneWidget);
  });
}
