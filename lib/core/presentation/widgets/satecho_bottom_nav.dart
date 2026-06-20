import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class SatechoBottomNav extends StatelessWidget {
  const SatechoBottomNav({
    required this.currentIndex,
    required this.onChanged,
    required this.unreadAlerts,
    super.key,
  });

  final int currentIndex;
  final int unreadAlerts;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const items = [
      _NavItem(Icons.home_outlined, Icons.home, 'Home'),
      _NavItem(Icons.map_outlined, Icons.map, 'Plots'),
      _NavItem(Icons.notifications_none, Icons.notifications, 'Alerts'),
      _NavItem(Icons.assignment_outlined, Icons.assignment, 'Tasks'),
      _NavItem(Icons.person_outline, Icons.person, 'More'),
    ];

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final selected = index == currentIndex;
            return InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: () => onChanged(index),
              child: Container(
                width: 58,
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: selected
                    ? BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(36),
                )
                    : null,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          selected ? item.selectedIcon : item.icon,
                          color: selected ? AppColors.primary : AppColors.muted,
                          size: 28,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: TextStyle(
                            color:
                            selected ? AppColors.primary : AppColors.muted,
                            fontWeight:
                            selected ? FontWeight.w800 : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    if (index == 2 && unreadAlerts > 0)
                      Positioned(
                        right: 6,
                        top: -4,
                        child: Container(
                          width: 21,
                          height: 21,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.danger,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$unreadAlerts',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.icon, this.selectedIcon, this.label);

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
