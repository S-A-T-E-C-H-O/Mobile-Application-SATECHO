import 'package:flutter/material.dart';

import 'package:satecho_mobile/core/widgets/agronomist_bottom_nav.dart';
import 'package:satecho_mobile/features/farms/presentation/pages/clients_page.dart';
import 'package:satecho_mobile/features/field_visits/presentation/pages/agenda_page.dart';
import 'package:satecho_mobile/features/notifications/presentation/pages/agronomist_alerts_page.dart';
import 'package:satecho_mobile/features/user_profile/presentation/pages/more_menu_page.dart';

class AgronomistShell extends StatefulWidget {
  const AgronomistShell({super.key});

  @override
  State<AgronomistShell> createState() => _AgronomistShellState();
}

class _AgronomistShellState extends State<AgronomistShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    const pages = [
      ClientsPage(),
      AgendaPage(),
      AgronomistAlertsPage(),
      MoreMenuPage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: AgronomistBottomNav(
        currentIndex: _currentIndex,
        unreadAlerts: 2,
        pendingVisits: 2,
        onChanged: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
