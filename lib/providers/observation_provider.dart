import 'package:flutter/foundation.dart';
import '../models/observation.dart';
import '../models/app_state.dart';
import '../repositories/observation_repository.dart';
/// Simple observation provider for basic CRUD operations
class ObservationProvider extends ChangeNotifier {
  final ObservationRepository _observationRepository;
// State properties
  List<Observation> _observations = [];
  AppState _appState = AppState.initial();
  ObservationProvider(this._observationRepository);
// Getters
  List<Observation> get observations => List.unmodifiable(_observations);

  AppState get appState => _appState;
  bool get isLoading => _appState.isLoading;
  String? get errorMessage => _appState.errorMessage;
  bool get isSuccess => _appState.isSuccess;
  bool get hasObservations => _observations.isNotEmpty;
  /// Load all observations
  Future<void> loadObservations() async {
    try {
      _setAppState(AppState.loading());
      final observations = await _observationRepository.getAllObservations();
      _observations = observations;
      _setAppState(AppState.success());
    } catch (error) {
      _setAppState(AppState.error('Failed to load observations: $error'));
    }
  }
  /// Add a new observation
  Future<void> addObservation(Observation observation) async {
    try {
      _setAppState(AppState.loading());
      final newObservation = await _observationRepository.addObservation(observation);
      _observations.add(newObservation);
      _setAppState(AppState.success());
    } catch (error) {
      _setAppState(AppState.error('Failed to add observation: $error'));
    }
  }
  /// Update a observation
  Future<void> updateObservation(Observation observation) async {
    try {
      _setAppState(AppState.loading());
      final updatedObservation = await _observationRepository.updateObservation(observation);
      final index = _observations.indexWhere((b) => b.id == observation.id);
      if (index != -1) {
        _observations[index] = updatedObservation;
      }
      _setAppState(AppState.success());
    } catch (error) {
      _setAppState(AppState.error('Failed to update observation: $error'));
    }
  }

  /// Delete a observation
  Future<void> deleteObservation(int observationId) async {
    try {
      _setAppState(AppState.loading());
      await _observationRepository.deleteObservation(observationId);
      _observations.removeWhere((observation) => observation.id == observationId);
      _setAppState(AppState.success());
    } catch (error) {
      _setAppState(AppState.error('Failed to delete observation: $error'));
    }
  }
  /// Clear error state
  void clearError() {
    if (_appState.errorMessage != null) {
      _setAppState(AppState.initial());
    }
  }
// Private helper methods
  void _setAppState(AppState state) {
    _appState = state;
    notifyListeners();
  }
}