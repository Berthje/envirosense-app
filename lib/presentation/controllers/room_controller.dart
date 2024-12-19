import 'package:envirosense/data/datasources/room_data_source.dart';
import 'package:envirosense/data/repositories/room_repository_impl.dart';
import 'package:envirosense/domain/entities/room.dart';
import 'package:envirosense/domain/repositories/room_repository.dart';
import '../../domain/usecases/get_rooms.dart';
import '../../services/api_service.dart';

class RoomController {
  late final GetRoomsUseCase getRoomsUseCase;
  final RoomRepository repository;

  RoomController()
      : repository = RoomRepositoryImpl(
          remoteDataSource: RoomDataSource(apiService: ApiService()),
        ) {
    getRoomsUseCase = GetRoomsUseCase(repository);
  }

  Future<List<Room>> fetchRooms() async {
    return await getRoomsUseCase();
  }
}
