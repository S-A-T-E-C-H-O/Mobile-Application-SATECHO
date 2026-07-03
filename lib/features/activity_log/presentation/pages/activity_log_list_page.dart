import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/features/activity_log/domain/activity_log_entry.dart';
import 'package:satecho_mobile/features/activity_log/presentation/controllers/activity_log_list_controller.dart';

class ActivityLogListPage extends StatefulWidget {
  const ActivityLogListPage({super.key});

  @override
  State<ActivityLogListPage> createState() => _ActivityLogListPageState();
}

class _ActivityLogListPageState extends State<ActivityLogListPage> {
  late final ActivityLogListController _controller;
  final _scrollController = ScrollController();

  static const _types = [
    (null, 'All'),
    ('IRRIGATION', 'Irrigation'),
    ('ALERT', 'Alerts'),
    ('SECURITY', 'Security'),
    ('THRESHOLD', 'Thresholds'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = ActivityLogListController(
      AppDependenciesScope.of(context).activityLogClient,
    );
    _controller.load();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _controller.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity log')),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Column(
            children: [
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    for (final (value, label) in _types)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(label),
                          selected: _controller.typeFilter == value,
                          onSelected: (_) => _controller.setTypeFilter(value),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: _controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _controller.entries.isEmpty
                        ? const Center(child: Text('No activity yet'))
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                            itemCount: _controller.entries.length +
                                (_controller.isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= _controller.entries.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }
                              return _ActivityTile(
                                  entry: _controller.entries[index]);
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.entry});

  final ActivityLogEntry entry;

  IconData get _icon => switch (entry.type) {
        'IRRIGATION' => Icons.water_drop_outlined,
        'ALERT' => Icons.warning_amber,
        'SECURITY' => Icons.shield_outlined,
        'THRESHOLD' => Icons.tune_outlined,
        _ => Icons.circle_outlined,
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        child: Row(
          children: [
            Icon(_icon, color: AppColors.primary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.description,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    '${entry.occurredAt.year}-${entry.occurredAt.month.toString().padLeft(2, '0')}-'
                    '${entry.occurredAt.day.toString().padLeft(2, '0')} '
                    '${entry.occurredAt.hour.toString().padLeft(2, '0')}:'
                    '${entry.occurredAt.minute.toString().padLeft(2, '0')}',
                    style:
                        const TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
