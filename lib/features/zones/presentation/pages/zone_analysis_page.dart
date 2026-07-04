import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/features/zones/presentation/controllers/zone_analysis_controller.dart';
import 'package:satecho_mobile/features/zones/presentation/widgets/trend_chart_card.dart';
import 'package:satecho_mobile/features/zones/presentation/widgets/zone_metric_card.dart';

class ZoneAnalysisPage extends StatefulWidget {
  const ZoneAnalysisPage({required this.zoneId, super.key});

  final String zoneId;

  @override
  State<ZoneAnalysisPage> createState() => _ZoneAnalysisPageState();
}

class _ZoneAnalysisPageState extends State<ZoneAnalysisPage> {
  late final ZoneAnalysisController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AppDependenciesScope.of(context).createZoneAnalysisController();
    _controller.load(widget.zoneId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// EP-009-US007 Scenario 2: export the currently loaded series as CSV.
  Future<void> _exportCsv() async {
    final buffer = StringBuffer('timestamp,metric,value\n');
    for (final (metric, _, _) in ZoneAnalysisController.metrics) {
      for (final point in _controller.series[metric] ?? const []) {
        buffer.writeln('${point.timestamp.toIso8601String()},$metric,${point.value}');
      }
    }
    await Share.share(
      buffer.toString(),
      subject: 'Zone ${widget.zoneId} trend export',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final zone = _controller.zone;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 36, 20, 34),
            children: [
              Row(
                children: [
                  Material(
                    color: AppColors.surface,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.chevron_left, size: 30),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          zone?.name ?? 'Sector',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          'El Retorno • ${zone?.areaLabel ?? ''} • ${zone?.crop ?? ''}',
                          style: const TextStyle(color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Export CSV',
                    onPressed: _controller.series.values.any((s) => s.isNotEmpty)
                        ? _exportCsv
                        : null,
                    icon: const Icon(Icons.ios_share),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _PeriodTabs(
                  index: _controller.periodIndex,
                  onChanged: _controller.setPeriod),
              const SizedBox(height: 16),
              if (_controller.isLoading || zone == null)
                const Center(child: CircularProgressIndicator())
              else ...[
                GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.35,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (final metric in zone.metrics)
                      ZoneMetricCard(metric: metric)
                  ],
                ),
                const SizedBox(height: 18),
                for (final (metric, label, unit)
                    in ZoneAnalysisController.metrics) ...[
                  TrendChartCard(
                    title: label,
                    color: AppColors.primary,
                    points: _controller.series[metric] ?? const [],
                    unit: unit,
                  ),
                  const SizedBox(height: 18),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}

class _PeriodTabs extends StatelessWidget {
  const _PeriodTabs({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = ['24h', '7d', '30d', '90d'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.neutralTile,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  decoration: BoxDecoration(
                    color: i == index
                        ? const Color(0xFF80A482)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(labels[i]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
