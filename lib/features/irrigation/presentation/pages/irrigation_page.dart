import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/sensor_metric.dart';
import 'package:satecho_mobile/features/zones/presentation/pages/threshold_calibration_page.dart';
import 'package:satecho_mobile/features/irrigation/presentation/controllers/irrigation_controller.dart';
import 'package:satecho_mobile/features/irrigation/presentation/widgets/duration_selector.dart';
import 'package:satecho_mobile/features/irrigation/presentation/widgets/irrigation_control_card.dart';
import 'package:satecho_mobile/features/irrigation/presentation/widgets/plot_segment_selector.dart';

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
                color: isCompleted ? AppColors.primary : AppColors.muted,
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
                    style:
                        const TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                  color: isCompleted ? AppColors.primary : AppColors.muted,
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

  bool _loadingReport = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// EP-004-US002 Scenario 2: confirm before dispatching an irrigation command.
  Future<void> _confirmAndRun(
      bool currentlyRunning, Future<void> Function() action) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title:
            Text(currentlyRunning ? 'Stop irrigation?' : 'Start irrigation?'),
        content: Text(currentlyRunning
            ? 'This will stop the active irrigation session immediately.'
            : 'This will activate irrigation for the selected duration.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirm')),
        ],
      ),
    );
    if (confirmed == true) {
      await action();
      final notice = _controller.offlineNotice;
      if (notice != null && mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(notice)));
      }
    }
  }

  /// EP-012-US024: fetch the zone's last-30-days water-consumption report and
  /// hand the bytes to the platform's native PDF viewer/share sheet.
  Future<void> _openWaterReport(String zoneId) async {
    setState(() => _loadingReport = true);
    try {
      final bytes =
          await AppDependenciesScope.of(context).getWaterConsumptionReportPdf(
        zoneId,
        fromDate: DateTime.now().subtract(const Duration(days: 30)),
        toDate: DateTime.now(),
      );
      if (bytes == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not generate the report')),
          );
        }
        return;
      }
      await Printing.layoutPdf(
        onLayout: (_) async => Uint8List.fromList(bytes),
      );
    } finally {
      if (mounted) setState(() => _loadingReport = false);
    }
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
                  if (plot != null) ...[
                    IconButton(
                      tooltip: 'Water consumption report (PDF)',
                      onPressed: _loadingReport
                          ? null
                          : () => _openWaterReport(plot.id),
                      icon: _loadingReport
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.picture_as_pdf_outlined,
                              color: AppColors.muted),
                    ),
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
                  onToggle: () =>
                      _confirmAndRun(session.isRunning, _controller.toggle),
                  onActivate: () =>
                      _confirmAndRun(false, _controller.activateIrrigation),
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
