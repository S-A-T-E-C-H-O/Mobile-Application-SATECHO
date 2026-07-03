import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/features/auth/presentation/controllers/auth_controller.dart';

/// EP-001-US006: the backend always returns success regardless of whether the
/// email exists (anti-enumeration), so this screen shows the same "check your
/// email" confirmation either way — never reveals if the address is registered.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({
    required this.onBackToLogin,
    required this.onHaveResetCode,
    super.key,
  });

  final VoidCallback onBackToLogin;
  final VoidCallback onHaveResetCode;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final AuthController _controller;
  final _emailController = TextEditingController();
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _controller = AppDependenciesScope.of(context).createAuthController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_emailController.text.trim().isEmpty) return;
    await _controller.requestPasswordReset(_emailController.text.trim());
    if (!mounted) return;
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: widget.onBackToLogin),
        title: const Text('Reset password'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: _submitted
              ? _ConfirmationView(onDone: widget.onHaveResetCode)
              : _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Enter the email associated with your account and we\'ll send you '
          'a link to reset your password.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'tu@email.com',
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
          ),
        ),
        const SizedBox(height: 24),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => FilledButton(
            onPressed: _controller.isLoading ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size.fromHeight(48),
            ),
            child: _controller.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Send reset link'),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: widget.onHaveResetCode,
          child: const Text('I already have a reset code'),
        ),
      ],
    );
  }
}

class _ConfirmationView extends StatelessWidget {
  const _ConfirmationView({required this.onDone});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.mark_email_read_outlined,
            size: 56, color: AppColors.primary),
        const SizedBox(height: 16),
        Text(
          'If that email is registered, we\'ve sent a password reset link. '
          'Check your inbox.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: onDone,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size.fromHeight(48),
          ),
          child: const Text('Enter reset code'),
        ),
      ],
    );
  }
}
