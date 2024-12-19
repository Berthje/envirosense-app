import 'package:envirosense/domain/entities/building.dart';
import 'package:envirosense/domain/repositories/building_repository.dart';

class BuildingRepositoryImpl implements BuildingRepository {
  final BuildingDataSource remoteDataSource;

  BuildingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Building>> getBuildings() async {
    return await remoteDataSource.getBuildings();
  }
}
