import 'package:flutter/material.dart';
import '../models/observation.dart';
import '../services/database_service.dart';
/// Manages observation data and operations
class ObservationViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Observation> _observations = [];
  bool _isLoading = false;
  String? _errorMessage;
// Getters
  List<Observation> get observations => List.unmodifiable(_observations);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load all observations
  Future<void> loadObservations() async {
    try {
      _setLoading(true);
      _clearError();
      _observations = await _databaseService.getAllObservations();
      notifyListeners();
    } catch (error) {
      _setError('Failed to load observations: $error');
    } finally {
      _setLoading(false);
    }
  }
  /// Add a new observation
  Future<void> addObservation(Observation observation) async {
    try {
      _setLoading(true);
      _clearError();
      await _databaseService.insertObservation(observation);
      await loadObservations(); // Refresh the list
    } catch (error) {
      _setError('Failed to add observation: $error');
    } finally {
      _setLoading(false);
    }
  }
  /// Update a observation
  Future<void> updateObservation(Observation observation) async {
    try {
      _setLoading(true);
      _clearError();
      await _databaseService.updateObservation(observation);
      await loadObservations(); // Refresh the list
    } catch (error) {
      _setError('Failed to update observation: $error');
    } finally {
      _setLoading(false);
    }
  }
  /// Delete a observation
  Future<void> deleteObservation(int observationId) async {
    try {
      _setLoading(true);
      _clearError();
      await _databaseService.deleteObservation(observationId);
      await loadObservations(); // Refresh the list
    } catch (error) {

      _setError('Failed to delete observation: $error');
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