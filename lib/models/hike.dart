/// Hike model - represents a hike in the app
class Hike {
  final int? id;
  final String name;
  final String location;
  final DateTime date;
  final double length;
  final bool parkingAvailable;
  final String difficulty;
  final String description;
  /// Create a new hike
  const Hike({
    this.id,
    required this.name,
    required this.location,
    required this.date,
    required this.length,
    required this.parkingAvailable,
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
      length: map['length'] as double,
      parkingAvailable: (map['parkingAvailable'] as int) == 1,
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
      'length': length,
      'parkingAvailable': parkingAvailable ? 1 : 0,
      'difficulty': difficulty,
      'description': description,
    };
  }
  /// Create a copy with updated fields
  Hike copyWith({
    int? id,
    String? name,
    String? location,
    DateTime ? date,
    double? length,
    bool? parkingAvailable,
    String? difficulty,
    String? description,
  }) {
    return Hike(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      date: date ?? this.date,
      length: length ?? this.length,
      parkingAvailable: parkingAvailable ?? this.parkingAvailable,
      difficulty: difficulty ?? this.difficulty,
      description: description ?? this.description,
    );

  }
}