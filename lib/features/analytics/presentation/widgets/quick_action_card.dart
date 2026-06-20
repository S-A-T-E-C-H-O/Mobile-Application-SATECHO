import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
    this.filled = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          height: 138,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: filled ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: filled
                ? null
                : Border.all(color: const Color(0xFFC9CEC6), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon,
                  color: filled ? Colors.white : AppColors.primary, size: 32),
              Text(
                title,
                style: TextStyle(
                  color: filled ? Colors.white : AppColors.text,
                  fontSize: 15,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
