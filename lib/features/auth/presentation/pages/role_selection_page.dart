import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/roles/user_role.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({
    required this.onRoleSelected,
    required this.onBack,
    super.key,
  });

  final ValueChanged<UserRole> onRoleSelected;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        titleSpacing: 24,
        title: const Text(
          'SATECHO',
          style: TextStyle(
            color: Color(0xFF075743),
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 24),
            child: Row(
              children: [
                Icon(Icons.language, color: AppColors.text, size: 20),
                SizedBox(width: 6),
                Text('ES', style: TextStyle(color: AppColors.text)),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Column(
                      children: [
                        Text(
                          'Welcome to AgroSafe',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 30),
                        ),
                        const SizedBox(height: 18),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 620),
                          child: Text(
                            'Select the profile that best describes your '
                            'activity to personalize your smart management '
                            'experience.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(height: 52),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth >= 720;
                            final cards = [
                              _RoleCard(
                                icon: Icons.local_florist_outlined,
                                iconBackground: const Color(0xFFCBECCA),
                                title: 'Farmer',
                                description:
                                    'Manage your crops, optimize resources, '
                                    'and receive smart alerts directly to '
                                    'your plot.',
                                action: 'Starting out as a farmer',
                                actionColor: AppColors.primary,
                                onTap: () => onRoleSelected(UserRole.farmer),
                              ),
                              _RoleCard(
                                icon: Icons.query_stats_outlined,
                                iconBackground: const Color(0xFFDCE5F7),
                                title: 'Agronomist',
                                description:
                                    'Analyze massive amounts of data, manage '
                                    'multiple clients, and generate high-value '
                                    'technical reports for agronomic analysis.',
                                action: 'Starting out as an Agronomist',
                                actionColor: AppColors.muted,
                                onTap: () =>
                                    onRoleSelected(UserRole.agronomist),
                              ),
                            ];

                            if (!isWide) {
                              return Column(
                                children: [
                                  cards.first,
                                  const SizedBox(height: 16),
                                  cards.last,
                                ],
                              );
                            }

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: cards.first),
                                const SizedBox(width: 12),
                                Expanded(child: cards.last),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 12,
                children: [
                  TextButton.icon(
                    onPressed: onBack,
                    icon: const Icon(Icons.chevron_left, size: 18),
                    label: const Text('Back'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.muted,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Do you already have an account? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: onBack,
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                  Text(
                    '© 2024 SATECHO. Intelligent Stewardship.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.description,
    required this.action,
    required this.actionColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBackground;
  final String title;
  final String description;
  final String action;
  final Color actionColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          constraints: const BoxConstraints(minHeight: 315),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: const Color(0xFF0F3F26), size: 32),
              ),
              const SizedBox(height: 30),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 14),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.45,
                      color: const Color(0xFF4F5650),
                    ),
              ),
              const SizedBox(height: 36),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      action,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: actionColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.arrow_forward, size: 17, color: actionColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
