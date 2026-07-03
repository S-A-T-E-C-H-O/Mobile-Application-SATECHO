import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/features/notifications/domain/alert_severity.dart';
import 'package:satecho_mobile/features/notifications/presentation/controllers/notifications_controller.dart';

/// In-app notification center (EP-008-US021): chronological list of all
/// received notifications, mark-as-read on tap, and an unread badge count.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AppDependenciesScope.of(context).createNotificationsController();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _severityColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return Colors.red;
      case AlertSeverity.warning:
        return Colors.orange;
      case AlertSeverity.info:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final mq = MediaQuery.of(context);
          final items = _controller.filtered;
          return ListView(
            padding: EdgeInsets.fromLTRB(
                20, mq.padding.top + 16, 20, mq.padding.bottom + 80),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Notifications',
                      style: Theme.of(context).textTheme.headlineLarge),
                  if (_controller.unreadCount > 0)
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${_controller.unreadCount}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: _controller.typeFilter == null,
                    onSelected: (_) => _controller.setTypeFilter(null),
                  ),
                  ChoiceChip(
                    label: const Text('Irrigation'),
                    selected: _controller.typeFilter == 'IRRIGATION_ALERT',
                    onSelected: (_) =>
                        _controller.setTypeFilter('IRRIGATION_ALERT'),
                  ),
                  ChoiceChip(
                    label: const Text('Security'),
                    selected: _controller.typeFilter == 'SECURITY_ALERT',
                    onSelected: (_) =>
                        _controller.setTypeFilter('SECURITY_ALERT'),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              if (_controller.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (items.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: Text('All quiet on your parcels')),
                )
              else
                ...items.map(
                  (n) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: n.read
                        ? null
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: ListTile(
                      onTap: () => _controller.markAsRead(n.id),
                      leading: CircleAvatar(
                        backgroundColor: _severityColor(n.severity),
                        radius: 6,
                      ),
                      title: Text(
                        n.title,
                        style: TextStyle(
                            fontWeight:
                                n.read ? FontWeight.normal : FontWeight.bold),
                      ),
                      subtitle: Text('${n.body}\n${n.timeLabel}'),
                      isThreeLine: true,
                      trailing: n.read
                          ? null
                          : const Icon(Icons.circle,
                              size: 10, color: Colors.blue),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
