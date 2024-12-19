import 'package:envirosense/data/models/add_device.dart';
import 'package:envirosense/data/models/device_model.dart';
import '../../services/api_service.dart';

class DeviceDataSource {
  final ApiService apiService;

  DeviceDataSource({required this.apiService});

  Future<List<DeviceModel>> getDevices() async {
    try {
      final response = await apiService.getRequest('devices');

      if (response == null) {
        throw Exception('Response is null');
      }

      List<dynamic> data = response as List<dynamic>;
      List<DeviceModel> devices = data.map((deviceJson) {
        return DeviceModel.fromJson(deviceJson as Map<String, dynamic>);
      }).toList();

      return devices;
    } catch (e) {
      throw Exception('Failed to load devices: $e');
    }
  }

  Future<String> addDevice(String? roomId, String? deviceIdentifier) async {
    try {
      AddDeviceRequest body = AddDeviceRequest(roomId, deviceIdentifier);
      return await apiService.postRequest('rooms/$roomId/devices', body.toJson());
    } catch (e) {
      throw Exception('Failed to add device: $e');
    }
  }
}
