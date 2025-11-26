import '../models/observation.dart';
import '../services/database_service.dart';
/// Abstract repository interface
abstract class ObservationRepository {
  Future<List<Observation>> getAllObservations();
  Future<Observation> addObservation(Observation observation);
  Future<Observation> updateObservation(Observation observation);
  Future<void> deleteObservation(int observationId);
}
/// Concrete repository implementation
class ObservationRepositoryImpl implements ObservationRepository {
  final DatabaseService _databaseService;
  ObservationRepositoryImpl(this._databaseService);
  @override
  Future<List<Observation>> getAllObservations() async {
    try {
      return await _databaseService.getAllObservations();
    } catch (error) {
      throw Exception('Failed to fetch observations: $error');
    }
  }

  @override
  Future<Observation> addObservation(Observation observation) async {
    try {
      final id = await _databaseService.insertObservation(observation);
      return observation.copyWith(id: id);
    } catch (error) {
      throw Exception('Failed to add observation: $error');
    }
  }
  @override
  Future<Observation> updateObservation(Observation observation) async {
    try {
      await _databaseService.updateObservation(observation);
      return observation;
    } catch (error) {
      throw Exception('Failed to update observation: $error');
    }
  }
  @override
  Future<void> deleteObservation(int observationId) async {
    try {
      await _databaseService.deleteObservation(observationId);
    } catch (error) {
      throw Exception('Failed to delete observation: $error');
    }
  }
}