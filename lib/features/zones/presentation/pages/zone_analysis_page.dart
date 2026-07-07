import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/app/theme/app_spacing.dart';
import 'package:satecho_mobile/core/widgets/app_states.dart';
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

  Future<void> _exportCsv() async {
    final buffer = StringBuffer('timestamp,metric,value\n');
    for (final (metric, _, _) in ZoneAnalysisController.metrics) {
      for (final point in _controller.series[metric] ?? const []) {
        buffer.writeln(
            '${point.timestamp.toIso8601String()},$metric,${point.value}');
      }
    }
    await Share.share(
      buffer.toString(),
      subject: 'Zona ${widget.zoneId} — exportación de tendencias',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final zone = _controller.zone;
          final mq = MediaQuery.of(context);
          return ListView(
            padding: EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                mq.padding.top + AppSpacing.lg,
                AppSpacing.gutter,
                mq.padding.bottom + AppSpacing.lg),
            children: [
              Row(
                children: [
                  Material(
                    color: AppColors.surface,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon:
                          const Icon(Icons.chevron_left, size: 30),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md - 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          zone?.name ?? 'Sector',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium,
                        ),
                        Text(
                          'El Retorno \u2022 ${zone?.areaLabel ?? ''} \u2022 ${zone?.crop ?? ''}',
                          style: const TextStyle(
                              color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Exportar CSV',
                    onPressed: _controller
                            .series.values
                            .any((s) => s.isNotEmpty)
                        ? _exportCsv
                        : null,
                    icon: const Icon(Icons.ios_share),
                  ),
                ],
              ),
              AppSpacing.gapLg,
              _PeriodTabs(
                  index: _controller.periodIndex,
                  onChanged: _controller.setPeriod),
              AppSpacing.gapMd,
              if (_controller.isLoading || zone == null)
                const AppLoadingState()
              else ...[
                GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.35,
                  mainAxisSpacing: AppSpacing.sm + 2,
                  crossAxisSpacing: AppSpacing.sm + 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (final metric in zone.metrics)
                      ZoneMetricCard(metric: metric)
                  ],
                ),
                AppSpacing.gapMd,
                for (final (metric, label, unit)
                    in ZoneAnalysisController.metrics) ...[
                  TrendChartCard(
                    title: label,
                    color: AppColors.primary,
                    points:
                        _controller.series[metric] ?? const [],
                    unit: unit,
                  ),
                  AppSpacing.gapMd,
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
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.neutralTile,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm + 3),
                  decoration: BoxDecoration(
                    color: i == index
                        ? const Color(0xFF80A482)
                        : Colors.transparent,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.xs + 2),
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
