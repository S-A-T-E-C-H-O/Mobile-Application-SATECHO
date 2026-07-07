import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show PlatformException;

import 'package:satecho_mobile/core/biometrics/biometric_auth_service.dart';
import 'package:satecho_mobile/core/notifications/notification_service.dart';
import 'package:satecho_mobile/features/auth/domain/auth_session.dart';
import 'package:satecho_mobile/features/auth/domain/auth_repository.dart';

class AuthController extends ChangeNotifier {
  AuthController({
    AuthRepository? authRepository,
    NotificationService? notificationService,
    BiometricAuthService? biometricService,
  })  : _authRepository = authRepository,
        _notificationService = notificationService,
        _biometricService = biometricService;

  final AuthRepository? _authRepository;
  final NotificationService? _notificationService;
  final BiometricAuthService? _biometricService;

  static const int _maxBiometricFailures = 3;
  int _biometricFailures = 0;
  bool _biometricFallbackToPassword = false;

  bool get biometricFallbackToPassword => _biometricFallbackToPassword;

  String _email = '';
  String _password = '';
  String _fullName = '';
  String _confirmPassword = '';
  String _selectedRole = 'ROLE_FARMER';
  String _registrationNumber = '';
  String _specialty = '';
  String _yearsOfExperience = '';
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
  String get registrationNumber => _registrationNumber;
  String get specialty => _specialty;
  String get yearsOfExperience => _yearsOfExperience;
  bool get isAgronomistRole => _selectedRole == 'ROLE_AGRONOMIST';
  bool get stayConnected => _stayConnected;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirm => _obscureConfirm;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void updateEmail(String value) => _email = value;
  void updatePassword(String value) => _password = value;
  void updateFullName(String value) => _fullName = value;
  void updateConfirmPassword(String value) => _confirmPassword = value;
  void updateRegistrationNumber(String value) => _registrationNumber = value;
  void updateSpecialty(String value) => _specialty = value;
  void updateYearsOfExperience(String value) => _yearsOfExperience = value;

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
      unawaited(_notificationService?.registerDeviceToken());
      return session;
    } on Exception catch (e) {
      _errorMessage = _friendlyMessage(e);
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
        registrationNumber: isAgronomistRole ? _registrationNumber : null,
        specialty: isAgronomistRole ? _specialty : null,
        yearsOfExperience:
            isAgronomistRole ? int.tryParse(_yearsOfExperience) : null,
      );
      return _email;
    } on Exception catch (e) {
      _errorMessage = _friendlyMessage(e);
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Always resolves true (backend anti-enumeration: same response whether
  /// the email exists or not). Errors are network/transport failures only.
  Future<bool> requestPasswordReset(String email) async {
    final repo = _authRepository;
    if (repo == null) return true;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await repo.forgotPassword(email: email);
      return true;
    } on Exception catch (e) {
      _errorMessage = _friendlyMessage(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> confirmPasswordReset({
    required String token,
    required String newPassword,
  }) async {
    final repo = _authRepository;
    if (repo == null) return true;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await repo.resetPassword(token: token, newPassword: newPassword);
      return true;
    } on Exception catch (e) {
      _errorMessage = _friendlyMessage(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// True when the device has an enrolled sensor AND the farmer opted in.
  Future<bool> canUseBiometricLogin() async {
    final bio = _biometricService;
    final repo = _authRepository;
    if (bio == null || repo == null) return false;
    if (_biometricFallbackToPassword) return false;
    final available = await bio.isAvailable();
    if (!available) return false;
    return repo.isBiometricEnabled();
  }

  Future<bool> isBiometricSensorAvailable() =>
      _biometricService?.isAvailable() ?? Future.value(false);

  Future<void> setBiometricLoginEnabled(bool enabled) async {
    await _authRepository?.setBiometricEnabled(enabled);
    notifyListeners();
  }

  /// Authenticates via fingerprint/Face ID and restores the previously saved
  /// session (no credentials re-entered). Falls back to password login after
  /// 3 consecutive failed biometric attempts.
  Future<AuthSession?> loginWithBiometrics() async {
    final bio = _biometricService;
    final repo = _authRepository;
    if (bio == null || repo == null || _biometricFallbackToPassword)
      return null;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final authenticated = await bio.authenticate();
      if (!authenticated) {
        _biometricFailures++;
        if (_biometricFailures >= _maxBiometricFailures) {
          _biometricFallbackToPassword = true;
          _errorMessage = 'Too many failed attempts. Please use your password.';
        }
        return null;
      }
      _biometricFailures = 0;
      final session = await repo.restoreSession();
      if (session == null) {
        _errorMessage =
            'No saved session found. Please log in with your password.';
        return null;
      }
      unawaited(_notificationService?.registerDeviceToken());
      return session;
    } on Exception catch (e) {
      _errorMessage = _friendlyMessage(e);
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Maps technical exceptions (Dio, secure storage, malformed JSON) to
  /// copy that's safe to show a farmer/agronomist. Anything already
  /// human-readable (a plain [Exception] thrown by the data layer with a
  /// curated message, e.g. a backend validation error) passes through as
  /// before instead of being replaced by a generic message.
  String _friendlyMessage(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          return 'No se pudo conectar con el servidor. Revisa tu conexión.';
        default:
          return _backendMessage(error) ??
              'Ocurrió un error inesperado. Intenta nuevamente.';
      }
    }
    if (error is PlatformException || error is FormatException) {
      return 'No se pudo restaurar la sesión. Inicia sesión nuevamente.';
    }
    if (error is Exception) {
      final message = error.toString().replaceFirst('Exception: ', '');
      return message.isEmpty
          ? 'Ocurrió un error inesperado. Intenta nuevamente.'
          : message;
    }
    return 'Ocurrió un error inesperado. Intenta nuevamente.';
  }

  /// Backend errors are expected as `{"message": "..."}` or
  /// `{"error": "..."}`; that copy is written for end users, so it's shown
  /// as-is instead of being collapsed into a generic message.
  String? _backendMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map) {
      final message = data['message'] ?? data['error'];
      if (message is String && message.trim().isNotEmpty) return message;
    }
    return null;
  }
}
