import 'package:flutter/material.dart';

import '../../../../app/di/mock_dependencies.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../farms/presentation/pages/estate_detail_page.dart';
import '../controllers/agronomist_alerts_controller.dart';

class AgronomistAlertsPage extends StatefulWidget {
  const AgronomistAlertsPage({super.key});

  @override
  State<AgronomistAlertsPage> createState() => _AgronomistAlertsPageState();
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
        final critical =
            _controller.alerts.where((a) => a.severity == 'critical').toList();
        final attention =
            _controller.alerts.where((a) => a.severity != 'critical').toList();
        return ListView(
          padding: const EdgeInsets.fromLTRB(28, 34, 28, 118),
          children: [
            const Text('Alerts',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                )),
            const SizedBox(height: 6),
            Text('Showing ${_controller.alerts.length + 2} active alerts',
                style: const TextStyle(color: AppColors.muted, fontSize: 14)),
            const SizedBox(height: 20),
            if (_controller.isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              _SectionTitle(
                  label: 'CRITICAL (${critical.length})',
                  color: AppColors.danger,
                  icon: Icons.error),
              ...critical.map(
                  (alert) => _AgronomistAlertCard(alert: alert, critical: true)),
              const SizedBox(height: 18),
              _SectionTitle(
                  label: 'ATENCI\u00D3N (${attention.length + 2})',
                  color: const Color(0xFF9B5A3E),
                  icon: Icons.warning),
              ...attention.map((alert) =>
                  _AgronomistAlertCard(alert: alert, critical: false)),
            ],
          ],
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
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w800, fontSize: 14)),
        ],
      ),
    );
  }
}

class _AgronomistAlertCard extends StatelessWidget {
  const _AgronomistAlertCard({required this.alert, required this.critical});

  final dynamic alert;
  final bool critical;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: AppCard(
        border: Border(
            left: BorderSide(
                color: critical ? AppColors.danger : const Color(0xFFC98366),
                width: 4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${alert.farmName} \u2022 ${alert.zoneName}',
                style: const TextStyle(color: AppColors.muted, fontSize: 13)),
            const SizedBox(height: 6),
            Text(alert.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(alert.timeLabel,
                style: const TextStyle(color: AppColors.text, fontSize: 14)),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const EstateDetailPage(farmId: 'farm-1'))),
                style: FilledButton.styleFrom(
                    backgroundColor:
                        critical ? const Color(0xFF80A482) : AppColors.surface,
                    foregroundColor: AppColors.text,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    textStyle: const TextStyle(fontSize: 14)),
                child: const Text('View property'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
