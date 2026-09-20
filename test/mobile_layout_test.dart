import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wryck_porto/main.dart';

void main() {
  testWidgets('homepage stays within a narrow mobile viewport', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final header = find.text('MW / PORTFOLIO 2026');
    final availability = find.text('TERBUKA UNTUK KERJA');
    final headline = find.text('Hi, saya Muhammad Varian\nWarrick');
    final summary = find.textContaining(
      'lulusan Sistem Informasi dari UPN Veteran Jakarta',
    );
    expect(find.byKey(const ValueKey('profile-portrait')), findsOneWidget);
    expect(header, findsOneWidget);
    expect(availability, findsOneWidget);
    expect(headline, findsOneWidget);
    expect(summary, findsOneWidget);
    for (final finder in [header, availability, headline, summary]) {
      expect(tester.getBottomRight(finder).dx, lessThanOrEqualTo(390));
    }
    expect(tester.getTopLeft(find.byKey(const ValueKey('profile-portrait'))).dx,
        greaterThanOrEqualTo(0));
    expect(tester.getBottomRight(find.byKey(const ValueKey('profile-portrait'))).dx,
        lessThanOrEqualTo(390));
  });
}
