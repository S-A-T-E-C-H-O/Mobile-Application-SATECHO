import 'package:flutter/material.dart';

import '../../core/presentation/widgets/satecho_bottom_nav.dart';
import '../../features/advisory/presentation/pages/recommendations_page.dart';
import '../../features/analytics/presentation/pages/home_page.dart';
import '../../features/notifications/presentation/pages/alerts_page.dart';
import '../../features/soil_monitoring/presentation/pages/plots_page.dart';
import '../../features/user_profile/presentation/pages/profile_page.dart';

class FarmerShell extends StatefulWidget {
  const FarmerShell({super.key});

  @override
  State<FarmerShell> createState() => _FarmerShellState();
}

class _FarmerShellState extends State<FarmerShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onOpenAlerts: () => setState(() => _currentIndex = 2)),
      const PlotsPage(),
      const AlertsPage(),
      const RecommendationsPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: SatechoBottomNav(
        currentIndex: _currentIndex,
        unreadAlerts: 2,
        onChanged: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
