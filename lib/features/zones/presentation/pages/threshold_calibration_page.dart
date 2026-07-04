import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/features/zones/presentation/controllers/zone_analysis_controller.dart';
import 'threshold_adjustment_page.dart';

class ThresholdCalibrationPage extends StatefulWidget {
  const ThresholdCalibrationPage({required this.zoneId, super.key});

  final String zoneId;

  @override
  State<ThresholdCalibrationPage> createState() =>
      _ThresholdCalibrationPageState();
}

class _ThresholdCalibrationPageState extends State<ThresholdCalibrationPage> {
  late final ZoneAnalysisController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AppDependenciesScope.of(context).createZoneAnalysisController();
    _controller.load(widget.zoneId);
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
                  Text('Threshold Calibration',
                      style: Theme.of(context).textTheme.headlineMedium),
                ],
              ),
              const SizedBox(height: 24),
              if (_controller.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_controller.zone == null)
                const Text('Zone not found',
                    style: TextStyle(color: AppColors.muted))
              else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.grass_outlined,
                          color: AppColors.primary, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _controller.zone!.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                            Text(
                              '${_controller.zone!.crop} · ${_controller.zone!.areaLabel}',
                              style: const TextStyle(
                                  color: AppColors.muted, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _CalibrationTile(
                  icon: Icons.water_drop_outlined,
                  title: 'Soil Moisture',
                  description: 'Set min/max irrigation thresholds',
                  currentMin: '30%',
                  currentMax: '70%',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ThresholdAdjustmentPage(
                        zoneId: widget.zoneId,
                        zoneName: _controller.zone!.name,
                        cropType: _controller.zone!.crop,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _CalibrationTile(
                  icon: Icons.bolt_outlined,
                  title: 'Electrical Conductivity',
                  description: 'Salinity alert thresholds',
                  currentMin: '0.5 dS/m',
                  currentMax: '3.0 dS/m',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ThresholdAdjustmentPage(
                        zoneId: widget.zoneId,
                        zoneName: _controller.zone!.name,
                        cropType: _controller.zone!.crop,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _CalibrationTile(
                  icon: Icons.science_outlined,
                  title: 'Soil pH',
                  description: 'Acidity/alkalinity alert range',
                  currentMin: '5.5',
                  currentMax: '7.5',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ThresholdAdjustmentPage(
                        zoneId: widget.zoneId,
                        zoneName: _controller.zone!.name,
                        cropType: _controller.zone!.crop,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _CalibrationTile extends StatelessWidget {
  const _CalibrationTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.currentMin,
    required this.currentMax,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final String currentMin;
  final String currentMax;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E4DF)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.neutralTile,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(description,
                        style: const TextStyle(
                            color: AppColors.muted, fontSize: 12)),
                    const SizedBox(height: 6),
                    Text(
                      'Range: $currentMin – $currentMax',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: AppColors.muted, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
