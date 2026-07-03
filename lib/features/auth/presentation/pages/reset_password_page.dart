import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/features/auth/presentation/controllers/auth_controller.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({
    required this.onDone,
    required this.onBackToLogin,
    super.key,
  });

  final VoidCallback onDone;
  final VoidCallback onBackToLogin;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late final AuthController _controller;
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _controller = AppDependenciesScope.of(context).createAuthController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    final ok = await _controller.confirmPasswordReset(
      token: _tokenController.text.trim(),
      newPassword: _passwordController.text,
    );
    if (!mounted) return;
    if (ok) {
      setState(() => _done = true);
    } else if (_controller.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_controller.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: widget.onBackToLogin),
        title: const Text('Enter reset code'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: _done ? _buildDone() : _buildForm(),
        ),
      ),
    );
  }

  Widget _buildDone() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle_outline,
            size: 56, color: AppColors.primary),
        const SizedBox(height: 16),
        Text(
          'Password updated. Log in with your new password.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: widget.onDone,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size.fromHeight(48),
          ),
          child: const Text('Back to login'),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Paste the code from your reset email and choose a new password.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          _field(controller: _tokenController, hint: 'Reset code'),
          const SizedBox(height: 14),
          _field(
              controller: _passwordController,
              hint: 'New password',
              obscure: true),
          const SizedBox(height: 14),
          _field(
              controller: _confirmController,
              hint: 'Confirm new password',
              obscure: true),
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
                  : const Text('Update password'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
      ),
    );
  }
}
