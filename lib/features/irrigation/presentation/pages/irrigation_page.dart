import 'package:flutter/material.dart';

import '../../../../app/di/mock_dependencies.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../soil_monitoring/domain/entities/sensor_metric.dart';
import '../../../zones/presentation/pages/threshold_calibration_page.dart';
import '../controllers/irrigation_controller.dart';
import '../widgets/duration_selector.dart';
import '../widgets/irrigation_control_card.dart';
import '../widgets/plot_segment_selector.dart';

class _IrrigationHistoryTile extends StatelessWidget {
  const _IrrigationHistoryTile({required this.entry});

  final Map<String, dynamic> entry;

  @override
  Widget build(BuildContext context) {
    final status = entry['status'] as String? ?? 'UNKNOWN';
    final duration = entry['durationMinutes'] as int?;
    final startedAt = entry['startedAt'] as String?;
    final isCompleted = status.toUpperCase() == 'COMPLETED';

    String dateLabel = '--';
    if (startedAt != null) {
      final dt = DateTime.tryParse(startedAt);
      if (dt != null) {
        dateLabel =
            '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}  '
            '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFFE3F2FD)
                    : AppColors.neutralTile,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.water_drop_outlined,
                color:
                    isCompleted ? AppColors.primary : AppColors.muted,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    duration != null ? '$duration min' : '--',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  Text(
                    dateLabel,
                    style: const TextStyle(
                        color: AppColors.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFFE3F2FD)
                    : AppColors.neutralTile,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color:
                      isCompleted ? AppColors.primary : AppColors.muted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IrrigationPage extends StatefulWidget {
  const IrrigationPage({this.initialPlotId, super.key});

  final String? initialPlotId;

  @override
  State<IrrigationPage> createState() => _IrrigationPageState();
}

class _IrrigationPageState extends State<IrrigationPage> {
  late final IrrigationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AppDependenciesScope.of(context).createIrrigationController();
    _controller.load(initialPlotId: widget.initialPlotId);
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
          final plot = _controller.selectedPlot;
          final session = _controller.session;
          final humidity = plot?.metrics
              .where((m) => m.type == SensorMetricType.humidity)
              .map((m) => m.numericValue.round())
              .firstOrNull;
          final isWaterStress = humidity != null && humidity < 20;
          final salinity = plot?.metrics
              .where((m) => m.type == SensorMetricType.electricalConductivity)
              .map((m) => m.numericValue)
              .firstOrNull;
          final isHighSalinity = salinity != null && salinity > 5.0;

          return ListView(
            padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).padding.top + 12,
                20,
                MediaQuery.of(context).padding.bottom + 20),
            children: [
              Row(
                children: [
                  Material(
                    color: AppColors.surface,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.chevron_left, size: 32),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      'Irrigation control',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  if (plot != null)
                    IconButton(
                      tooltip: 'Threshold calibration',
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ThresholdCalibrationPage(
                            zoneId: plot.id,
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.tune_outlined,
                          color: AppColors.muted),
                    ),
                ],
              ),
              const SizedBox(height: 34),
              if (_controller.isLoading || plot == null || session == null)
                const Center(child: CircularProgressIndicator())
              else ...[
                PlotSegmentSelector(
                  plots: _controller.plots,
                  selectedPlot: plot,
                  onSelected: _controller.selectPlot,
                ),
                const SizedBox(height: 36),
                IrrigationControlCard(
                  plot: plot,
                  session: session,
                  onToggle: _controller.toggle,
                  onActivate: _controller.activateIrrigation,
                ),
                if (isWaterStress) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.dangerSoft,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppColors.danger.withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning_amber,
                            color: AppColors.danger, size: 28),
                        SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Estr\u00E9s h\u00EDdrico detectado',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.danger,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (isHighSalinity) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.dangerSoft,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppColors.danger.withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning_amber,
                            color: AppColors.danger, size: 28),
                        SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Alerta Cr\u00EDtica: Alta salinidad detectada',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.danger,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Duration',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 22),
                      DurationSelector(
                        selectedMinutes: _controller.selectedDuration,
                        onSelected: _controller.selectDuration,
                      ),
                    ],
                  ),
                ),
                if (_controller.history.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  const Text(
                    'Recent sessions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._controller.history.take(5).map(
                        (entry) => _IrrigationHistoryTile(entry: entry),
                      ),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}
