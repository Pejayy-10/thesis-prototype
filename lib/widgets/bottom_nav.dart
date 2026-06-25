import 'package:flutter/material.dart';
import '../core/theme.dart';

final ValueNotifier<int> globalNavIndex = ValueNotifier<int>(0);

class WoodConNetBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const WoodConNetBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(left: 32, right: 32, bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary, // Dark green navbar
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Sliding Active Background (White Pill)
            Positioned.fill(
              child: AnimatedAlign(
                alignment: Alignment(-1.0 + (currentIndex * (2.0 / 3.0)), 0),
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Icons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavItem(
                  activeIcon: Icons.camera_alt_rounded,
                  inactiveIcon: Icons.camera_alt_outlined,
                  index: 0,
                  current: currentIndex,
                  onTap: onTap,
                ),
                _NavItem(
                  activeIcon: Icons.history_rounded,
                  inactiveIcon: Icons.history_rounded,
                  index: 1,
                  current: currentIndex,
                  onTap: onTap,
                ),
                _NavItem(
                  activeIcon: Icons.menu_book_rounded,
                  inactiveIcon: Icons.menu_book_outlined,
                  index: 2,
                  current: currentIndex,
                  onTap: onTap,
                ),
                _NavItem(
                  activeIcon: Icons.settings_rounded,
                  inactiveIcon: Icons.settings_outlined,
                  index: 3,
                  current: currentIndex,
                  onTap: onTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final int index;
  final int current;
  final Function(int) onTap;

  const _NavItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 48,
        height: 48,
        color: Colors.transparent, // Ensures the whole area is tappable
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: Icon(
            isActive ? activeIcon : inactiveIcon,
            key: ValueKey<bool>(isActive),
            size: 24,
            // Active: Green icon on White pill
            // Inactive: White icon on Green navbar
            color: isActive ? AppColors.primary : Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}

