import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/presentation/widgets/app_card.dart';
import 'package:satecho_mobile/features/quick_reports/presentation/controllers/quick_reports_controller.dart';
import 'package:satecho_mobile/features/quick_reports/domain/entities/quick_report.dart';

class QuickReportsPage extends StatefulWidget {
  const QuickReportsPage({super.key});

  @override
  State<QuickReportsPage> createState() => _QuickReportsPageState();
}

class _QuickReportsPageState extends State<QuickReportsPage> {
  late final QuickReportsController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AppDependenciesScope.of(context).createQuickReportsController();
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
                  Text('Quick reports',
                      style: Theme.of(context).textTheme.headlineMedium),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'Generate a summary per client to share via PDF or email',
                style: TextStyle(
                    color: AppColors.muted, fontSize: 16, height: 1.45),
              ),
              const SizedBox(height: 22),
              if (_controller.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ..._controller.reports.map(
                  (report) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _ReportCard(report: report),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.report});

  final QuickReport report;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  report.farmName,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w800),
                ),
              ),
              CircleAvatar(radius: 6, backgroundColor: _riskColor),
            ],
          ),
          const SizedBox(height: 8),
          Text('${report.ownerName} • ${report.crop} • ${report.areaLabel}',
              style: const TextStyle(color: AppColors.muted, fontSize: 16)),
          const SizedBox(height: 12),
          Text(
              '${report.alerts} alerts        ${report.recommendations} recommendations        ${report.records} records',
              style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('PDF')),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.email),
                  label: const Text('Email'),
                  style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF80A482)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color get _riskColor {
    return switch (report.riskColor) {
      'red' => AppColors.danger,
      'orange' => const Color(0xFFC98366),
      _ => AppColors.primary,
    };
  }
}
