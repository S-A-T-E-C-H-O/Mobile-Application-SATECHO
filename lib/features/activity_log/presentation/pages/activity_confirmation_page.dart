import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/features/activity_log/domain/activity_type.dart';
import 'package:satecho_mobile/features/activity_log/presentation/controllers/activity_flow_controller.dart';
import 'package:satecho_mobile/features/activity_log/presentation/widgets/activity_step_indicator.dart';

class ActivityConfirmationPage extends StatelessWidget {
  const ActivityConfirmationPage({required this.controller, super.key});

  final ActivityFlowController controller;

  @override
  Widget build(BuildContext context) {
    final draft = controller.buildDraft();
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(28, 46, 28, 40),
        children: [
          Row(
            children: [
              Material(
                color: AppColors.surface,
                shape: const CircleBorder(),
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon:
                      const Icon(Icons.close, size: 24, color: AppColors.muted),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Record activity',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const ActivityStepIndicator(currentStep: 3),
          const SizedBox(height: 20),
          const Text(
            'Confirm the details',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 20),
          AppCard(
            child: Column(
              children: [
                _SummaryRow(label: 'Plot', value: draft?.plotName ?? ''),
                const Divider(height: 20),
                _SummaryRow(label: 'Activity', value: draft?.type.label ?? ''),
                const Divider(height: 20),
                _SummaryRow(
                    label: 'Date and time', value: draft?.dateTimeLabel ?? ''),
              ],
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_outlined, size: 20),
            label: const Text('Add photo (optional)'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF424A42),
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(fontSize: 15),
            ),
          ),
          const SizedBox(height: 36),
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              return FilledButton(
                onPressed: controller.isSaving
                    ? null
                    : () async {
                        await controller.save();
                        if (context.mounted) {
                          Navigator.of(context).popUntil((r) => r.isFirst);
                        }
                      },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  controller.isSaving ? 'Saving...' : 'Save record',
                  style: const TextStyle(fontSize: 16),
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          const Center(
            child: Text(
              'It will be saved offline and synced later',
              style: TextStyle(fontSize: 14, color: AppColors.muted),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, color: AppColors.muted),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
}
