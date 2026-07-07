import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/app/theme/app_spacing.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/core/widgets/status_chip.dart';
import 'package:satecho_mobile/features/advisory/domain/recommendation.dart';
import 'package:satecho_mobile/features/advisory/domain/recommendation_priority.dart';

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    required this.recommendation,
    required this.onCompleted,
    super.key,
  });

  final Recommendation recommendation;
  final VoidCallback onCompleted;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusChip(
                label: recommendation.canComplete ? 'Pendiente' : 'Completada',
                tone: recommendation.canComplete
                    ? StatusTone.warning
                    : StatusTone.success,
              ),
              const SizedBox(width: AppSpacing.sm),
              _PriorityChip(priority: recommendation.priority),
              const Spacer(),
              Text(
                recommendation.dateLabel,
                style: const TextStyle(fontSize: 13, color: AppColors.muted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm + 4),
          Text(
            recommendation.title,
            style: const TextStyle(
              fontSize: 18,
              height: 1.15,
              color: AppColors.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            recommendation.description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.35,
              color: Color(0xFF404740),
            ),
          ),
          const SizedBox(height: AppSpacing.md - 2),
          Wrap(
            spacing: AppSpacing.sm + 4,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Icon(Icons.location_on_outlined,
                  color: AppColors.muted, size: 18),
              Text(
                recommendation.plotName,
                style: const TextStyle(fontSize: 13, color: AppColors.muted),
              ),
              const Text('\u2022', style: TextStyle(color: AppColors.border)),
              Text(
                recommendation.author,
                style: const TextStyle(fontSize: 13, color: AppColors.muted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (recommendation.canComplete)
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: onCompleted,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF80A482),
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm + 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.sm + 2),
                      ),
                    ),
                    child: const Text(
                      'Marcar completada',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md - 2),
                IconButton.filledTonal(
                  onPressed: () {},
                  icon: const Icon(Icons.description_outlined, size: 20),
                  style: IconButton.styleFrom(
                    fixedSize: const Size(48, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.sm + 4),
                    ),
                  ),
                ),
              ],
            )
          else
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                foregroundColor: AppColors.muted,
                side: const BorderSide(color: AppColors.muted),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.sm + 2),
                ),
              ),
              child: const Text('Ver detalle', style: TextStyle(fontSize: 14)),
            ),
        ],
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  const _PriorityChip({required this.priority});

  final RecommendationPriority priority;

  @override
  Widget build(BuildContext context) {
    final high = priority == RecommendationPriority.high;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 2, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: high ? AppColors.dangerSoft : AppColors.warningSoft,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Text(
        high ? 'ALTA' : 'MEDIA',
        style: TextStyle(
          color: high ? const Color(0xFF9B0000) : const Color(0xFF6D3A26),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
