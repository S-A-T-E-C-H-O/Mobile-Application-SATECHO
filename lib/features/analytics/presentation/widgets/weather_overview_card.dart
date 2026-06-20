import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/features/soil_monitoring/presentation/widgets/status_dot.dart';
import 'package:satecho_mobile/features/analytics/domain/farmer_dashboard.dart';

class WeatherOverviewCard extends StatelessWidget {
  const WeatherOverviewCard({required this.dashboard, super.key});

  final FarmerDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.cloud_queue, color: AppColors.primary, size: 48),
              const SizedBox(width: 22),
              Text(
                '${dashboard.weather.temperature}°\n${dashboard.weather.condition}',
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.35,
                  color: AppColors.muted,
                ),
              ),
              const Spacer(),
              if (dashboard.weather.hasAlert)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.dangerSoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: Color(0xFF9B0000),
                        size: 15,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'ALERT',
                        style: TextStyle(
                          color: Color(0xFF9B0000),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              ...dashboard.plots
                  .asMap()
                  .entries
                  .expand((entry) => [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.neutralTile,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StatusDot(status: entry.value.status),
                                const SizedBox(height: 10),
                                Text(
                                  _shortName(entry.value.name),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.muted,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${entry.value.humidity ?? 0}%',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.text,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (entry.key != dashboard.plots.length - 1)
                          const SizedBox(width: 14),
                      ]),
            ],
          ),
        ],
      ),
    );
  }

  String _shortName(String name) {
    final words = name.split(' ');
    if (words.length <= 2) return name;
    return '${words[0]} ${words[1]}';
  }
}
