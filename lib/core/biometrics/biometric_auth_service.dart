import 'package:local_auth/local_auth.dart';

/// Wraps `local_auth` for fingerprint/Face ID login (EP-002-TS004).
class BiometricAuthService {
  BiometricAuthService({LocalAuthentication? localAuth})
      : _localAuth = localAuth ?? LocalAuthentication();

  final LocalAuthentication _localAuth;

  /// Whether the device has an enrolled, usable biometric sensor.
  Future<bool> isAvailable() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final supported = await _localAuth.isDeviceSupported();
      return canCheck && supported;
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to access your SATECHO account',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
