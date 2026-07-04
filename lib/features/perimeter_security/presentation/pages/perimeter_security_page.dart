import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/presentation/widgets/app_card.dart';
import 'package:satecho_mobile/features/perimeter_security/presentation/controllers/perimeter_security_controller.dart';
import 'security_settings_page.dart';

class PerimeterSecurityPage extends StatefulWidget {
  const PerimeterSecurityPage({super.key});

  @override
  State<PerimeterSecurityPage> createState() => _PerimeterSecurityPageState();
}

class _PerimeterSecurityPageState extends State<PerimeterSecurityPage> {
  late final PerimeterSecurityController _controller;
  String? _classificationFilter;
  bool _exporting = false;

  Future<void> _exportCsv() async {
    setState(() => _exporting = true);
    try {
      final bytes = await _controller.exportCsv();
      if (bytes == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not export security events')),
          );
        }
        return;
      }
      await Share.share(utf8.decode(bytes),
          subject: 'Security events export');
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AppDependenciesScope.of(context)
        .createPerimeterSecurityController();
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
        final filtered = _classificationFilter == null
            ? _controller.events
            : _controller.events
                .where((e) => e.classification == _classificationFilter)
                .toList();
        final personEvents =
            filtered.where((e) => e.classification == 'PERSON').toList();
        final otherEvents =
            filtered.where((e) => e.classification != 'PERSON').toList();
        return ListView(
          padding: EdgeInsets.fromLTRB(
              20, mq.padding.top + 16, 20, mq.padding.bottom + 80),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Perimeter Security',
                      style: Theme.of(context).textTheme.headlineLarge),
                ),
                IconButton(
                  tooltip: 'Export CSV',
                  onPressed: _exporting ? null : _exportCsv,
                  icon: _exporting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.ios_share, color: AppColors.muted),
                ),
                IconButton(
                  tooltip: 'Security settings',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SecuritySettingsPage(),
                    ),
                  ),
                  icon: const Icon(Icons.settings_outlined,
                      color: AppColors.muted),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _classificationFilter == null,
                  onSelected: (_) => setState(() => _classificationFilter = null),
                ),
                for (final c in const ['PERSON', 'ANIMAL', 'WIND'])
                  ChoiceChip(
                    label: Text(c),
                    selected: _classificationFilter == c,
                    onSelected: (_) => setState(() => _classificationFilter = c),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            if (_controller.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (filtered.isEmpty)
              const Text('No security events')
            else ...[
              if (personEvents.isNotEmpty) ...[
                const _SectionHeader(
                  label: 'PIR MOVEMENT DETECTIONS',
                  color: AppColors.danger,
                ),
                const SizedBox(height: 12),
                ...personEvents.map((event) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _SecurityEventCard(event: event),
                    )),
              ],
              if (otherEvents.isNotEmpty) ...[
                const SizedBox(height: 24),
                const _SectionHeader(
                  label: 'OTHER EVENTS',
                  color: AppColors.muted,
                ),
                const SizedBox(height: 12),
                ...otherEvents.map((event) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _SecurityEventCard(event: event),
                    )),
              ],
            ],
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.shield_outlined, color: color, size: 22),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

class _SecurityEventCard extends StatelessWidget {
  const _SecurityEventCard({required this.event});

  final dynamic event;

  @override
  Widget build(BuildContext context) {
    final isPir = event.classification == 'PERSON';
    return AppCard(
      border: Border(
        left: BorderSide(
          color: isPir ? AppColors.danger : AppColors.warning,
          width: 4,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPir ? Icons.directions_walk : Icons.warning_amber,
                color: isPir ? AppColors.danger : AppColors.warning,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${event.zoneName} \u2022 ${_timeAgo(event.createdAt)}',
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return '${diff.inMinutes}min';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays == 1) return 'Ayer';
    return '${diff.inDays}d';
  }
}
