import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';

class MockDeviceRepository implements DeviceRepository {
  @override
  Future<List<Device>> getDevicesByPlot(String plotId) async => _mockDevices
      .where((d) => d.plotId == plotId)
      .toList();

  @override
  Future<List<Device>> getAllDevices() async => _mockDevices;
}

final _mockDevices = [
  Device(
    id: '1',
    plotId: 'zone-1',
    name: 'SN-001 (SOIL_SENSOR)',
    status: 'HEALTHY',
    batteryPercent: 87,
    signalStrength: 92,
    lastSeenAt: DateTime.now().subtract(const Duration(minutes: 2)),
  ),
  Device(
    id: '2',
    plotId: 'zone-2',
    name: 'SN-002 (SOIL_SENSOR)',
    status: 'DEGRADED',
    batteryPercent: 23,
    signalStrength: 45,
    lastSeenAt: DateTime.now().subtract(const Duration(minutes: 18)),
  ),
  Device(
    id: '3',
    plotId: 'zone-3',
    name: 'SN-003 (VALVE)',
    status: 'OFFLINE',
    batteryPercent: null,
    signalStrength: null,
    lastSeenAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  Device(
    id: '4',
    plotId: 'zone-1',
    name: 'SN-004 (VALVE)',
    status: 'HEALTHY',
    batteryPercent: 64,
    signalStrength: 78,
    lastSeenAt: DateTime.now().subtract(const Duration(minutes: 5)),
  ),
];
