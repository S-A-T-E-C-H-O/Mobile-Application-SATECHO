import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../domain/entities/farm_alert.dart';
import '../../domain/value_objects/alert_severity.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({
    required this.alert,
    required this.onViewPlot,
    required this.onResolved,
    super.key,
  });

  final FarmAlert alert;
  final VoidCallback onViewPlot;
  final VoidCallback onResolved;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration:
                    BoxDecoration(color: _color, shape: BoxShape.circle),
                child: Icon(_icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.25,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${alert.plotName} • ${alert.timeLabel}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF404740),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: onViewPlot,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.darkButton,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:
                      const Text('View plot', style: TextStyle(fontSize: 14)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: OutlinedButton(
                  onPressed: onResolved,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.text,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Mark resolved',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color get _color {
    return switch (alert.severity) {
      AlertSeverity.critical => AppColors.danger,
      AlertSeverity.warning => AppColors.warning,
      AlertSeverity.info => AppColors.info,
    };
  }

  IconData get _icon {
    return switch (alert.severity) {
      AlertSeverity.critical => Icons.warning_amber,
      AlertSeverity.warning => Icons.warning_amber,
      AlertSeverity.info => Icons.info_outline,
    };
  }
}
