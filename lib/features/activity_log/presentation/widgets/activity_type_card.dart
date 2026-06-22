import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/features/activity_log/domain/activity_type.dart';

class ActivityTypeCard extends StatelessWidget {
  const ActivityTypeCard({
    required this.type,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final ActivityType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        border:
            selected ? Border.all(color: AppColors.primary, width: 2) : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_icon, color: AppColors.primary, size: 30),
            const SizedBox(height: 10),
            Text(
              type.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData get _icon {
    return switch (type) {
      ActivityType.manualWatering => Icons.water_drop_outlined,
      ActivityType.fertilizer => Icons.eco_outlined,
      ActivityType.pestControl => Icons.bug_report_outlined,
      ActivityType.observation => Icons.description_outlined,
    };
  }
}
