import 'package:satecho_mobile/features/auth/domain/auth_session.dart';
import 'package:satecho_mobile/features/auth/domain/auth_repository.dart';
import 'package:satecho_mobile/features/auth/data/auth_local_data_source.dart';
import 'package:satecho_mobile/features/auth/data/auth_remote_data_source.dart';
import 'package:satecho_mobile/features/auth/data/auth_session_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
    AuthSessionMapper mapper = const AuthSessionMapper(),
  })  : _remote = remote,
        _local = local,
        _mapper = mapper;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final AuthSessionMapper _mapper;

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final model = await _remote.signIn(email: email, password: password);
    await _local.saveSession(model);
    return _mapper.toEntity(model);
  }

  @override
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    List<String> roles = const ['ROLE_FARMER'],
    String? registrationNumber,
    String? specialty,
    int? yearsOfExperience,
  }) async {
    await _remote.signUp(
      fullName: fullName,
      email: email,
      password: password,
      roles: roles,
      registrationNumber: registrationNumber,
      specialty: specialty,
      yearsOfExperience: yearsOfExperience,
    );
  }

  @override
  Future<void> verifyAccount({required String token}) async {
    await _remote.verifyAccount(token: token);
  }

  @override
  Future<void> resendVerification({required String email}) async {
    await _remote.resendVerification(email: email);
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await _remote.forgotPassword(email: email);
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await _remote.resetPassword(token: token, newPassword: newPassword);
  }

  @override
  Future<AuthSession?> restoreSession() async {
    final model = await _local.restoreSession();
    if (model == null) return null;
    return _mapper.toEntity(model);
  }

  @override
  Future<void> clearSession() => _local.clearSession();

  @override
  Future<bool> isBiometricEnabled() => _local.isBiometricEnabled();

  @override
  Future<void> setBiometricEnabled(bool enabled) =>
      _local.setBiometricEnabled(enabled);
}
