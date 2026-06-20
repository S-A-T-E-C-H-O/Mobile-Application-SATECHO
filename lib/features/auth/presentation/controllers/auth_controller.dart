import 'package:flutter/foundation.dart';

import 'package:satecho_mobile/features/auth/domain/auth_session.dart';
import 'package:satecho_mobile/features/auth/domain/auth_repository.dart';

class AuthController extends ChangeNotifier {
  AuthController({AuthRepository? authRepository})
      : _authRepository = authRepository;

  final AuthRepository? _authRepository;

  String _email = '';
  String _password = '';
  String _fullName = '';
  String _confirmPassword = '';
  String _selectedRole = 'ROLE_FARMER';
  bool _stayConnected = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String? _errorMessage;

  String get email => _email;
  String get password => _password;
  String get fullName => _fullName;
  String get confirmPassword => _confirmPassword;
  String get selectedRole => _selectedRole;
  bool get stayConnected => _stayConnected;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirm => _obscureConfirm;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void updateEmail(String value) => _email = value;
  void updatePassword(String value) => _password = value;
  void updateFullName(String value) => _fullName = value;
  void updateConfirmPassword(String value) => _confirmPassword = value;

  void updateSelectedRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }

  void toggleStayConnected(bool? value) {
    _stayConnected = value ?? false;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmVisibility() {
    _obscureConfirm = !_obscureConfirm;
    notifyListeners();
  }

  Future<AuthSession?> login() async {
    final repo = _authRepository;
    if (repo == null) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
      return null;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final session = await repo.signIn(email: _email, password: _password);
      return session;
    } on Exception catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Returns the email used for registration on success, null on failure.
  Future<String?> register() async {
    final repo = _authRepository;

    if (_password != _confirmPassword) {
      _errorMessage = 'Passwords do not match';
      notifyListeners();
      return null;
    }

    if (repo == null) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
      return _email;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await repo.signUp(
        fullName: _fullName,
        email: _email,
        password: _password,
        roles: [_selectedRole],
      );
      return _email;
    } on Exception catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
