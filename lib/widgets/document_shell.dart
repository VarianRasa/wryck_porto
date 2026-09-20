import 'package:flutter/material.dart';
import 'futuristic_background.dart';

class DocumentShell extends StatelessWidget {
  const DocumentShell({
    super.key,
    required this.child,
    this.sideNavigation,
    this.floatingSideNavigation,
  });

  final Widget child;
  final Widget? sideNavigation;
  final Widget? floatingSideNavigation;

  Future<void> _showNavigation(BuildContext context) async {
    if (sideNavigation == null) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          child: sideNavigation!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FuturisticBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final showSideNavigation =
                  sideNavigation != null && constraints.maxWidth > 1120;
              final compactNavigation =
                  sideNavigation != null && constraints.maxWidth <= 640;
              final isWide = constraints.maxWidth > 720;

              Widget content;
              if (showSideNavigation) {
                content = Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1360),
                    child: SizedBox(
                      height: constraints.maxHeight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(
                                  24,
                                  26,
                                  24,
                                  56,
                                ),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 970,
                                    ),
                                    child: _DocumentPaper(child: child),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 28),
                            SizedBox(
                              width: 250,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(
                                  0,
                                  34,
                                  0,
                                  40,
                                ),
                                child: sideNavigation!,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                content = Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 28 : 16,
                      vertical: isWide ? 24 : 14,
                    ),
                    child: Column(
                      children: [
                        if (sideNavigation != null && !compactNavigation) ...[
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 970),
                            child: sideNavigation!,
                          ),
                          const SizedBox(height: 18),
                        ],
                        if (sideNavigation != null && compactNavigation) ...[
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton.icon(
                              onPressed: () => _showNavigation(context),
                              icon: const Icon(Icons.menu_rounded, size: 18),
                              label: const Text('Menu'),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 970),
                          child: _DocumentPaper(child: child),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (floatingSideNavigation == null) return content;

              return Stack(
                children: [
                  Positioned.fill(child: content),
                  Positioned(
                    top: isWide ? 28 : null,
                    right: isWide ? 24 : 18,
                    bottom: isWide ? null : 18,
                    child: floatingSideNavigation!,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DocumentPaper extends StatelessWidget {
  const _DocumentPaper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(
          alpha: isDark ? 0.94 : 0.98,
        ),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: isDark ? const Color(0xff3a453d) : const Color(0xffd4d5cb),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.07),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(
          MediaQuery.sizeOf(context).width < 640 ? 20 : 56,
        ),
        child: child,
      ),
    );
  }
}
