import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/app/theme/app_spacing.dart';

/// Designed system states — loading (skeleton), empty and error — so screens
/// stop improvising with a bare spinner or a red `Text`. Dependency-free:
/// the skeleton shimmer is a lightweight looping opacity animation, respecting
/// `MediaQuery.disableAnimations` for reduced-motion users.

/// A shimmering placeholder block. Use several stacked to fake a loading list.
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    this.height = 16,
    this.width,
    this.radius = AppRadius.tile,
    super.key,
  });

  final double height;
  final double? width;
  final double radius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = reduceMotion ? 0.5 : _controller.value;
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: Color.lerp(
              AppColors.neutralTile,
              AppColors.border,
              t,
            ),
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        );
      },
    );
  }
}

/// A few skeleton "cards" that stand in for a list while it loads.
class AppLoadingState extends StatelessWidget {
  const AppLoadingState({this.items = 3, super.key});

  final int items;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Cargando',
      child: Column(
        children: List.generate(
          items,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.lg),
            child: _SkeletonCard(),
          ),
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardBr,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(height: 18, width: 160),
          SizedBox(height: AppSpacing.sm),
          SkeletonBox(height: 12, width: 110),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: SkeletonBox(height: 56)),
              SizedBox(width: AppSpacing.sm),
              Expanded(child: SkeletonBox(height: 56)),
              SizedBox(width: AppSpacing.sm),
              Expanded(child: SkeletonBox(height: 56)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Empty state: an icon, a title and a supporting line. Optional action.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
    super.key,
  });

  final String title;
  final String? message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppColors.muted),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: AppColors.muted),
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: AppSpacing.lg),
            action!,
          ],
        ],
      ),
    );
  }
}

/// Error state with a retry affordance (≥48px touch target).
class AppErrorState extends StatelessWidget {
  const AppErrorState({
    required this.message,
    this.onRetry,
    this.title = 'Algo salió mal',
    super.key,
  });

  final String message;
  final String title;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        children: [
          const Icon(Icons.cloud_off_outlined,
              size: 48, color: AppColors.danger),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: AppColors.muted),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Reintentar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.border),
                  shape:
                      RoundedRectangleBorder(borderRadius: AppRadius.buttonBr),
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
