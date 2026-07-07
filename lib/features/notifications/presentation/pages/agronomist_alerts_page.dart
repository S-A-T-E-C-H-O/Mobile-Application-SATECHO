import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/app/theme/app_spacing.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/core/widgets/app_states.dart';
import 'package:satecho_mobile/core/widgets/status_chip.dart';
import 'package:satecho_mobile/features/farms/presentation/pages/estate_detail_page.dart';
import 'package:satecho_mobile/features/notifications/presentation/controllers/agronomist_alerts_controller.dart';

class AgronomistAlertsPage extends StatefulWidget {
  const AgronomistAlertsPage({super.key});

  @override
  State<AgronomistAlertsPage> createState() =>
      _AgronomistAlertsPageState();
}

class _AgronomistAlertsPageState extends State<AgronomistAlertsPage> {
  late final AgronomistAlertsController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AppDependenciesScope.of(context).createAgronomistAlertsController();
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
        final critical = _controller.alerts
            .where((a) => a.severity == 'critical')
            .toList();
        final attention = _controller.alerts
            .where((a) => a.severity != 'critical')
            .toList();
        final mq = MediaQuery.of(context);
        return RefreshIndicator(
          onRefresh: () => _controller.load(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              mq.padding.top + AppSpacing.md,
              AppSpacing.gutter,
              mq.padding.bottom + 80,
            ),
            children: [
              const Text('Alertas',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  )),
              const SizedBox(height: AppSpacing.xs),
              Text(
                  '${_controller.alerts.length} alertas activas',
                  style: const TextStyle(
                      color: AppColors.muted, fontSize: 14)),
              AppSpacing.gapLg,
              if (_controller.isLoading)
                const AppLoadingState()
              else ...[
                _SectionTitle(
                    label: 'CRÍTICAS (${critical.length})',
                    color: AppColors.danger,
                    icon: Icons.error),
                ...critical.map((alert) => _AgronomistAlertCard(
                    alert: alert, critical: true)),
                AppSpacing.gapMd,
                _SectionTitle(
                    label: 'ATENCIÓN (${attention.length})',
                    color: const Color(0xFF9B5A3E),
                    icon: Icons.warning),
                ...attention.map((alert) => _AgronomistAlertCard(
                    alert: alert, critical: false)),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(
      {required this.label, required this.color, required this.icon});

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm + 2),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 14)),
        ],
      ),
    );
  }
}

class _AgronomistAlertCard extends StatelessWidget {
  const _AgronomistAlertCard(
      {required this.alert, required this.critical});

  final dynamic alert;
  final bool critical;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        border: Border(
            left: BorderSide(
                color: critical
                    ? AppColors.danger
                    : const Color(0xFFC98366),
                width: 4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                      '${alert.farmName} \u2022 ${alert.zoneName}',
                      style: const TextStyle(
                          color: AppColors.muted, fontSize: 13)),
                ),
                StatusChip(
                  label: critical ? 'Crítica' : 'Atención',
                  tone:
                      critical ? StatusTone.danger : StatusTone.warning,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs + 2),
            Text(alert.title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.xs + 2),
            Text(alert.timeLabel,
                style: const TextStyle(
                    color: AppColors.text, fontSize: 14)),
            const SizedBox(height: AppSpacing.sm + 2),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const EstateDetailPage(
                            farmId: 'farm-1'))),
                style: FilledButton.styleFrom(
                    backgroundColor: critical
                        ? const Color(0xFF80A482)
                        : AppColors.surface,
                    foregroundColor: AppColors.text,
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm + 2,
                        horizontal: AppSpacing.md),
                    textStyle: const TextStyle(fontSize: 14)),
                child: const Text('Ver propiedad'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
