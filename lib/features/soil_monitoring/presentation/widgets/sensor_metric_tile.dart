import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/sensor_metric.dart';

class SensorMetricTile extends StatelessWidget {
  const SensorMetricTile({required this.metric, super.key});

  final SensorMetric metric;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.neutralTile,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_icon, size: 14, color: _iconColor),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    metric.label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: AppColors.text),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              metric.displayValue,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            if (metric.type == SensorMetricType.humidity) ...[
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: metric.numericValue / 100,
                  minHeight: 5,
                  backgroundColor: AppColors.border,
                  color: const Color(0xFF83A382),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData get _icon {
    return switch (metric.type) {
      SensorMetricType.humidity => Icons.water_drop_outlined,
      SensorMetricType.temperature => Icons.thermostat,
      SensorMetricType.electricalConductivity => Icons.show_chart,
    };
  }

  Color get _iconColor {
    return switch (metric.type) {
      SensorMetricType.humidity => AppColors.primary,
      SensorMetricType.temperature => const Color(0xFFC98366),
      SensorMetricType.electricalConductivity => const Color(0xFF8F45FF),
    };
  }
}
