import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/features/activity_log/presentation/pages/record_activity_page.dart';
import 'package:satecho_mobile/features/devices/presentation/pages/device_status_page.dart';
import 'package:satecho_mobile/features/irrigation/presentation/pages/irrigation_page.dart';
import 'package:satecho_mobile/features/notifications/domain/alert_severity.dart';
import 'package:satecho_mobile/features/analytics/domain/farmer_dashboard.dart';
import 'package:satecho_mobile/features/analytics/presentation/controllers/dashboard_controller.dart';
import 'package:satecho_mobile/features/analytics/presentation/widgets/quick_action_card.dart';
import 'package:satecho_mobile/features/analytics/presentation/widgets/weather_overview_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.onOpenAlerts, super.key});

  final VoidCallback onOpenAlerts;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _KpiRow extends StatelessWidget {
  const _KpiRow({required this.kpis});
  final FarmerKpis kpis;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _KpiChip(
          icon: Icons.crop_square_outlined,
          label: '${kpis.totalZones}',
          sublabel: 'Zones',
          color: AppColors.primary,
        ),
        const SizedBox(width: 10),
        _KpiChip(
          icon: Icons.sensors,
          label: '${kpis.onlineDevices}',
          sublabel: 'Online',
          color: const Color(0xFF2E7D32),
        ),
        const SizedBox(width: 10),
        _KpiChip(
          icon: Icons.sensors_off_outlined,
          label: '${kpis.offlineDevices}',
          sublabel: 'Offline',
          color: AppColors.muted,
        ),
        const SizedBox(width: 10),
        _KpiChip(
          icon: Icons.warning_amber,
          label: '${kpis.criticalAlerts}',
          sublabel: 'Alerts',
          color: AppColors.danger,
        ),
      ],
    );
  }
}

/// EP-012-US023: 7-day averages + weekly irrigation hours, with a critical
/// visual indicator when the 7-day average moisture drops below 25%.
class _CropHealthRow extends StatelessWidget {
  const _CropHealthRow({required this.kpis});
  final FarmerKpis kpis;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _KpiChip(
          icon: Icons.water_drop_outlined,
          label: kpis.avgMoisture7d != null
              ? '${kpis.avgMoisture7d!.toStringAsFixed(0)}%'
              : '-',
          sublabel: '7d moisture',
          color: kpis.criticalMoisture ? AppColors.danger : AppColors.primary,
        ),
        const SizedBox(width: 10),
        _KpiChip(
          icon: Icons.bolt_outlined,
          label: kpis.avgEc7d != null ? kpis.avgEc7d!.toStringAsFixed(1) : '-',
          sublabel: '7d EC',
          color: AppColors.primary,
        ),
        const SizedBox(width: 10),
        _KpiChip(
          icon: Icons.timer_outlined,
          label: kpis.weeklyIrrigationHours != null
              ? '${kpis.weeklyIrrigationHours!.toStringAsFixed(1)}h'
              : '-',
          sublabel: 'Irrigation/wk',
          color: AppColors.primary,
        ),
      ],
    );
  }
}

class _KpiChip extends StatelessWidget {
  const _KpiChip({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E4DF)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800, color: color)),
              Text(sublabel,
                  style: const TextStyle(fontSize: 10, color: AppColors.muted)),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  late final DashboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AppDependenciesScope.of(context).createDashboardController();
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
        final dashboard = _controller.dashboard;
        return RefreshIndicator(
          onRefresh: _controller.load,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).padding.top + 16,
                20,
                MediaQuery.of(context).padding.bottom + 80),
            children: [
              if (_controller.isOffline)
                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.neutralTile,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.cloud_off_outlined,
                          color: AppColors.muted, size: 18),
                      SizedBox(width: 8),
                      Text('Offline mode — showing last saved data',
                          style:
                              TextStyle(color: AppColors.muted, fontSize: 13)),
                    ],
                  ),
                ),
              if (_controller.isLoading || dashboard == null)
                const Center(child: CircularProgressIndicator())
              else ...[
                Text(
                  dashboard.greeting,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  dashboard.farmName,
                  style: const TextStyle(fontSize: 22, color: AppColors.muted),
                ),
                const SizedBox(height: 24),
                WeatherOverviewCard(dashboard: dashboard),
                if (dashboard.kpis != null) ...[
                  const SizedBox(height: 16),
                  _KpiRow(kpis: dashboard.kpis!),
                  const SizedBox(height: 10),
                  _CropHealthRow(kpis: dashboard.kpis!),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    QuickActionCard(
                      icon: Icons.water_drop_outlined,
                      title: 'See irrigation\nQuick Control',
                      filled: true,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const IrrigationPage()),
                      ),
                    ),
                    const SizedBox(width: 24),
                    QuickActionCard(
                      icon: Icons.sensors,
                      title: 'Device\nStatus',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const DeviceStatusPage()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    QuickActionCard(
                      icon: Icons.add,
                      title: 'Register\nActivity',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const RecordActivityPage()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Upcoming irrigation',
                        style: TextStyle(fontSize: 22, color: AppColors.text),
                      ),
                      const SizedBox(height: 20),
                      ...dashboard.upcomingIrrigations
                          .asMap()
                          .entries
                          .expand((entry) => [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: entry.value.highlighted
                                        ? const Color(0xFFDCE5F7)
                                        : AppColors.border,
                                    child: const Icon(Icons.schedule,
                                        color: AppColors.muted),
                                  ),
                                  title: Text(
                                    entry.value.plotName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.text,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${entry.value.scheduleLabel} \u2022 ${entry.value.durationMinutes} min',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                  trailing: const Icon(Icons.chevron_right,
                                      color: AppColors.border),
                                ),
                                if (entry.key !=
                                    dashboard.upcomingIrrigations.length - 1)
                                  const SizedBox(height: 18),
                              ]),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: widget.onOpenAlerts,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7F5),
                      border: Border.all(color: const Color(0xFFFFC9C3)),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 26,
                          backgroundColor: AppColors.danger,
                          child: Icon(Icons.warning_amber,
                              color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 22),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${dashboard.activeAlerts.where(
                                      (alert) =>
                                          alert.severity != AlertSeverity.info,
                                    ).length} active alerts',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF9B0000),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'They require attention',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.danger,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            color: AppColors.danger, size: 34),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
