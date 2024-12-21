import 'package:envirosense/data/datasources/room_data_source.dart';
import 'package:envirosense/data/repositories/room_repository_impl.dart';
import 'package:envirosense/domain/entities/air_quality.dart';
import 'package:envirosense/domain/entities/room.dart';
import 'package:envirosense/domain/repositories/room_repository.dart';
import 'package:envirosense/domain/usecases/add_device_to_room.dart';
import 'package:envirosense/domain/usecases/delete_room.dart';
import 'package:envirosense/domain/usecases/get_air_quality.dart';
import 'package:envirosense/domain/usecases/get_room.dart';
import 'package:envirosense/domain/usecases/remove_device_from_room.dart';
import '../../domain/usecases/get_rooms.dart';
import '../../domain/usecases/add_room.dart';
import '../../services/api_service.dart';

class RoomController {
  late final GetRoomsUseCase getRoomsUseCase;
  late final GetRoomUseCase getRoomUseCase;
  late final GetAirQualityUseCase getAirQualityUseCase;
  late final AddRoomUseCase addRoomUseCase;
  late final DeleteRoomUseCase deleteRoomUseCase;
  late final AddDeviceToRoomUseCase addDeviceToRoomUseCase;
  late final RemoveDeviceFromRoomUseCase removeDeviceFromRoomUseCase;
  final RoomRepository repository;

  RoomController()
      : repository = RoomRepositoryImpl(
          remoteDataSource: RoomDataSource(apiService: ApiService()),
        ) {
    getRoomsUseCase = GetRoomsUseCase(repository);
    getRoomUseCase = GetRoomUseCase(repository);
    getAirQualityUseCase = GetAirQualityUseCase(repository);
    addRoomUseCase = AddRoomUseCase(repository);
    deleteRoomUseCase = DeleteRoomUseCase(repository);
    addDeviceToRoomUseCase = AddDeviceToRoomUseCase(repository);
    removeDeviceFromRoomUseCase = RemoveDeviceFromRoomUseCase(repository);
  }

  Future<List<Room>> getRooms() async {
    return await getRoomsUseCase();
  }

  Future<Room> getRoom(String roomId) async {
    return await getRoomUseCase(roomId);
  }

  Future<AirQuality> getAirQuality(String roomId) async {
    return await getAirQualityUseCase(roomId);
  }

  Future<void> addRoom(
      String? name, String buildingId, String? roomTypeId) async {
    return await addRoomUseCase(name, buildingId, roomTypeId);
  }

  Future<void> deleteRoom(String? roomId) async {
    return await deleteRoomUseCase(roomId);
  }

  Future<void> addDeviceToRoom(String? roomId, String? deviceId) async {
    return await addDeviceToRoomUseCase(roomId, deviceId);
  }

  Future<void> removeDeviceFromRoom(String? roomId, String? deviceId) async {
    return await removeDeviceFromRoomUseCase(roomId, deviceId);
  }
}
