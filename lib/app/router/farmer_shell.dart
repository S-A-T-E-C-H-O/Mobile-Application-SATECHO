import 'package:flutter/material.dart';

import 'package:satecho_mobile/core/widgets/satecho_bottom_nav.dart';
import 'package:satecho_mobile/features/advisory/presentation/pages/recommendations_page.dart';
import 'package:satecho_mobile/features/analytics/presentation/pages/home_page.dart';
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
