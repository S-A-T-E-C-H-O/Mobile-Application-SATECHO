import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';
import 'package:satecho_mobile/features/auth/data/auth_session_model.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._client);

  final ApiClient _client;

  Future<AuthSessionModel> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.signIn,
      data: {'email': email, 'password': password},
    );
    return AuthSessionModel.fromJson(response.data!);
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    List<String> roles = const ['ROLE_FARMER'],
  }) async {
    await _client.post<void>(
      ApiConstants.signUp,
      data: {
        'fullName': fullName,
        'email': email,
        'password': password,
        'roles': roles,
      },
    );
  }

  Future<void> verifyAccount({required String token}) async {
    await _client.get<void>(
      ApiConstants.verifyAccount,
      queryParameters: {'token': token},
    );
  }

  Future<void> resendVerification({required String email}) async {
    await _client.post<void>(
      ApiConstants.resendVerification,
      data: {'email': email},
    );
  }
}
