import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/app/theme/app_spacing.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/core/widgets/app_states.dart';
import 'package:satecho_mobile/core/widgets/status_chip.dart';
import 'package:satecho_mobile/features/irrigation/presentation/pages/irrigation_page.dart';
import 'package:satecho_mobile/features/zones/domain/zone.dart';
import 'package:satecho_mobile/features/zones/presentation/controllers/zones_controller.dart';
import 'package:satecho_mobile/features/zones/presentation/pages/zone_analysis_page.dart';
import 'package:satecho_mobile/features/zones/presentation/widgets/zone_metric_card.dart';

class ZonesPage extends StatefulWidget {
  const ZonesPage({super.key});

  @override
  State<ZonesPage> createState() => _ZonesPageState();
}

class _ZonesPageState extends State<ZonesPage> {
  late final ZonesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AppDependenciesScope.of(context).createZonesController();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final mq = MediaQuery.of(context);
        return RefreshIndicator(
          onRefresh: _controller.load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              mq.padding.top + AppSpacing.md,
              AppSpacing.gutter,
              mq.padding.bottom + 80,
            ),
            children: [
              _Header(onIrrigation: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const IrrigationPage()),
                );
              }),
              AppSpacing.gapLg,
              if (_controller.isLoading)
                const AppLoadingState()
              else if (_controller.errorMessage != null)
                AppErrorState(
                  message: _controller.errorMessage!,
                  onRetry: _controller.load,
                )
              else if (_controller.zones.isEmpty)
                const AppEmptyState(
                  icon: Icons.landscape_outlined,
                  title: 'Aún no hay zonas',
                  message: 'Las zonas de tu propiedad aparecerán aquí cuando estén configuradas.',
                )
              else
                ..._controller.zones.map(
                  (zone) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: _ZoneCard(
                      zone: zone,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ZoneAnalysisPage(zoneId: zone.id),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onIrrigation});

  final VoidCallback onIrrigation;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Zonas de tu propiedad',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Monitoreo de suelo por zona',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 44,
          child: OutlinedButton.icon(
            onPressed: onIrrigation,
            icon: const Icon(Icons.water_drop_outlined, size: 18),
            label: const Text('Riego'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.info,
              side: const BorderSide(color: AppColors.infoSoft),
              shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.buttonBr),
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            ),
          ),
        ),
      ],
    );
  }
}

class _ZoneCard extends StatelessWidget {
  const _ZoneCard({required this.zone, required this.onTap});

  final Zone zone;
  final VoidCallback onTap;

  StatusTone _toneFromRisk(String risk) {
    final lower = risk.toLowerCase();
    if (lower.contains('critical')) return StatusTone.danger;
    if (lower.contains('high') || lower.contains('low')) return StatusTone.warning;
    return StatusTone.success;
  }

  @override
  Widget build(BuildContext context) {
    final displayMetrics =
        zone.metrics.take(4).toList();

    return Material(
      color: Colors.transparent,
      borderRadius: AppRadius.cardBr,
      child: InkWell(
        borderRadius: AppRadius.cardBr,
        onTap: onTap,
        child: AppCard(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          zone.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          zone.crop,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusChip(label: zone.risk, tone: _toneFromRisk(zone.risk)),
                ],
              ),
              if (displayMetrics.isNotEmpty) ...[
                AppSpacing.gapMd,
                Row(
                  children: displayMetrics
                      .expand((metric) => [
                            Expanded(
                                child:
                                    ZoneMetricCard(metric: metric)),
                            if (metric != displayMetrics.last)
                              const SizedBox(width: AppSpacing.sm),
                          ])
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
