import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../soil_monitoring/domain/entities/plot.dart';
import '../../../soil_monitoring/domain/entities/sensor_metric.dart';
import '../../domain/entities/irrigation_session.dart';

class IrrigationControlCard extends StatelessWidget {
  const IrrigationControlCard({
    required this.plot,
    required this.session,
    required this.onToggle,
    required this.onActivate,
    super.key,
  });

  final Plot plot;
  final IrrigationSession session;
  final VoidCallback onToggle;
  final VoidCallback onActivate;

  @override
  Widget build(BuildContext context) {
    final isRunning = session.isRunning;
    final humidityValue = plot.metrics
        .where((m) => m.type == SensorMetricType.humidity)
        .map((m) => m.numericValue.round())
        .firstOrNull;
    return AppCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final buttonSize = (constraints.maxWidth * 0.60).clamp(160.0, 230.0);
          return Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.water_drop_outlined,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                plot.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'humidity_fc28: ${humidityValue ?? 0}%',
                style: const TextStyle(fontSize: 17, color: AppColors.text),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: buttonSize,
                  height: buttonSize,
                  decoration: BoxDecoration(
                    color: isRunning
                        ? AppColors.danger
                        : const Color(0xFF07AF73),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 5),
                    boxShadow: [
                      BoxShadow(
                        color: (isRunning
                                ? AppColors.danger
                                : const Color(0xFF07AF73))
                            .withValues(alpha: 0.22),
                        blurRadius: 32,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.power_settings_new,
                          color: Colors.white, size: buttonSize * 0.27),
                      Text(
                        isRunning ? 'OFF' : 'ON',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: buttonSize * 0.12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onActivate,
                icon: const Icon(Icons.water_drop, size: 20),
                label: const Text(
                  'Activar Riego',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (isRunning)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.dangerSoft,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    '\u25CF Regando \u2022 ${session.remainingMinutes ?? 0} min restantes',
                    style: const TextStyle(
                      color: AppColors.danger,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                const Text(
                  'Sistema en espera',
                  style: TextStyle(fontSize: 16, color: AppColors.text),
                ),
            ],
          );
        },
      ),
    );
  }
}
