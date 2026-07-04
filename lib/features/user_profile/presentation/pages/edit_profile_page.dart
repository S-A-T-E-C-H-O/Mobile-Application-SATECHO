import 'package:flutter/material.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/app/theme/app_colors.dart';
import 'package:satecho_mobile/features/user_profile/presentation/controllers/edit_profile_controller.dart';

/// EP-001-US004: edit name + change password. The backend invalidates the
/// old password immediately, but sessions on other devices stay valid until
/// their JWT expires (no server-side session tracking) — that's a documented
/// backend limitation, not something this screen can fix.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({required this.currentName, super.key});

  final String currentName;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final EditProfileController _controller;
  late final TextEditingController _nameController;
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = EditProfileController(
      AppDependenciesScope.of(context).userProfileRepository,
    );
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    final ok = await _controller.updateProfile(_nameController.text.trim());
    if (!mounted) return;
    _showResult(ok ? 'Profile updated' : _controller.errorMessage ?? 'Update failed');
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showResult('Passwords do not match');
      return;
    }
    final ok = await _controller.changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
    );
    if (!mounted) return;
    if (ok) {
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    }
    _showResult(ok ? 'Password changed' : _controller.errorMessage ?? 'Change failed');
  }

  void _showResult(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('Name', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _controller.isLoading ? null : _saveName,
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                child: const Text('Save name'),
              ),
              const SizedBox(height: 32),
              Text('Change password', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Current password',
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'New password',
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm new password',
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _controller.isLoading ? null : _changePassword,
                child: const Text('Change password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
