import 'package:satecho_mobile/core/constants/api_constants.dart';
import 'package:satecho_mobile/core/network/api_client.dart';
import 'package:satecho_mobile/features/devices/domain/entities/device.dart';
import 'package:satecho_mobile/features/devices/domain/repositories/device_repository.dart';
import 'package:satecho_mobile/features/devices/infrastructure/data_sources/remote/device_remote_data_source.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  const DeviceRepositoryImpl(this._remote, this._client);

  final DeviceRemoteDataSource _remote;
  final ApiClient _client;

  @override
  Future<List<Device>> getDevicesByPlot(String plotId) async {
    try {
      final zoneResponse = await _client.get<Map<String, dynamic>>(
        ApiConstants.zone(plotId),
      );
      final deviceId = zoneResponse.data?['deviceId'] as int?;
      if (deviceId == null) return [];

      final deviceModel = await _remote.getDeviceById(deviceId.toString());
      if (deviceModel == null) return [];

      return [_toDevice(deviceModel, plotId: plotId)];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<Device>> getAllDevices() async {
    final models = await _remote.getDevices();
    return models.map((m) => _toDevice(m)).toList();
  }

  Device _toDevice(dynamic m, {String plotId = ''}) {
    return Device(
      id: m.id.toString(),
      plotId: plotId,
      name: '${m.serialNumber} (${m.type})',
      status: m.online ? m.healthStatus : 'OFFLINE',
      batteryPercent: m.batteryPercent,
      signalStrength: m.signalStrength,
      lastSeenAt: m.lastSeenAt,
    );
  }
}
