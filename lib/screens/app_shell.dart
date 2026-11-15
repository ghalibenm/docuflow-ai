import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/doc_stats.dart';
import '../state/app_state.dart';
import '../widgets/brand.dart';
import 'home_screen.dart';
import 'import_screen.dart';
import 'pilots_screen.dart';
import 'records_screen.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final strings = state.text;

    final screens = const <Widget>[
      HomeScreen(),
      ImportScreen(),
      RecordsScreen(),
      PilotsScreen(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 1000;
        return Scaffold(
          backgroundColor: AppColors.paper,
          body: SafeArea(
            bottom: false,
            child: Row(
              children: [
                if (wide) const _Sidebar(),
                Expanded(
                  child: Column(
                    children: [
                      _TopBar(wide: wide),
                      Expanded(
                        child: IndexedStack(
                          index: state.tabIndex,
                          children: screens,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: wide
              ? null
              : DecoratedBox(
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(top: BorderSide(color: AppColors.line)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: NavigationBar(
                      selectedIndex: state.tabIndex,
                      onDestinationSelected: state.selectTab,
                      destinations: [
                        NavigationDestination(
                          icon: const Icon(Icons.space_dashboard_outlined),
                          selectedIcon: const Icon(
                            Icons.space_dashboard_rounded,
                          ),
                          label: strings.navDashboard,
                        ),
                        NavigationDestination(
                          icon: const Icon(Icons.add_photo_alternate_outlined),
                          selectedIcon: const Icon(
                            Icons.add_photo_alternate_rounded,
                          ),
                          label: strings.navImport,
                        ),
                        NavigationDestination(
                          icon: Badge.count(
                            count: state.documents.pendingCount,
                            isLabelVisible: state.documents.pendingCount > 0,
                            backgroundColor: AppColors.amber,
                            child: const Icon(Icons.table_rows_outlined),
                          ),
                          selectedIcon: Badge.count(
                            count: state.documents.pendingCount,
                            isLabelVisible: state.documents.pendingCount > 0,
                            backgroundColor: AppColors.amber,
                            child: const Icon(Icons.table_rows_rounded),
                          ),
                          label: strings.navRecords,
                        ),
                        NavigationDestination(
                          icon: const Icon(Icons.business_outlined),
                          selectedIcon: const Icon(Icons.business_rounded),
                          label: strings.navPilots,
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final strings = state.text;
    final items = [
      (strings.navDashboard, Icons.space_dashboard_outlined),
      (strings.navImport, Icons.add_photo_alternate_outlined),
      (strings.navRecords, Icons.table_rows_outlined),
      (strings.navPilots, Icons.business_outlined),
    ];

    return Container(
      width: AppLayout.sidebarWidth,
      decoration: const BoxDecoration(color: AppColors.primaryDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppWordmark(onDark: true),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: Color(0xFF7CDBB8),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          strings.pilotMode,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.58),
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          for (var index = 0; index < items.length; index++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: _SidebarItem(
                label: items[index].$1,
                icon: items[index].$2,
                selected: state.tabIndex == index,
                badge: index == 2 ? state.documents.pendingCount : 0,
                onTap: () => state.selectTab(index),
              ),
            ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.055),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: const Color(0xFF7CDBB8)
                                  .withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.shield_outlined,
                              color: Color(0xFF7CDBB8),
                              size: 15,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              strings.humanValidation,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        strings.validationFooter,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 9,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'DocuFlow AI · v1.0 · ${strings.prototype}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontSize: 8.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.badge,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final int badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? AppColors.primaryDeep
        : Colors.white.withValues(alpha: 0.58);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: foreground),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 12.5,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
              if (badge > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.amberSoft
                        : const Color(0xFF3A5E52),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$badge',
                    style: TextStyle(
                      color: selected ? AppColors.amberDeep : Colors.white,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final strings = state.text;
    final labels = [
      strings.navDashboard,
      strings.navImport,
      strings.navRecords,
      strings.navPilots,
    ];

    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: wide ? 26 : 18),
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border(
          bottom: BorderSide(color: AppColors.line.withValues(alpha: 0.8)),
        ),
      ),
      child: Row(
        children: [
          if (wide) ...[
            Text(
              strings.homeEyebrow.toUpperCase(),
              style: const TextStyle(
                color: AppColors.inkMuted,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 9),
              child: Icon(
                Icons.chevron_right_rounded,
                size: 14,
                color: AppColors.inkMuted,
              ),
            ),
            Text(
              labels[state.tabIndex],
              style: const TextStyle(
                color: AppColors.inkSoft,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ] else
            const AppWordmark(markSize: 30, showTagline: false),
          const Spacer(),
          if (wide) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    strings.localProcessing,
                    style: const TextStyle(
                      color: AppColors.inkSoft,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
          ],
          const LanguageToggle(),
          if (wide) ...[
            const SizedBox(width: 12),
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryDeep,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'DF',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
