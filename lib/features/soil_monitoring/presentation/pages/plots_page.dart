import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_spacing.dart';
import 'package:satecho_mobile/core/widgets/app_states.dart';
import 'package:satecho_mobile/features/soil_monitoring/presentation/controllers/plots_controller.dart';
import 'package:satecho_mobile/features/soil_monitoring/presentation/widgets/plot_card.dart';
import 'package:satecho_mobile/features/zones/presentation/pages/zones_page.dart';

class PlotsPage extends StatefulWidget {
  const PlotsPage({super.key});

  @override
  State<PlotsPage> createState() => _PlotsPageState();
}

class _PlotsPageState extends State<PlotsPage> {
  late final PlotsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AppDependenciesScope.of(context).createPlotsController();
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
          onRefresh: _controller.load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              mq.padding.top + AppSpacing.md,
              AppSpacing.gutter,
              mq.padding.bottom + 80,
            ),
            children: [
              Text('Parcelas',
                  style: Theme.of(context).textTheme.headlineLarge),
              AppSpacing.gapLg,
              if (_controller.isLoading)
                const AppLoadingState()
              else if (_controller.errorMessage != null)
                AppErrorState(
                  message: _controller.errorMessage!,
                  onRetry: _controller.load,
                )
              else if (_controller.plots.isEmpty)
                const AppEmptyState(
                  icon: Icons.grass_outlined,
                  title: 'Aún no hay parcelas',
                  message:
                      'Cuando registres una parcela en tu propiedad aparecerá aquí.',
                )
              else
                ..._controller.plots.map(
                  (plot) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: PlotCard(
                      plot: plot,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ZonesPage(),
                        ),
                      ),
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
