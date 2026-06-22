import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
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
              _PriorityChip(priority: recommendation.priority),
              const Spacer(),
              Text(
                recommendation.dateLabel,
                style: const TextStyle(fontSize: 13, color: AppColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            recommendation.title,
            style: const TextStyle(
              fontSize: 18,
              height: 1.15,
              color: AppColors.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            recommendation.description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.35,
              color: Color(0xFF404740),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Icon(Icons.location_on_outlined, color: AppColors.muted, size: 18),
              Text(
                recommendation.plotName,
                style: const TextStyle(fontSize: 13, color: AppColors.muted),
              ),
              const Text('•', style: TextStyle(color: AppColors.border)),
              Text(
                recommendation.author,
                style: const TextStyle(fontSize: 13, color: AppColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (recommendation.canComplete)
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: onCompleted,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF80A482),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Mark completed',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                IconButton.filledTonal(
                  onPressed: () {},
                  icon: const Icon(Icons.description_outlined, size: 20),
                  style: IconButton.styleFrom(
                    fixedSize: const Size(48, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('View details', style: TextStyle(fontSize: 14)),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: high ? AppColors.dangerSoft : AppColors.warningSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        high ? 'HIGH' : 'MEDIUM',
        style: TextStyle(
          color: high ? const Color(0xFF9B0000) : const Color(0xFF6D3A26),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
