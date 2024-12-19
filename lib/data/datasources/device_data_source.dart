import 'package:envirosense/data/models/add_device.dart';
import 'package:envirosense/data/models/device_model.dart';
import '../../services/api_service.dart';

class DeviceDataSource {
  final ApiService apiService;

  DeviceDataSource({required this.apiService});

  Future<List<DeviceModel>> getDevices(String buildingId) async {
    try {
      final response = await apiService.getRequest('devices');

      List<dynamic> data = response as List<dynamic>;
      List<DeviceModel> devices = data.map((deviceJson) {
        return DeviceModel.fromJson(deviceJson as Map<String, dynamic>, buildingId);
      }).toList();

      return devices;
    } catch (e) {
      throw Exception('Failed to load devices: $e');
    }
  }

  Future<String> addDevice(String? roomId, String? deviceIdentifier) async {
    try {
      AddDeviceRequest body = AddDeviceRequest(roomId, deviceIdentifier);

      final response = await apiService.postRequest('devices', body.toJson());
      final locationHeader = response.headers['location'];
      if(locationHeader == null) {
        throw Exception('Device ID not found in response headers');
      }

      return locationHeader.split('/').last;

    } catch (e) {
      throw Exception('Failed to add device: $e');
    }
  }
}
