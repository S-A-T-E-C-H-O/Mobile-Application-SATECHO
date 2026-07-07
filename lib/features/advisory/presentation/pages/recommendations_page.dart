import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_spacing.dart';
import 'package:satecho_mobile/core/widgets/app_states.dart';
import 'package:satecho_mobile/features/advisory/presentation/controllers/recommendations_controller.dart';
import 'package:satecho_mobile/features/advisory/presentation/widgets/recommendation_card.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  late final RecommendationsController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AppDependenciesScope.of(context).createRecommendationsController();
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
        return RefreshIndicator(
          onRefresh: () => _controller.load(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              mq.padding.top + AppSpacing.md,
              AppSpacing.gutter,
              mq.padding.bottom + 80,
            ),
            children: [
              Text('Tareas',
                  style: Theme.of(context).textTheme.headlineLarge),
              AppSpacing.gapLg,
              if (_controller.isLoading)
                const AppLoadingState()
              else if (_controller.recommendations.isEmpty)
                const AppEmptyState(
                  icon: Icons.task_alt,
                  title: 'Sin tareas',
                  message:
                      'Las tareas asignadas por tu agrónomo aparecerán aquí.',
                )
              else
                ..._controller.recommendations.map(
                  (rec) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: RecommendationCard(
                      recommendation: rec,
                      onCompleted: () => _controller.complete(rec.id),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
