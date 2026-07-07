import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/features/billing/presentation/pages/subscription_page.dart';
import 'package:satecho_mobile/features/notifications/presentation/pages/notification_preferences_page.dart';

class AgronomistSettingsPage extends StatelessWidget {
  const AgronomistSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(28, 34, 28, 112),
        children: [
          Row(
            children: [
              Material(
                color: AppColors.surface,
                shape: const CircleBorder(),
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.chevron_left, size: 30),
                ),
              ),
              const SizedBox(width: 14),
              Text('Settings',
                  style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 26),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingsTile(
                  title: 'Notifications',
                  value: 'All active',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const NotificationPreferencesPage(),
                    ),
                  ),
                ),
                _SettingsTile(
                  title: 'Subscription',
                  value: 'Active',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SubscriptionPage(),
                    ),
                  ),
                ),
                const _SettingsTile(title: 'Language', value: 'English'),
                const _SettingsTile(title: 'Theme', value: 'System'),
                const _SettingsTile(title: 'Privacy', value: 'Standard'),
                const _SettingsTile(title: 'Data sync', value: 'Automatic'),
                const _SettingsTile(
                    title: 'Alert preferences', value: 'Critical + Attention'),
              ],
            ),
          ),
          const SizedBox(height: 28),
          OutlinedButton.icon(
            onPressed: () =>
                AppDependenciesScope.of(context).sessionManager.logout(),
            icon: const Icon(Icons.logout),
            label: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    required this.value,
    this.onTap,
  });

  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(color: AppColors.muted)),
          const Icon(Icons.chevron_right, color: AppColors.muted),
        ],
      ),
    );
  }
}
