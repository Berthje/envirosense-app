import 'package:envirosense/domain/entities/device_data.dart';
import 'package:envirosense/domain/entities/room.dart';

class Device {
  final String id;
  final String identifier;
  final Room? room;
  final List<DeviceData>? deviceData;

  Device({
    required this.id,
    required this.identifier,
    this.room,
    this.deviceData,
  });

  @override
  String toString() {
    return 'Device{id: $id, identifier: $identifier, room: $room, deviceData: $deviceData}';
  }
}
