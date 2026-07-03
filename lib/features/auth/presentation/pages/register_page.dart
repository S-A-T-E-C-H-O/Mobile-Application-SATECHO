import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/features/auth/presentation/controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    required this.onRegistered,
    required this.onBackToLogin,
    super.key,
  });

  final ValueChanged<String> onRegistered;
  final VoidCallback onBackToLogin;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
    final email = await _controller.register();
    if (!mounted) return;
    if (email != null) widget.onRegistered(email);
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
                            'Create account',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Fill in your details to get started',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 28),
                          _LabeledField(
                            label: 'Full name',
                            hint: 'Juan Pérez',
                            keyboardType: TextInputType.name,
                            onChanged: _controller.updateFullName,
                          ),
                          const SizedBox(height: 18),
                          _LabeledField(
                            label: 'Email',
                            hint: 'tu@email.com',
                            keyboardType: TextInputType.emailAddress,
                            onChanged: _controller.updateEmail,
                          ),
                          const SizedBox(height: 18),
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, _) => _LabeledField(
                              label: 'Password',
                              hint: '••••••••',
                              obscureText: _controller.obscurePassword,
                              suffixIcon: IconButton(
                                onPressed: _controller.togglePasswordVisibility,
                                icon: Icon(
                                  _controller.obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                ),
                              ),
                              onChanged: _controller.updatePassword,
                            ),
                          ),
                          const SizedBox(height: 18),
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, _) => _LabeledField(
                              label: 'Confirm password',
                              hint: '••••••••',
                              obscureText: _controller.obscureConfirm,
                              suffixIcon: IconButton(
                                onPressed: _controller.toggleConfirmVisibility,
                                icon: Icon(
                                  _controller.obscureConfirm
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                ),
                              ),
                              onChanged: _controller.updateConfirmPassword,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Role',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 8),
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, _) => _RoleSelector(
                              selected: _controller.selectedRole,
                              onChanged: _controller.updateSelectedRole,
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, _) {
                              if (!_controller.isAgronomistRole) {
                                return const SizedBox.shrink();
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(height: 18),
                                  _LabeledField(
                                    label: 'Professional registration number',
                                    hint: 'CIP-12345',
                                    onChanged:
                                        _controller.updateRegistrationNumber,
                                  ),
                                  const SizedBox(height: 18),
                                  _LabeledField(
                                    label: 'Specialty',
                                    hint: 'Irrigation, soil science, ...',
                                    onChanged: _controller.updateSpecialty,
                                  ),
                                  const SizedBox(height: 18),
                                  _LabeledField(
                                    label: 'Years of experience',
                                    hint: '5',
                                    keyboardType: TextInputType.number,
                                    onChanged:
                                        _controller.updateYearsOfExperience,
                                  ),
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
                            builder: (context, _) => FilledButton(
                              onPressed: _controller.isLoading ? null : _submit,
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
                                  : const Text('Create account'),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              GestureDetector(
                                onTap: widget.onBackToLogin,
                                child: Text(
                                  'Log in',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleSelector extends StatelessWidget {
  const _RoleSelector({
    required this.selected,
    required this.onChanged,
  });

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _RoleOption(
            label: 'Farmer',
            value: 'ROLE_FARMER',
            selected: selected == 'ROLE_FARMER',
            onTap: () => onChanged('ROLE_FARMER'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _RoleOption(
            label: 'Agronomist',
            value: 'ROLE_AGRONOMIST',
            selected: selected == 'ROLE_AGRONOMIST',
            onTap: () => onChanged('ROLE_AGRONOMIST'),
          ),
        ),
      ],
    );
  }
}

class _RoleOption extends StatelessWidget {
  const _RoleOption({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFD3D7D1),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.text,
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
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
  });

  final String label;
  final String hint;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
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
