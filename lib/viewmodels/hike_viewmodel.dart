import 'package:flutter/material.dart';
import '../models/hike.dart';
import '../services/database_service.dart';
/// Manages hike data and operations
class HikeViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Hike> _hikes = [];
  bool _isLoading = false;
  String? _errorMessage;
// Getters
  List<Hike> get hikes => List.unmodifiable(_hikes);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load all hikes
  Future<void> loadHikes() async {
    try {
      _setLoading(true);
      _clearError();
      _hikes = await _databaseService.getAllHikes();
      notifyListeners();
    } catch (error) {
      _setError('Failed to load hikes: $error');
    } finally {
      _setLoading(false);
    }
  }
  /// Add a new hike
  Future<void> addHike(Hike hike) async {
    try {
      _setLoading(true);
      _clearError();
      await _databaseService.insertHike(hike);
      await loadHikes(); // Refresh the list
    } catch (error) {
      _setError('Failed to add hike: $error');
    } finally {
      _setLoading(false);
    }
  }
  /// Update a hike
  Future<void> updateHike(Hike hike) async {
    try {
      _setLoading(true);
      _clearError();
      await _databaseService.updateHike(hike);
      await loadHikes(); // Refresh the list
    } catch (error) {
      _setError('Failed to update hike: $error');
    } finally {
      _setLoading(false);
    }
  }
  /// Delete a hike
  Future<void> deleteHike(int hikeId) async {
    try {
      _setLoading(true);
      _clearError();
      await _databaseService.deleteHike(hikeId);
      await loadHikes(); // Refresh the list
    } catch (error) {

      _setError('Failed to delete hike: $error');
    } finally {
      _setLoading(false);
    }
  }
// Private helper methods
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}