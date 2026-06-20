import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/auth/domain/auth_repository.dart';

class VerifyEmailController extends ChangeNotifier {
  VerifyEmailController({
    required this.email,
    AuthRepository? authRepository,
  }) : _authRepository = authRepository;

  final String email;
  final AuthRepository? _authRepository;

  String _token = '';
  bool _isLoading = false;
  bool _isResending = false;
  String? _errorMessage;
  String? _successMessage;

  String get token => _token;
  bool get isLoading => _isLoading;
  bool get isResending => _isResending;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  void updateToken(String value) => _token = value;

  Future<bool> verify() async {
    final repo = _authRepository;
    if (repo == null) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      return true;
    }

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await repo.verifyAccount(token: _token);
      _successMessage = 'Account verified successfully';
      return true;
    } on Exception catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resend() async {
    final repo = _authRepository;
    if (repo == null) {
      _successMessage = 'Verification email resent';
      notifyListeners();
      return;
    }

    _isResending = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await repo.resendVerification(email: email);
      _successMessage = 'Verification email sent to $email';
    } on Exception catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isResending = false;
      notifyListeners();
    }
  }
}
