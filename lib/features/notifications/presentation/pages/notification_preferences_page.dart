import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/features/notifications/presentation/controllers/notification_preferences_controller.dart';

class NotificationPreferencesPage extends StatefulWidget {
  const NotificationPreferencesPage({super.key});

  @override
  State<NotificationPreferencesPage> createState() =>
      _NotificationPreferencesPageState();
}

class _NotificationPreferencesPageState
    extends State<NotificationPreferencesPage> {
  late final NotificationPreferencesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AppDependenciesScope.of(context)
        .createNotificationPreferencesController();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return ListView(
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
                  Text('Notification preferences',
                      style: Theme.of(context).textTheme.headlineMedium),
                ],
              ),
              const SizedBox(height: 26),
              if (_controller.isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                _PreferenceTile(
                  icon: Icons.water_drop_outlined,
                  title: 'Irrigation alerts',
                  subtitle: 'Irrigation start, stop and anomalies',
                  value: _controller.irrigationAlerts,
                  onChanged: (v) => _controller.irrigationAlerts = v,
                ),
                _PreferenceTile(
                  icon: Icons.grass_outlined,
                  title: 'Soil alerts',
                  subtitle: 'Humidity, salinity and pH thresholds',
                  value: _controller.soilAlerts,
                  onChanged: (v) => _controller.soilAlerts = v,
                ),
                _PreferenceTile(
                  icon: Icons.security_outlined,
                  title: 'Security alerts',
                  subtitle: 'Motion detection and perimeter events',
                  value: _controller.securityAlerts,
                  onChanged: (v) => _controller.securityAlerts = v,
                ),
                _PreferenceTile(
                  icon: Icons.cloud_outlined,
                  title: 'Weather alerts',
                  subtitle: 'Rain, frost and extreme temperatures',
                  value: _controller.weatherAlerts,
                  onChanged: (v) => _controller.weatherAlerts = v,
                ),
                _PreferenceTile(
                  icon: Icons.notifications_none,
                  title: 'System alerts',
                  subtitle: 'Device status and connectivity issues',
                  value: _controller.systemAlerts,
                  onChanged: (v) => _controller.systemAlerts = v,
                ),
                const SizedBox(height: 16),
                if (_controller.feedbackMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _controller.feedbackMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _controller.isError
                            ? AppColors.danger
                            : AppColors.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                FilledButton(
                  onPressed: _controller.isSaving ? null : _controller.save,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _controller.isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Save preferences'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _PreferenceTile extends StatelessWidget {
  const _PreferenceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E4DF)),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.neutralTile,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          title: Text(title,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          subtitle: Text(subtitle,
              style: const TextStyle(color: AppColors.muted, fontSize: 13)),
          trailing: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
