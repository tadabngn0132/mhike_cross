import 'package:equatable/equatable.dart';
/// Application state for managing loading, error states
class AppState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  const AppState({
    required this.isLoading,
    this.errorMessage,
    required this.isSuccess,

  });
  /// Initial state
  factory AppState.initial() {
    return const AppState(
      isLoading: false,
      errorMessage: null,
      isSuccess: false,
    );
  }
  /// Loading state
  factory AppState.loading() {
    return const AppState(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );
  }
  /// Error state
  factory AppState.error(String message) {
    return AppState(
      isLoading: false,
      errorMessage: message,
      isSuccess: false,
    );
  }
  /// Success state
  factory AppState.success() {
    return const AppState(
      isLoading: false,
      errorMessage: null,
      isSuccess: true,
    );
  }
  @override
  List<Object?> get props => [isLoading, errorMessage, isSuccess];
}