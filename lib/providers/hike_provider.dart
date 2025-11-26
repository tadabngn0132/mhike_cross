import 'package:flutter/foundation.dart';
import '../models/hike.dart';
import '../models/app_state.dart';
import '../repositories/hike_repository.dart';
/// Simple hike provider for basic CRUD operations
class HikeProvider extends ChangeNotifier {
  final HikeRepository _hikeRepository;
// State properties
  List<Hike> _hikes = [];
  AppState _appState = AppState.initial();
  HikeProvider(this._hikeRepository);
// Getters
  List<Hike> get hikes => List.unmodifiable(_hikes);

  AppState get appState => _appState;
  bool get isLoading => _appState.isLoading;
  String? get errorMessage => _appState.errorMessage;
  bool get isSuccess => _appState.isSuccess;
  bool get hasHikes => _hikes.isNotEmpty;
  /// Load all hikes
  Future<void> loadHikes() async {
    try {
      _setAppState(AppState.loading());
      final hikes = await _hikeRepository.getAllHikes();
      _hikes = hikes;
      _setAppState(AppState.success());
    } catch (error) {
      _setAppState(AppState.error('Failed to load hikes: $error'));
    }
  }
  /// Add a new hike
  Future<void> addHike(Hike hike) async {
    try {
      _setAppState(AppState.loading());
      final newHike = await _hikeRepository.addHike(hike);
      _hikes.add(newHike);
      _setAppState(AppState.success());
    } catch (error) {
      _setAppState(AppState.error('Failed to add hike: $error'));
    }
  }
  /// Update a hike
  Future<void> updateHike(Hike hike) async {
    try {
      _setAppState(AppState.loading());
      final updatedHike = await _hikeRepository.updateHike(hike);
      final index = _hikes.indexWhere((b) => b.id == hike.id);
      if (index != -1) {
        _hikes[index] = updatedHike;
      }
      _setAppState(AppState.success());
    } catch (error) {
      _setAppState(AppState.error('Failed to update hike: $error'));
    }
  }

  /// Delete a hike
  Future<void> deleteHike(int hikeId) async {
    try {
      _setAppState(AppState.loading());
      await _hikeRepository.deleteHike(hikeId);
      _hikes.removeWhere((hike) => hike.id == hikeId);
      _setAppState(AppState.success());
    } catch (error) {
      _setAppState(AppState.error('Failed to delete hike: $error'));
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