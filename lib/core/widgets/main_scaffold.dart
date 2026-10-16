import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Bottom navigation scaffold shell that hosts a swipeable [PageView]
/// across Home, Deck, and Settings branches with a synchronized bottom navigation bar.
class MainScaffold extends StatefulWidget {
  /// The navigation shell provided by [StatefulShellRoute].
  final StatefulNavigationShell navigationShell;

  /// The parallel branch navigators for each tab branch.
  final List<Widget> children;

  const MainScaffold({
    super.key,
    required this.navigationShell,
    required this.children,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.navigationShell.currentIndex,
    );
  }

  @override
  void didUpdateWidget(covariant MainScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navigationShell.currentIndex !=
        oldWidget.navigationShell.currentIndex) {
      final targetIndex = widget.navigationShell.currentIndex;
      if (_pageController.hasClients &&
          _pageController.page?.round() != targetIndex) {
        _pageController.animateToPage(
          targetIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (index != widget.navigationShell.currentIndex) {
      widget.navigationShell.goBranch(index);
    }
  }

  void _onItemTapped(int index) {
    if (index == widget.navigationShell.currentIndex) {
      widget.navigationShell.goBranch(index, initialLocation: true);
    } else {
      widget.navigationShell.goBranch(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedIndex = widget.navigationShell.currentIndex;
    final WidgetVars(:l) = WidgetVars.of(context);

    final backgroundColor = isDark
        ? theme.colorScheme.surface
        : AppColors.lightBackground;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: widget.children
            .map((child) => _KeepAliveTab(child: child))
            .toList(),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          color: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                label: l.nav_home,
                icon: Symbols.home,
                isSelected: selectedIndex == 0,
                onTap: () => _onItemTapped(0),
              ),
              _NavBarItem(
                label: l.nav_multiplayer,
                icon: Symbols.groups,
                isSelected: selectedIndex == 1,
                onTap: () => _onItemTapped(1),
              ),
              _NavBarItem(
                label: l.nav_deck,
                icon: Symbols.style,
                isSelected: selectedIndex == 2,
                onTap: () => _onItemTapped(2),
              ),
              _NavBarItem(
                label: l.nav_settings,
                icon: Symbols.settings,
                isSelected: selectedIndex == 3,
                onTap: () => _onItemTapped(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Keeps a tab alive in [PageView] so it is not disposed when swiped off-screen.
class _KeepAliveTab extends StatefulWidget {
  final Widget child;

  const _KeepAliveTab({required this.child});

  @override
  State<_KeepAliveTab> createState() => _KeepAliveTabState();
}

class _KeepAliveTabState extends State<_KeepAliveTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class _NavBarItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedBgColor = isDark
        ? AppColors.darkPrimaryContainer
        : AppColors.primary;
    final selectedTextColor = isDark
        ? AppColors.darkOnSurface
        : AppColors.mainText;
    final unselectedTextColor = isDark
        ? AppColors.darkOnSurfaceMuted
        : AppColors.secodaryText;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: 76,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? selectedBgColor : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                fill: isSelected ? 1 : 0,
                color: isSelected ? selectedTextColor : unselectedTextColor,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? selectedTextColor : unselectedTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
