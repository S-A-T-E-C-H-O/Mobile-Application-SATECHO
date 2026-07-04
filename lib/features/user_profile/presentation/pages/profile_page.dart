import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/core/widgets/app_card.dart';
import 'package:satecho_mobile/features/billing/presentation/pages/subscription_page.dart';
import 'package:satecho_mobile/features/notifications/presentation/pages/notification_preferences_page.dart';
import 'package:satecho_mobile/features/user_profile/presentation/controllers/profile_controller.dart';
import 'package:satecho_mobile/features/user_profile/presentation/pages/edit_profile_page.dart';
import 'package:satecho_mobile/features/activity_log/presentation/pages/activity_log_list_page.dart';
import 'package:satecho_mobile/features/user_profile/presentation/widgets/profile_option_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AppDependenciesScope.of(context).createProfileController();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final profile = _controller.profile;
        return ListView(
          padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).padding.top + 16,
              20,
              MediaQuery.of(context).padding.bottom + 80),
          children: [
            Text('Profile', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 24),
            if (_controller.isLoading || profile == null)
              const Center(child: CircularProgressIndicator())
            else ...[
              AppCard(
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.neutralTile,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.agriculture,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${profile.farmName} • ${profile.farmAreaLabel}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const _BiometricLoginToggle(),
              const SizedBox(height: 24),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ProfileOptionTile(
                      icon: Icons.edit_outlined,
                      label: 'Edit profile',
                      value: '',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              EditProfilePage(currentName: profile.name),
                        ),
                      ),
                    ),
                    ProfileOptionTile(
                      icon: Icons.history,
                      label: 'Activity log',
                      value: '',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ActivityLogListPage(),
                        ),
                      ),
                    ),
                    ProfileOptionTile(
                      icon: Icons.notifications_none,
                      label: 'Notifications',
                      value: profile.notificationPreference,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const NotificationPreferencesPage(),
                        ),
                      ),
                    ),
                    ProfileOptionTile(
                      icon: Icons.credit_card_outlined,
                      label: 'Subscription',
                      value: 'Active',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SubscriptionPage(),
                        ),
                      ),
                    ),
                    ProfileOptionTile(
                      icon: Icons.location_on_outlined,
                      label: 'Units',
                      value: profile.units,
                    ),
                    ProfileOptionTile(
                      icon: Icons.wifi_off_outlined,
                      label: 'Offline mode',
                      value: profile.offlineMode,
                    ),
                    ProfileOptionTile(
                      icon: Icons.person_outline,
                      label: 'Language',
                      value: profile.language,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: OutlinedButton.icon(
                  onPressed: _controller.logout,
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text('Log out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.muted,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    side: const BorderSide(color: Color(0xFF7D877D)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Lets the farmer opt in to fingerprint/Face ID login (EP-002-TS004).
/// Disabled automatically when the device has no enrolled biometric sensor.
class _BiometricLoginToggle extends StatefulWidget {
  const _BiometricLoginToggle();

  @override
  State<_BiometricLoginToggle> createState() => _BiometricLoginToggleState();
}

class _BiometricLoginToggleState extends State<_BiometricLoginToggle> {
  bool _sensorAvailable = false;
  bool _enabled = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final deps = AppDependenciesScope.of(context);
    if (!deps.hasAuthRepository) {
      setState(() => _loaded = true);
      return;
    }
    final available = await deps.biometricService.isAvailable();
    final enabled = await deps.authRepository.isBiometricEnabled();
    if (!mounted) return;
    setState(() {
      _sensorAvailable = available;
      _enabled = enabled;
      _loaded = true;
    });
  }

  Future<void> _toggle(bool value) async {
    final deps = AppDependenciesScope.of(context);
    if (!deps.hasAuthRepository) return;
    await deps.authRepository.setBiometricEnabled(value);
    if (!mounted) return;
    setState(() => _enabled = value);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || !_sensorAvailable) return const SizedBox.shrink();
    return AppCard(
      padding: EdgeInsets.zero,
      child: SwitchListTile(
        secondary: const Icon(Icons.fingerprint, color: AppColors.primary),
        title: const Text('Biometric login'),
        subtitle: const Text('Use fingerprint or Face ID to log in faster'),
        value: _enabled,
        onChanged: _toggle,
        activeColor: AppColors.primary,
      ),
    );
  }
}
