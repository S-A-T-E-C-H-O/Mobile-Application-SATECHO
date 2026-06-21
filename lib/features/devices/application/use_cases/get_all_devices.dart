import 'package:satecho_mobile/features/devices/domain/entities/device.dart';
import 'package:satecho_mobile/features/devices/domain/repositories/device_repository.dart';

class GetAllDevices {
  const GetAllDevices(this._repository);

  final DeviceRepository _repository;

  Future<List<Device>> call() => _repository.getAllDevices();
}
