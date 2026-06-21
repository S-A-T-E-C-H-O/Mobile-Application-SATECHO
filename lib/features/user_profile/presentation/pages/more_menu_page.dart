import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/features/advisory/presentation/pages/recommendations_page.dart';
import 'package:satecho_mobile/features/quick_reports/presentation/pages/quick_reports_page.dart';
import 'agronomist_profile_page.dart';
import 'agronomist_settings_page.dart';

class MoreMenuPage extends StatelessWidget {
  const MoreMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 34, 28, 118),
      children: [
        const Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person_outline, color: Colors.white, size: 24),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Eng. Martínez',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  Text('Agronomist · 23 active clients',
                      style: TextStyle(fontSize: 14, color: AppColors.muted)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _MenuTile(
          icon: Icons.send_outlined,
          title: 'Recommendations',
          subtitle: 'History and management',
          badge: '14 pending',
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RecommendationsPage())),
        ),
        _MenuTile(
          icon: Icons.description_outlined,
          title: 'Quick reports',
          subtitle: 'Customer summaries',
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const QuickReportsPage())),
        ),
        _MenuTile(
          icon: Icons.person_outline,
          title: 'My profile',
          subtitle: 'Specialties and areas',
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AgronomistProfilePage())),
        ),
        _MenuTile(
          icon: Icons.settings,
          title: 'Settings',
          subtitle: 'Notifications and preferences',
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const AgronomistSettingsPage())),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AppCard(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    color: AppColors.neutralTile,
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                  ],
                ),
              ),
              if (badge != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: const Color(0xFFC98366),
                      borderRadius: BorderRadius.circular(14)),
                  child: Text(badge!, style: const TextStyle(fontSize: 11)),
                ),
              const Icon(Icons.chevron_right, color: AppColors.muted, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
