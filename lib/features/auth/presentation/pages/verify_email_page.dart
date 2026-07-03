import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/features/auth/presentation/controllers/verify_email_controller.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({
    required this.email,
    required this.onVerified,
    required this.onBackToLogin,
    super.key,
  });

  final String email;
  final VoidCallback onVerified;
  final VoidCallback onBackToLogin;

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  late final VerifyEmailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AppDependenciesScope.of(context)
        .createVerifyEmailController(widget.email);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await _controller.verify();
    if (!mounted) return;
    if (ok) widget.onVerified();
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
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mark_email_unread_outlined,
                      size: 36,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Check your email',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We sent a verification token to\n${widget.email}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
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
                      padding: const EdgeInsets.fromLTRB(32, 32, 32, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Verification token',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            onChanged: _controller.updateToken,
                            decoration: InputDecoration(
                              hintText: 'Paste the token from your email',
                              filled: true,
                              fillColor: AppColors.surface,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 15,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide:
                                    const BorderSide(color: Color(0xFFD3D7D1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide:
                                    const BorderSide(color: AppColors.primary),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
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
                              if (_controller.successMessage != null) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Text(
                                    _controller.successMessage!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: AppColors.primary,
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
                                  : const Text('Verify account'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, _) => TextButton(
                              onPressed: _controller.isResending
                                  ? null
                                  : _controller.resend,
                              child: _controller.isResending
                                  ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Resend email'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: widget.onBackToLogin,
                    child: const Text('Back to login'),
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
