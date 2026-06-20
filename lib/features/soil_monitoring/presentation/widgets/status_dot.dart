import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/features/soil_monitoring/domain/plot_status.dart';

class StatusDot extends StatelessWidget {
  const StatusDot({required this.status, super.key});

  final PlotStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 11,
      height: 11,
      decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
    );
  }

  Color get _color {
    return switch (status) {
      PlotStatus.critical => AppColors.danger,
      PlotStatus.healthy => const Color(0xFF7EA081),
      PlotStatus.warning => const Color(0xFFC98366),
    };
  }
}
