import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/features/priority_cases/presentation/controllers/priority_cases_controller.dart';

/// EP-009-US005: critical alerts across the agronomist's assigned clients,
/// sorted by whatever order the backend returns (most-critical-first is a
/// server-side concern — this screen just renders what it's given).
class PriorityCasesPage extends StatefulWidget {
  const PriorityCasesPage({super.key});

  @override
  State<PriorityCasesPage> createState() => _PriorityCasesPageState();
}

class _PriorityCasesPageState extends State<PriorityCasesPage> {
  late final PriorityCasesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PriorityCasesController(
      AppDependenciesScope.of(context).getPriorityCases,
    );
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
      appBar: AppBar(title: const Text('Priority cases')),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_controller.cases.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('All parcels are in normal condition'),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: _controller.cases
                .map((c) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(
                        border: const Border(
                          left: BorderSide(color: AppColors.danger, width: 4),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${c.farmerName ?? 'Unknown farmer'} • ${c.farmName ?? 'Farm'}',
                              style: const TextStyle(
                                  color: AppColors.muted, fontSize: 13),
                            ),
                            const SizedBox(height: 6),
                            Text(c.alertType,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 6),
                            Text(c.elapsedLabel,
                                style: const TextStyle(color: AppColors.text)),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
