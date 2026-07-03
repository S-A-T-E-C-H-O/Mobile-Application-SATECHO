import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/features/irrigation/presentation/pages/irrigation_page.dart';
import 'package:satecho_mobile/features/notifications/presentation/controllers/alerts_controller.dart';
import 'package:satecho_mobile/features/notifications/presentation/pages/notifications_screen.dart';
import 'package:satecho_mobile/features/notifications/presentation/widgets/alert_card.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  late final AlertsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AppDependenciesScope.of(context).createAlertsController();
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
        return ListView(
          padding: EdgeInsets.fromLTRB(
              20, mq.padding.top + 16, 20, mq.padding.bottom + 80),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Alerts',
                    style: Theme.of(context).textTheme.headlineLarge),
                IconButton(
                  icon: const Icon(Icons.history),
                  tooltip: 'Notification history',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const NotificationsScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 34),
            if (_controller.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_controller.alerts.isEmpty)
              const Text('No active alerts')
            else
              ..._controller.alerts.map(
                (alert) => Padding(
                  padding: const EdgeInsets.only(bottom: 22),
                  child: AlertCard(
                    alert: alert,
                    onViewPlot: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            IrrigationPage(initialPlotId: alert.plotId),
                      ),
                    ),
                    onResolved: () => _controller.resolve(alert.id),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
