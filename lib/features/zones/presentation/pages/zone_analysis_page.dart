import 'package:flutter/material.dart';

import '../../../../app/di/mock_dependencies.dart';
import '../../../../app/theme/app_colors.dart';
import '../controllers/zone_analysis_controller.dart';
import '../widgets/trend_chart_card.dart';
import '../widgets/zone_metric_card.dart';

class ZoneAnalysisPage extends StatefulWidget {
  const ZoneAnalysisPage({required this.zoneId, super.key});

  final String zoneId;

  @override
  State<ZoneAnalysisPage> createState() => _ZoneAnalysisPageState();
}

class _ZoneAnalysisPageState extends State<ZoneAnalysisPage> {
  late final ZoneAnalysisController _controller;
  int _periodIndex = 1;

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
                  const CircleAvatar(
                      radius: 6, backgroundColor: Color(0xFFC98366)),
                ],
              ),
              const SizedBox(height: 24),
              _PeriodTabs(
                  index: _periodIndex,
                  onChanged: (i) => setState(() => _periodIndex = i)),
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
                const TrendChartCard(
                    title: 'Humidity', color: AppColors.primary, rising: false),
                const SizedBox(height: 18),
                const TrendChartCard(
                    title: 'Electrical Conductivity (EC)',
                    color: AppColors.muted,
                    rising: true),
                const SizedBox(height: 18),
                const TrendChartCard(
                    title: 'Temperature',
                    color: Color(0xFF9B5A3E),
                    rising: true),
                const SizedBox(height: 18),
                const TrendChartCard(
                    title: 'Rainfall (mm)',
                    color: AppColors.info,
                    rising: false),
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
    const labels = ['24h', '7d', '30d'];
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
