import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:satecho_mobile/core/network/api_client.dart';
import 'package:satecho_mobile/core/storage/token_storage.dart';

class _FakeSecureStorage extends FlutterSecureStorage {
  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async =>
      null;
}

DioException _errorWithStatus(int statusCode) {
  final requestOptions = RequestOptions(path: '/whatever');
  return DioException(
    requestOptions: requestOptions,
    response: Response(requestOptions: requestOptions, statusCode: statusCode),
  );
}

void main() {
  ApiClient buildClient() =>
      ApiClient(tokenStorage: TokenStorage(_FakeSecureStorage()));

  group('ApiClient 401 handling', () {
    test('invokes onUnauthorized for a 401 response', () {
      var calls = 0;
      final client = buildClient()..onUnauthorized = () => calls++;

      client.handleErrorForTesting(_errorWithStatus(401));

      expect(calls, 1);
    });

    test('does not invoke onUnauthorized for 400, 403 or 500', () {
      for (final status in [400, 403, 500]) {
        var calls = 0;
        final client = buildClient()..onUnauthorized = () => calls++;

        client.handleErrorForTesting(_errorWithStatus(status));

        expect(calls, 0, reason: 'status $status must not trigger logout');
      }
    });

    test('does not throw when onUnauthorized is unset', () {
      final client = buildClient();

      expect(
        () => client.handleErrorForTesting(_errorWithStatus(401)),
        returnsNormally,
      );
    });
  });
}
