import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show VoidCallback, visibleForTesting;

import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/storage/token_storage.dart';

class ApiClient {
  ApiClient({required TokenStorage tokenStorage, this.onUnauthorized}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenStorage.readToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          _handleError(error);
          handler.next(error);
        },
      ),
    );
  }

  /// Invoked once per request that comes back with HTTP 401, i.e. the
  /// backend considers the current token invalid/expired. Wired to
  /// [SessionManager.logout] from the dependency composition root so a
  /// rejected token clears local session state instead of leaving the app
  /// believing it's still authenticated. Mutable (not constructor-only) so
  /// it can be attached after `SessionManager` exists — `ApiClient` is
  /// built before `SessionManager` in the current composition order.
  VoidCallback? onUnauthorized;

  late final Dio _dio;

  void _handleError(DioException error) {
    if (error.response?.statusCode == 401) {
      onUnauthorized?.call();
    }
  }

  /// Exercises the same 401 handling the Dio interceptor uses, without
  /// needing to fake a full HTTP transport. Mirrors the
  /// `@visibleForTesting` seam already used by [MqttService].
  @visibleForTesting
  void handleErrorForTesting(DioException error) => _handleError(error);

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.get<T>(path, queryParameters: queryParameters);

  /// For endpoints that return raw binary payloads (PDF/CSV downloads) rather
  /// than JSON — e.g. water-consumption reports and security-event exports.
  Future<Response<List<int>>> getBytes(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.get<List<int>>(
        path,
        queryParameters: queryParameters,
        options: Options(responseType: ResponseType.bytes),
      );

  Future<Response<T>> post<T>(String path, {dynamic data}) =>
      _dio.post<T>(path, data: data);

  Future<Response<T>> put<T>(String path, {dynamic data}) =>
      _dio.put<T>(path, data: data);

  Future<Response<T>> patch<T>(String path, {dynamic data}) =>
      _dio.patch<T>(path, data: data);

  Future<Response<T>> delete<T>(String path) => _dio.delete<T>(path);
}
