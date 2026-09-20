import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xff151515),
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 1200;
            final showSidebar = sideNavigation != null && isDesktop;
            final content = _PageContent(child: child);

            if (showSidebar) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1440),
                  child: Padding(
                    padding: EdgeInsets.all(isDesktop ? 24 : 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: isDesktop ? 272 : 232,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: sideNavigation,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(child: content),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (sideNavigation != null && constraints.maxWidth >= 640)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: sideNavigation!,
                      ),
                    if (sideNavigation != null && constraints.maxWidth < 640)
                      _MobileTopBar(onMenu: () => _showNavigation(context)),
                    Expanded(child: content),
                  ],
                ),
                if (floatingSideNavigation != null)
                  Positioned(
                    right: 18,
                    bottom: 18,
                    child: floatingSideNavigation!,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  const _PageContent({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 640;
            final horizontalPadding = isNarrow ? 40.0 : 96.0;
            final contentWidth = (constraints.maxWidth - horizontalPadding)
                .clamp(0.0, 980.0)
                .toDouble();
            return SizedBox.expand(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  isNarrow ? 20 : 48,
                  isNarrow ? 24 : 38,
                  isNarrow ? 20 : 48,
                  72,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(width: contentWidth, child: child),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MobileTopBar extends StatelessWidget {
  const _MobileTopBar({required this.onMenu});

  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.grid_view_rounded,
              color: theme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MW / PORTFOLIO',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  'CV, projects, and selected work',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: onMenu,
            tooltip: 'Open menu',
            icon: const Icon(Icons.menu_rounded),
          ),
        ],
      ),
    );
  }
}
