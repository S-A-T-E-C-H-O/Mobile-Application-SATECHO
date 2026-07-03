import 'package:dio/dio.dart';

import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/storage/token_storage.dart';

class ApiClient {
  ApiClient({required TokenStorage tokenStorage}) {
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
        onError: (error, handler) => handler.next(error),
      ),
    );
  }

  late final Dio _dio;

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
