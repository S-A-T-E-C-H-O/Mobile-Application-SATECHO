import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';

class ProfileOptionTile extends StatelessWidget {
  const ProfileOptionTile({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.muted, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, color: AppColors.text),
              ),
            ),
            Text(value,
                style: const TextStyle(fontSize: 14, color: AppColors.muted)),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: Color(0xFF7D877D), size: 20),
          ],
        ),
      ),
    );
  }
}
