import 'package:envirosense/data/datasources/device_data_source.dart';
import 'package:envirosense/domain/usecases/add_device.dart';
import 'package:envirosense/domain/usecases/delete_device.dart';
import 'package:envirosense/domain/usecases/delete_device_data.dart';
import 'package:envirosense/domain/usecases/get_device.dart';

import '../../data/repositories/device_repository_impl.dart';
import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';
import '../../domain/usecases/get_devices.dart';
import '../../services/api_service.dart';

class DeviceController {
  late final GetDevicesUseCase getDevicesUseCase;
  late final GetDeviceUseCase getDeviceUseCase;
  late final AddDeviceUseCase addDeviceUseCase;
  late final DeleteDeviceUseCase deleteDeviceUseCase;
  late final DeleteDeviceDataUseCase deleteDeviceDataUseCase;
  final DeviceRepository repository;

  DeviceController()
      : repository = DeviceRepositoryImpl(
          remoteDataSource: DeviceDataSource(apiService: ApiService()),
        ) {
    getDevicesUseCase = GetDevicesUseCase(repository);
    getDeviceUseCase = GetDeviceUseCase(repository);
    addDeviceUseCase = AddDeviceUseCase(repository);
    deleteDeviceUseCase = DeleteDeviceUseCase(repository);
    deleteDeviceDataUseCase = DeleteDeviceDataUseCase(repository);
  }

  Future<List<Device>> getDevices(String buildingId) async {
    return await getDevicesUseCase(buildingId);
  }

  Future<Device> getDevice(String deviceId, String buildingId) async {
    return await getDeviceUseCase(deviceId, buildingId);
  }

  Future<String> addDevice(String? roomId, String? deviceIdentifier) async {
    return await addDeviceUseCase(roomId, deviceIdentifier);
  }

  Future<void> deleteDevice(String? deviceId, String? buildingId) async {
    return await deleteDeviceUseCase(deviceId, buildingId);
  }

  Future<void> deleteDeviceData(String? deviceId) async {
    return await deleteDeviceDataUseCase(deviceId);
  }
}
