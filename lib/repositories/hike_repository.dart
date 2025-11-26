import '../models/hike.dart';
import '../services/database_service.dart';
/// Abstract repository interface
abstract class HikeRepository {
  Future<List<Hike>> getAllHikes();
  Future<Hike> addHike(Hike hike);
  Future<Hike> updateHike(Hike hike);
  Future<void> deleteHike(int hikeId);
}
/// Concrete repository implementation
class HikeRepositoryImpl implements HikeRepository {
  final DatabaseService _databaseService;
  HikeRepositoryImpl(this._databaseService);
  @override
  Future<List<Hike>> getAllHikes() async {
    try {
      return await _databaseService.getAllHikes();
    } catch (error) {
      throw Exception('Failed to fetch hikes: $error');
    }
  }

  @override
  Future<Hike> addHike(Hike hike) async {
    try {
      final id = await _databaseService.insertHike(hike);
      return hike.copyWith(id: id);
    } catch (error) {
      throw Exception('Failed to add hike: $error');
    }
  }
  @override
  Future<Hike> updateHike(Hike hike) async {
    try {
      await _databaseService.updateHike(hike);
      return hike;
    } catch (error) {
      throw Exception('Failed to update hike: $error');
    }
  }
  @override
  Future<void> deleteHike(int hikeId) async {
    try {
      await _databaseService.deleteHike(hikeId);
    } catch (error) {
      throw Exception('Failed to delete hike: $error');
    }
  }
}