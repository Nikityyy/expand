// lib/ui/screens/app_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import 'home_screen.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';
import '../../core/app_colors.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  static _AppShellState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AppShellState>();

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  void switchToMap() {
    setState(() => _currentIndex = 0);
  }

  final _screens = [
    HomeScreen(key: HomeScreen.globalKey),
    const StatisticsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) {
            HapticFeedback.selectionClick();
            setState(() => _currentIndex = i);
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.explore_outlined),
              selectedIcon: const Icon(Icons.explore),
              label: l10n.exploreTab,
            ),
            NavigationDestination(
              icon: const Icon(Icons.bar_chart_outlined),
              selectedIcon: const Icon(Icons.bar_chart),
              label: l10n.statisticsTab,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: l10n.settingsTab,
            ),
          ],
        ),
      ),
    );
  }
}
