import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_spacing.dart';
import 'package:satecho_mobile/core/widgets/app_states.dart';
import 'package:satecho_mobile/features/notifications/presentation/controllers/alerts_controller.dart';
import 'package:satecho_mobile/features/notifications/presentation/pages/notifications_screen.dart';
import 'package:satecho_mobile/features/notifications/presentation/widgets/alert_card.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({this.externalController, super.key});

  final AlertsController? externalController;

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  late final AlertsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.externalController ??
        AppDependenciesScope.of(context).createAlertsController();
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
              Row(
                children: [
                  Expanded(
                    child: Text('Alertas',
                        style: Theme.of(context).textTheme.headlineLarge),
                  ),
                  IconButton(
                    icon: const Icon(Icons.history),
                    tooltip: 'Historial de notificaciones',
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const NotificationsScreen()),
                    ),
                  ),
                ],
              ),
              AppSpacing.gapLg,
              if (_controller.isLoading)
                const AppLoadingState()
              else if (_controller.alerts.isEmpty)
                const AppEmptyState(
                  icon: Icons.notifications_off_outlined,
                  title: 'Sin alertas activas',
                  message: 'No hay alertas pendientes en este momento.',
                )
              else
                ..._controller.alerts.map(
                  (alert) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: AlertCard(
                      alert: alert,
                      onViewPlot: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              _AlertDetailPage(alertId: alert.id),
                        ),
                      ),
                      onResolved: () => _controller.resolve(alert.id),
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

class _AlertDetailPage extends StatelessWidget {
  const _AlertDetailPage({required this.alertId});

  final String alertId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Detalle de alerta'),
      ),
      body: Center(
        child: Text('Alerta $alertId',
            style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
