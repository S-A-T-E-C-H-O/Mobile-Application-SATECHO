import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/features/zones/domain/zone_metric.dart';

class ZoneMetricCard extends StatelessWidget {
  const ZoneMetricCard({required this.metric, super.key});

  final ZoneMetric metric;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_icon, color: _color, size: 18),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  metric.label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.muted, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              text: metric.value,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
              children: [
                TextSpan(
                  text: metric.unit,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData get _icon {
    return switch (metric.label) {
      'Humidity' => Icons.water_drop_outlined,
      'EC' => Icons.bolt_outlined,
      'Temperature' => Icons.thermostat,
      'Rain' => Icons.cloudy_snowing,
      _ => Icons.analytics_outlined,
    };
  }

  Color get _color {
    return switch (metric.label) {
      'Temperature' => const Color(0xFF9B5A3E),
      'EC' => AppColors.muted,
      _ => AppColors.primary,
    };
  }
}
