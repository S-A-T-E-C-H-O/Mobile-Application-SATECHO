import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';

class DeviceTokenRemoteDataSource {
  const DeviceTokenRemoteDataSource(this._client);

  final ApiClient _client;

  Future<void> register({required String fcmToken, String? platform}) async {
    await _client.post<void>(
      ApiConstants.deviceTokens,
      data: {'fcmToken': fcmToken, 'platform': platform},
    );
  }
}
