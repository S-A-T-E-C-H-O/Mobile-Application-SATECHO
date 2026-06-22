import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';

class ActivityStepIndicator extends StatelessWidget {
  const ActivityStepIndicator({required this.currentStep, super.key});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StepCircle(label: '✓', active: currentStep >= 1),
        const _StepLine(active: true),
        _StepCircle(
            label: currentStep > 2 ? '✓' : '2', active: currentStep >= 2),
        const _StepLine(active: false),
        _StepCircle(label: '3', active: currentStep >= 3),
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? AppColors.muted : AppColors.border,
        shape: BoxShape.circle,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.white : AppColors.muted,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _StepLine extends StatelessWidget {
  const _StepLine({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 1.5,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        color: active ? AppColors.muted : AppColors.border,
      ),
    );
  }
}
