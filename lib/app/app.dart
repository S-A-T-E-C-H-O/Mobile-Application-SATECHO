import 'package:flutter/material.dart';

import 'di/mock_dependencies.dart';
import 'roles/user_role.dart';
import 'router/agronomist_shell.dart';
import 'router/farmer_shell.dart';
import 'theme/app_theme.dart';
import 'package:satecho_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:satecho_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:satecho_mobile/features/auth/presentation/pages/verify_email_page.dart';
import 'package:satecho_mobile/features/onboarding/presentation/pages/onboarding_wizard_page.dart';

class SatechoApp extends StatelessWidget {
  const SatechoApp({this.initialRole, super.key});

  final UserRole? initialRole;

  @override
  Widget build(BuildContext context) {
    return AppDependenciesScope(
      dependencies: AppDependencies.real(),
      child: MaterialApp(
        title: 'SATECHO',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: initialRole == null
            ? const _AuthFlow()
            : _RoleShell(role: initialRole!),
      ),
    );
  }
}

enum _AppScreen { login, register, verifyEmail, onboarding, home }

class _AuthFlow extends StatefulWidget {
  const _AuthFlow();

  @override
  State<_AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<_AuthFlow> {
  _AppScreen _screen = _AppScreen.login;
  UserRole _role = UserRole.farmer;
  String _pendingEmail = '';

  Future<void> _onLoggedIn(UserRole role) async {
    final deps = AppDependenciesScope.of(context);
    setState(() => _role = role);

    // Only check onboarding for farmers
    if (role == UserRole.farmer) {
      try {
        final progress =
        await deps.onboardingRepository.getProgress();
        if (!progress.completed) {
          if (mounted) setState(() => _screen = _AppScreen.onboarding);
          return;
        }
      } catch (_) {
        // If onboarding check fails, proceed to home
      }
    }

    if (mounted) setState(() => _screen = _AppScreen.home);
  }

  @override
  Widget build(BuildContext context) {
    return switch (_screen) {
      _AppScreen.login => LoginPage(
        onLoggedIn: _onLoggedIn,
        onGoToRegister: () =>
            setState(() => _screen = _AppScreen.register),
      ),
      _AppScreen.register => RegisterPage(
        onRegistered: (email) => setState(() {
          _pendingEmail = email;
          _screen = _AppScreen.verifyEmail;
        }),
        onBackToLogin: () => setState(() => _screen = _AppScreen.login),
      ),
      _AppScreen.verifyEmail => VerifyEmailPage(
        email: _pendingEmail,
        onVerified: () => setState(() => _screen = _AppScreen.login),
        onBackToLogin: () => setState(() => _screen = _AppScreen.login),
      ),
      _AppScreen.onboarding => OnboardingWizardPage(
        onCompleted: () => setState(() => _screen = _AppScreen.home),
      ),
      _AppScreen.home => _RoleShell(role: _role),
    };
  }
}

class _RoleShell extends StatelessWidget {
  const _RoleShell({required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    return switch (role) {
      UserRole.farmer => const FarmerShell(),
      UserRole.agronomist => const AgronomistShell(),
      UserRole.admin => const AgronomistShell(),
    };
  }
}
