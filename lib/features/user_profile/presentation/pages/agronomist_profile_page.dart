import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/features/user_profile/presentation/controllers/agronomist_profile_controller.dart';

class AgronomistProfilePage extends StatefulWidget {
  const AgronomistProfilePage({super.key});

  @override
  State<AgronomistProfilePage> createState() => _AgronomistProfilePageState();
}

class _AgronomistProfilePageState extends State<AgronomistProfilePage> {
  late final AgronomistProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AppDependenciesScope.of(context).createAgronomistProfileController();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final profile = _controller.profile;
          return ListView(
            padding: const EdgeInsets.fromLTRB(28, 34, 28, 112),
            children: [
              Row(
                children: [
                  Material(
                    color: AppColors.surface,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.chevron_left, size: 30),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text('My profile',
                      style: Theme.of(context).textTheme.headlineMedium),
                ],
              ),
              const SizedBox(height: 26),
              if (_controller.isLoading || profile == null)
                const Center(child: CircularProgressIndicator())
              else ...[
                const CircleAvatar(
                  radius: 48,
                  backgroundColor: Color(0xFF80A482),
                  child: Icon(Icons.person_outline,
                      size: 48, color: AppColors.text),
                ),
                const SizedBox(height: 18),
                Text(profile.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w800)),
                Text(profile.roleLabel,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.muted)),
                const SizedBox(height: 12),
                Text('☆ ${profile.rating}  ·  ${profile.experienceLabel}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF9B5A3E))),
                const SizedBox(height: 26),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('INFORMATION',
                          style: TextStyle(color: AppColors.muted)),
                      _InfoLine(
                          icon: Icons.phone,
                          label: 'Phone',
                          value: profile.phone),
                      _InfoLine(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: profile.email),
                      _InfoLine(
                          icon: Icons.location_on_outlined,
                          label: 'Base',
                          value: profile.base),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('SPECIALTIES',
                          style: TextStyle(color: AppColors.muted)),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final item in profile.specialties)
                            Chip(
                                label: Text(item),
                                side: BorderSide.none,
                                backgroundColor: AppColors.primarySoft),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('AREAS SERVED',
                          style: TextStyle(color: AppColors.muted)),
                      const SizedBox(height: 14),
                      for (final area in profile.areasServed)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: const Color(0xFFEFF2FA),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(area,
                              style: const TextStyle(
                                  color: AppColors.muted,
                                  fontWeight: FontWeight.w700)),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine(
      {required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text('$label\n$value',
                style: const TextStyle(fontSize: 16, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
