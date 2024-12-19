import 'package:envirosense/data/datasources/room_data_source.dart';
import 'package:envirosense/data/repositories/room_repository_impl.dart';
import 'package:envirosense/domain/entities/room.dart';
import 'package:envirosense/domain/repositories/room_repository.dart';
import 'package:envirosense/domain/usecases/add_device_to_room.dart';
import 'package:envirosense/domain/usecases/get_room.dart';
import '../../domain/usecases/get_rooms.dart';
import '../../domain/usecases/add_room.dart';
import '../../services/api_service.dart';

class RoomController {
  late final GetRoomsUseCase getRoomsUseCase;
  late final GetRoomUseCase getRoomUseCase;
  late final AddRoomUseCase addRoomUseCase;
  late final AddDeviceToRoomUseCase addDeviceToRoomUseCase;
  final RoomRepository repository;

  RoomController()
      : repository = RoomRepositoryImpl(
          remoteDataSource: RoomDataSource(apiService: ApiService()),
        ) {
    getRoomsUseCase = GetRoomsUseCase(repository);
    getRoomUseCase = GetRoomUseCase(repository);
    addRoomUseCase = AddRoomUseCase(repository);
    addDeviceToRoomUseCase = AddDeviceToRoomUseCase(repository);
  }

  Future<List<Room>> getRooms() async {
    return await getRoomsUseCase();
  }

  Future<Room> getRoom(String roomId) async {
    return getRoomUseCase(roomId);
  }

  Future<void> addRoom(
      String? name, String buildingId, String? roomTypeId) async {
    return await addRoomUseCase(name, buildingId, roomTypeId);
  }

  Future<void> addDeviceToRoom(String? roomId, String? deviceId) async {
    return await addDeviceToRoomUseCase(roomId, deviceId);
  }
}
