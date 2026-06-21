import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';
import 'package:satecho_mobile/features/devices/infrastructure/models/device_model.dart';

class DeviceRemoteDataSource {
  const DeviceRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<DeviceModel>> getDevices() async {
    final response = await _client.get<List<dynamic>>(ApiConstants.devices);
    return (response.data as List<dynamic>)
        .map((e) => DeviceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<DeviceModel?> getDeviceById(String deviceId) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiConstants.device(deviceId),
      );
      return DeviceModel.fromJson(response.data!);
    } catch (_) {
      return null;
    }
  }
}
