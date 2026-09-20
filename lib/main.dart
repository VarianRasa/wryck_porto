import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controllers/portfolio_controller.dart';
import 'models/portfolio_models.dart';
import 'screens/detail_screen.dart';
import 'screens/edit_panel_screen.dart';
import 'screens/home_screen.dart';
import 'services/firebase_portfolio_backend.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final backend = await FirebasePortfolioBackend.create();
  runApp(MyApp(backend: backend));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.initialRoute = '/', this.backend});

  final String initialRoute;
  final PortfolioBackend? backend;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final PortfolioController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PortfolioController(backend: widget.backend);
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return MaterialApp(
          title: 'Muhammad Varian Warrick Portfolio',
          debugShowCheckedModeBanner: false,
          initialRoute: widget.initialRoute,
          onGenerateRoute: _generateRoute,
          themeMode: _controller.themeMode,
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
        );
      },
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final ink = isDark ? const Color(0xfff4f4f5) : const Color(0xff09090b);
    final canvas = isDark ? const Color(0xff09090b) : Colors.white;
    final panel = isDark ? const Color(0xff151515) : const Color(0xfff4f4f5);
    final lime = const Color(0xff09b001);
    final muted = isDark ? const Color(0xffa1a1aa) : const Color(0xff71717a);
    final accent = isDark ? const Color(0xffd4d4d8) : const Color(0xff27272a);
    final baseTextTheme = GoogleFonts.spaceGroteskTextTheme(
      isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: canvas,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: lime,
        onPrimary: isDark ? const Color(0xff15200e) : Colors.white,
        secondary: accent,
        onSecondary: Colors.white,
        error: const Color(0xffc44f4f),
        onError: Colors.white,
        surface: panel,
        onSurface: ink,
        surfaceContainerHighest: isDark
            ? const Color(0xff2a302b)
            : const Color(0xffe6e5dc),
        onSurfaceVariant: muted,
        outline: isDark ? const Color(0xff4a554d) : const Color(0xffc6c9bf),
        outlineVariant: isDark
            ? const Color(0xff303832)
            : const Color(0xffd7d8cf),
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 72,
          height: 0.96,
          letterSpacing: -4.2,
          color: ink,
        ),
        displayMedium: baseTextTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 52,
          height: 0.98,
          letterSpacing: -2.6,
          color: ink,
        ),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 42,
          height: 1,
          letterSpacing: -1.8,
          color: ink,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 30,
          letterSpacing: -1,
          color: ink,
        ),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 24,
          letterSpacing: -0.5,
          color: ink,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: ink,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: ink,
        ),
        titleSmall: baseTextTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          letterSpacing: 0.1,
          color: ink,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          fontSize: 16,
          height: 1.55,
          color: ink,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          fontSize: 14,
          height: 1.5,
          color: ink,
        ),
        bodySmall: baseTextTheme.bodySmall?.copyWith(
          fontSize: 12,
          height: 1.45,
          color: muted,
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
          color: ink,
        ),
        labelSmall: baseTextTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: muted,
        ),
      ),
      dividerColor: isDark ? const Color(0xff354038) : const Color(0xffd1d2c8),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xff202620) : const Color(0xfff8f7f0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: isDark ? const Color(0xff3d493f) : const Color(0xffc7c9be),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: isDark ? const Color(0xff3d493f) : const Color(0xffc7c9be),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: lime, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        isDense: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: lime,
          foregroundColor: isDark ? const Color(0xff17200f) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          textStyle: baseTextTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          side: BorderSide(
            color: isDark ? const Color(0xff566358) : const Color(0xffaeb3a9),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          textStyle: baseTextTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            baseTextTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        side: BorderSide(
          color: isDark ? const Color(0xff465247) : const Color(0xffc8cbc0),
        ),
        labelStyle: baseTextTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: ink,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: panel,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: const WidgetStatePropertyAll(true),
        thickness: const WidgetStatePropertyAll(5),
        radius: const Radius.circular(4),
        thumbColor: WidgetStatePropertyAll(muted.withValues(alpha: 0.5)),
        trackColor: const WidgetStatePropertyAll(Colors.transparent),
        trackBorderColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  Route<void> _generateRoute(RouteSettings settings) {
    final name = settings.name ?? '/';
    final uri = Uri.parse(name);
    final language = uri.queryParameters['lang'] == 'en'
        ? PortfolioLanguage.en
        : PortfolioLanguage.id;

    if (uri.path == '/') {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => HomeScreen(controller: _controller),
      );
    }

    if (uri.path == '/admin') {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => EditPanelScreen(controller: _controller),
      );
    }

    if (uri.pathSegments.length == 2 &&
        (uri.pathSegments.first == 'detail' ||
            uri.pathSegments.first == 'projects')) {
      final slug = uri.pathSegments.last;
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => DetailScreen(
          slug: slug,
          language: language,
          controller: _controller,
        ),
      );
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => DetailScreen(slug: name, controller: _controller),
    );
  }
}
