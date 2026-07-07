import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/app/theme/app_spacing.dart';

/// Semantic tone for a [StatusChip]. Colours come from tokens, never loose
/// values, so status reads consistently everywhere (the "Attention" pill in
/// the zones reference, alert severities, subscription state, etc.).
enum StatusTone { danger, warning, info, success, neutral }

/// Compact pill that labels a state. Accessible by default: the tone is
/// conveyed by text (not colour alone) and exposed to screen readers.
class StatusChip extends StatelessWidget {
  const StatusChip({
    required this.label,
    this.tone = StatusTone.neutral,
    this.icon,
    super.key,
  });

  final String label;
  final StatusTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _colors;
    return Semantics(
      label: 'Estado: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 2,
          vertical: AppSpacing.xs + 1,
        ),
        decoration: BoxDecoration(color: bg, borderRadius: AppRadius.pillBr),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: fg),
              const SizedBox(width: AppSpacing.xs + 1),
            ],
            Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  (Color, Color) get _colors {
    return switch (tone) {
      StatusTone.danger => (AppColors.dangerSoft, AppColors.danger),
      StatusTone.warning => (AppColors.warningSoft, const Color(0xFFB56A00)),
      StatusTone.info => (AppColors.infoSoft, AppColors.info),
      StatusTone.success => (AppColors.primarySoft, AppColors.primary),
      StatusTone.neutral => (AppColors.neutralTile, AppColors.muted),
    };
  }
}
