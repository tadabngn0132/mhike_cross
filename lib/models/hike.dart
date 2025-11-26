import 'package:equatable/equatable.dart';
/// Simple Hike model with basic fields
class Hike extends Equatable {
  final int? id;
  final String name;
  final String location;
  final DateTime date;
  final bool parkingAvailable;
  final double length;
  final String difficulty;
  final String description;
  const Hike({
    this.id,
    required this.name,
    required this.location,
    required this.date,
    required this.parkingAvailable,
    required this.length,
    required this.difficulty,
    required this.description,

  });
  /// Create a Hike from database data
  factory Hike.fromMap(Map<String, dynamic> map) {
    return Hike(
      id: map['id'] as int?,
      name: map['name'] as String,
      location: map['location'] as String,
      date: DateTime.parse(map['date'] as String),
      parkingAvailable: (map['parkingAvailable'] as int) == 1,
      length: (map['length'] as num).toDouble(),
      difficulty: map['difficulty'] as String,
      description: map['description'] as String? ?? '',
    );
  }
  /// Convert Hike to database format
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'date': date.toIso8601String(),
      'parkingAvailable': parkingAvailable ? 1 : 0,
      'length': length,
      'difficulty': difficulty,
      'description': description,
    };
  }
  /// Create a copy with updated fields
  Hike copyWith({
    int? id,
    String? name,
    String? location,
    DateTime? date,
    bool? parkingAvailable,
    double? length,
    String? difficulty,
    String? description,
  }) {
    return Hike(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      date: date ?? this.date,
      parkingAvailable: parkingAvailable ?? this.parkingAvailable,
      length: length ?? this.length,
      difficulty: difficulty ?? this.difficulty,
      description: description ?? this.description,
    );
  }
  @override
  List<Object?> get props => [id, name, location, date, parkingAvailable, length, difficulty, description];
}