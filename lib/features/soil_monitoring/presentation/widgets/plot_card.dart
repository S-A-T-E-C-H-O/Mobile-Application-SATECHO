import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/plot.dart';
import 'sensor_metric_tile.dart';
import 'status_dot.dart';

class PlotCard extends StatelessWidget {
  const PlotCard({required this.plot, required this.onTap, super.key});

  final Plot plot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final expanded = plot.metrics.length > 1;
    final indexed = plot.metrics.asMap().entries.toList();
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border:
            expanded ? Border.all(color: AppColors.primary, width: 1.2) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: [
                      Text(
                        plot.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                        ),
                      ),
                      StatusDot(status: plot.status),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right,
                    color: AppColors.muted, size: 24),
              ],
            ),
            Text(
              '${plot.crop} \u2022 ${plot.lastActivityLabel}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: AppColors.text),
            ),
            if (expanded) ...[
              const SizedBox(height: 16),
              Row(
                children: indexed
                    .expand((entry) => [
                          SensorMetricTile(metric: entry.value),
                          if (entry.key != plot.metrics.length - 1)
                            const SizedBox(width: 10),
                        ])
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
