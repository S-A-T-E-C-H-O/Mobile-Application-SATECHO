import 'package:flutter/material.dart';

import '../../../../app/di/mock_dependencies.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../irrigation/presentation/pages/irrigation_page.dart';
import '../controllers/plots_controller.dart';
import '../widgets/plot_card.dart';

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
        return ListView(
          padding: EdgeInsets.fromLTRB(
              20, mq.padding.top + 16, 20, mq.padding.bottom + 80),
          children: [
            Text('Plots', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 28),
            if (_controller.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_controller.errorMessage != null)
              Text(
                _controller.errorMessage!,
                style: const TextStyle(color: AppColors.danger),
              )
            else
              ..._controller.plots.map(
                (plot) => Padding(
                  padding: const EdgeInsets.only(bottom: 22),
                  child: PlotCard(
                    plot: plot,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => IrrigationPage(initialPlotId: plot.id),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
