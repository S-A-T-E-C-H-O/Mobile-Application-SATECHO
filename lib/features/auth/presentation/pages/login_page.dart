import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/roles/user_role.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/features/auth/presentation/controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    required this.onLoggedIn,
    this.onGoToRegister,
    this.onGoToForgotPassword,
    super.key,
  });

  final Future<void> Function(UserRole) onLoggedIn;
  final VoidCallback? onGoToRegister;
  final VoidCallback? onGoToForgotPassword;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AppDependenciesScope.of(context).createAuthController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final session = await _controller.login();
    if (!mounted) return;
    widget.onLoggedIn(session?.role ?? UserRole.farmer);
  }

  Future<void> _submitBiometric() async {
    final session = await _controller.loginWithBiometrics();
    if (!mounted || session == null) return;
    widget.onLoggedIn(session.role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _AuthBrand(),
                  const SizedBox(height: 24),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 38, 40, 34),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Log in',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Enter your credentials to access your account',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 28),
                          _LabeledField(
                            label: 'Email',
                            hint: 'tu@email.com',
                            keyboardType: TextInputType.emailAddress,
                            onChanged: _controller.updateEmail,
                          ),
                          const SizedBox(height: 18),
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, _) {
                              return _LabeledField(
                                label: 'Password',
                                hint: '••••••••',
                                obscureText: _controller.obscurePassword,
                                trailingLabel: 'Forgot my password',
                                onTrailingTap: widget.onGoToForgotPassword,
                                suffixIcon: IconButton(
                                  tooltip: _controller.obscurePassword
                                      ? 'Show password'
                                      : 'Hide password',
                                  onPressed:
                                      _controller.togglePasswordVisibility,
                                  icon: Icon(
                                    _controller.obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 20,
                                  ),
                                ),
                                onChanged: _controller.updatePassword,
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, _) {
                              return Row(
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Checkbox(
                                      value: _controller.stayConnected,
                                      onChanged:
                                          _controller.toggleStayConnected,
                                      side: const BorderSide(
                                        color: AppColors.border,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text('Stay connected'),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 26),
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, _) {
                              if (_controller.errorMessage != null) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Text(
                                    _controller.errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: AppColors.danger,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, _) {
                              return FilledButton(
                                onPressed:
                                    _controller.isLoading ? null : _submit,
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  minimumSize: const Size.fromHeight(48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                child: _controller.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Log in'),
                              );
                            },
                          ),
                          FutureBuilder<bool>(
                            future: _controller.canUseBiometricLogin(),
                            builder: (context, snapshot) {
                              if (snapshot.data != true) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 14),
                                child: OutlinedButton.icon(
                                  onPressed: _controller.isLoading
                                      ? null
                                      : _submitBiometric,
                                  icon: const Icon(Icons.fingerprint),
                                  label: const Text('Log in with biometrics'),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(48),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 36),
                          const _DividerText(),
                          const SizedBox(height: 34),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                "Don't you have an account? ",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              GestureDetector(
                                onTap: widget.onGoToRegister,
                                child: Text(
                                  'Create account',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'By logging in, you agree to our Terms of Service and '
                    'Privacy Policy',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthBrand extends StatelessWidget {
  const _AuthBrand();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.eco_outlined, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Text(
          'AgroSafe',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.hint,
    required this.onChanged,
    this.trailingLabel,
    this.onTrailingTap,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
  });

  final String label;
  final String hint;
  final String? trailingLabel;
  final VoidCallback? onTrailingTap;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
            ),
            if (trailingLabel != null)
              GestureDetector(
                onTap: onTrailingTap,
                child: Text(
                  trailingLabel!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Color(0xFFD3D7D1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _DividerText extends StatelessWidget {
  const _DividerText();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'O',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}
