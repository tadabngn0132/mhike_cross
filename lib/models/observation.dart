import 'package:equatable/equatable.dart';
/// Simple Observation model with basic fields
class Observation extends Equatable {
  final int? id;
  final String title;
  final DateTime timestamp;
  final String comments;
  final int hikeId;
  const Observation({
    this.id,
    required this.title,
    required this.timestamp,
    required this.comments,
    required this.hikeId,
  });
  /// Create a Observation from database data
  factory Observation.fromMap(Map<String, dynamic> map) {
    return Observation(
      id: map['id'] as int?,
      title: map['title'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      comments: map['comments'] as String,
      hikeId: map['hikeId'] as int,
    );
  }
  /// Convert Observation to database format
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'timestamp': timestamp.toIso8601String(),
      'comments': comments,
      'hikeId': hikeId,
    };
  }
  /// Create a copy with updated fields
  Observation copyWith({
    int? id,
    String? title,
    DateTime? timestamp,
    String? comments,
    int? hikeId,
  }) {
    return Observation(
      id: id ?? this.id,
      title: title ?? this.title,
      timestamp: timestamp ?? this.timestamp,
      comments: comments ?? this.comments,
      hikeId: hikeId ?? this.hikeId,
    );
  }
  @override
  List<Object?> get props => [id, title, timestamp, comments, hikeId];
}