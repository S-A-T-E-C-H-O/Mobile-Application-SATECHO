import 'package:satecho_mobile/features/devices/domain/entities/device.dart';

abstract class DeviceRepository {
  Future<List<Device>> getDevicesByPlot(String plotId);
  Future<List<Device>> getAllDevices();
}
