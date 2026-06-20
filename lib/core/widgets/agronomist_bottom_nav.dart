import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';

class AgronomistBottomNav extends StatelessWidget {
  const AgronomistBottomNav({
    required this.currentIndex,
    required this.onChanged,
    required this.unreadAlerts,
    required this.pendingVisits,
    super.key,
  });

  final int currentIndex;
  final int unreadAlerts;
  final int pendingVisits;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const items = [
      _AgronomistNavItem(Icons.groups_outlined, Icons.groups, 'Clients'),
      _AgronomistNavItem(
          Icons.calendar_today_outlined, Icons.calendar_today, 'Agenda'),
      _AgronomistNavItem(
          Icons.notifications_none, Icons.notifications, 'Alerts'),
      _AgronomistNavItem(Icons.more_horiz, Icons.more_horiz, 'More'),
    ];

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 10),
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
            final badge = index == 1
                ? pendingVisits
                : index == 2
                ? unreadAlerts
                : 0;
            return InkWell(
              borderRadius: BorderRadius.circular(36),
              onTap: () => onChanged(index),
              child: Container(
                width: 64,
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: selected
                    ? BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(34),
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
                          size: 26,
                          color: selected ? AppColors.primary : AppColors.muted,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: TextStyle(
                            color:
                            selected ? AppColors.primary : AppColors.muted,
                            fontWeight:
                            selected ? FontWeight.w800 : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    if (badge > 0)
                      Positioned(
                        right: 8,
                        top: -3,
                        child: Container(
                          width: 19,
                          height: 19,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.danger,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$badge',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
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

class _AgronomistNavItem {
  const _AgronomistNavItem(this.icon, this.selectedIcon, this.label);

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
