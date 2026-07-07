import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/core/widgets/satecho_bottom_nav.dart';
import 'package:satecho_mobile/features/advisory/presentation/pages/recommendations_page.dart';
import 'package:satecho_mobile/features/analytics/presentation/pages/home_page.dart';
import 'package:satecho_mobile/features/notifications/presentation/controllers/alerts_controller.dart';
import 'package:satecho_mobile/features/notifications/presentation/pages/alerts_page.dart';
import 'package:satecho_mobile/features/soil_monitoring/presentation/pages/plots_page.dart';
import 'package:satecho_mobile/features/user_profile/presentation/pages/profile_page.dart';

class FarmerShell extends StatefulWidget {
  const FarmerShell({super.key});

  @override
  State<FarmerShell> createState() => _FarmerShellState();
}

class _FarmerShellState extends State<FarmerShell> {
  int _currentIndex = 0;
  bool _mqttConnectRequested = false;
  late final AlertsController _alertsController;

  @override
  void initState() {
    super.initState();
    _alertsController =
        AppDependenciesScope.of(context).createAlertsController();
    _alertsController.load();
    _alertsController.addListener(_onAlertsChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_mqttConnectRequested) {
      _mqttConnectRequested = true;
      AppDependenciesScope.of(context).mqttService?.connect();
    }
  }

  @override
  void dispose() {
    _alertsController.removeListener(_onAlertsChanged);
    _alertsController.dispose();
    super.dispose();
  }

  void _onAlertsChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onOpenAlerts: () => setState(() => _currentIndex = 2)),
      const PlotsPage(),
      AlertsPage(externalController: _alertsController),
      const RecommendationsPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: SatechoBottomNav(
        currentIndex: _currentIndex,
        unreadAlerts: _alertsController.unreadCount,
        onChanged: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
