import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/network/api_client.dart';
import '../../models/notification_model.dart';

class AlertRemoteDataSource {
  const AlertRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<NotificationModel>> getNotifications({bool? read}) async {
    final Map<String, dynamic> params = {};
    if (read != null) params['read'] = read.toString();

    final response = await _client.get<List<dynamic>>(
      ApiConstants.notifications,
      queryParameters: params.isEmpty ? null : params,
    );
    return (response.data as List<dynamic>)
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> markRead(String notificationId) async {
    await _client.patch<void>(
      ApiConstants.notification(notificationId),
      data: {'read': true},
    );
  }

  Future<Map<String, dynamic>> loadPreferences() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiConstants.notificationPreferences,
    );
    return response.data ?? {};
  }

  Future<void> savePreferences(Map<String, dynamic> preferences) async {
    await _client.put<void>(
      ApiConstants.notificationPreferences,
      data: preferences,
    );
  }
}
