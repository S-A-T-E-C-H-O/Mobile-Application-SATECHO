import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/features/zones/domain/soil_reading_point.dart';

/// Real historical series rendered with fl_chart (EP-004-US005 / EP-012-US022).
/// Tapping a point shows its exact value + timestamp via fl_chart's touch
/// tooltip, satisfying the "data record selection" acceptance scenario.
class TrendChartCard extends StatelessWidget {
  const TrendChartCard({
    required this.title,
    required this.color,
    required this.points,
    this.unit = '',
    super.key,
  });

  final String title;
  final Color color;
  final List<SoilReadingPoint> points;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: SizedBox(
        height: 190,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 16, color: AppColors.text)),
            const SizedBox(height: 8),
            Expanded(
              child: points.isEmpty
                  ? const Center(
                      child: Text('No data for this period',
                          style: TextStyle(color: AppColors.muted)))
                  : LineChart(_buildData()),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _buildData() {
    final spots = [
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].value),
    ];
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 34),
        ),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: (points.length / 3).clamp(1, double.infinity).toDouble(),
            getTitlesWidget: (value, meta) {
              final idx = value.round();
              if (idx < 0 || idx >= points.length) return const SizedBox.shrink();
              final ts = points[idx].timestamp;
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('${ts.month}/${ts.day}',
                    style: const TextStyle(
                        color: AppColors.muted, fontSize: 10)),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (spots) => spots.map((s) {
            final idx = s.x.round();
            if (idx < 0 || idx >= points.length) return null;
            final p = points[idx];
            return LineTooltipItem(
              '${p.value.toStringAsFixed(1)}$unit\n'
              '${p.timestamp.hour.toString().padLeft(2, '0')}:'
              '${p.timestamp.minute.toString().padLeft(2, '0')}',
              const TextStyle(color: Colors.white, fontSize: 12),
            );
          }).toList(),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: color,
          barWidth: 3,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: true, color: color.withValues(alpha: 0.12)),
        ),
      ],
    );
  }
}
