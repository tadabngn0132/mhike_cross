import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/hike.dart';
import '../models/observation.dart';
/// Handles all database operations
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();
  static Database? _database;
  static const String _databaseName = 'm_hike.db';
  static const int _databaseVersion = 1;
  /// Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }
  /// Initialize database
  Future<Database> _initializeDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final databasePath = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      databasePath,
      version: _databaseVersion,
      onCreate: _createDatabaseSchema,
    );
  }
  /// Create the hikes table
  Future<void> _createDatabaseSchema(Database database, int version) async {
    await database.execute('''
      CREATE TABLE hikes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      author TEXT NOT NULL,
      description TEXT
      )
    ''');

    await database.execute('''
      CREATE TABLE observations(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      timestamp TEXT NOT NULL,
      comments TEXT,
      hikeId INTEGER NOT NULL,
      FOREIGN KEY (hikeId) REFERENCES hikes (id) ON DELETE CASCADE
      )
    ''');
  }
  /// Add a new hike

  Future<int> insertHike(Hike hike) async {
    final db = await database;
    return await db.insert('hikes', hike.toMap());
  }
  /// Get all hikes
  Future<List<Hike>> getAllHikes() async {
    final db = await database;
    final hikeMaps = await db.query('hikes', orderBy: 'title ASC');
    return hikeMaps.map((map) => Hike.fromMap(map)).toList();
  }
  /// Update a hike
  Future<int> updateHike(Hike hike) async {
    final db = await database;
    return await db.update(
        'hikes',
        hike.toMap(),
        where: 'id = ?',
        whereArgs: [hike.id]
    );
  }
  /// Delete a hike
  Future<int> deleteHike(int hikeId) async {
    final db = await database;
    return await db.delete(
        'hikes',
        where: 'id = ?',
        whereArgs: [hikeId]
    );
  }

  /// Add a new observation

  Future<int> insertObservation(Observation observation) async {
    final db = await database;
    return await db.insert('observations', observation.toMap());
  }
  /// Get all observations
  Future<List<Observation>> getAllObservations() async {
    final db = await database;
    final observationMaps = await db.query('observations', orderBy: 'title ASC');
    return observationMaps.map((map) => Observation.fromMap(map)).toList();
  }
  /// Update a observation
  Future<int> updateObservation(Observation observation) async {
    final db = await database;
    return await db.update(
        'observations',
        observation.toMap(),
        where: 'id = ?',
        whereArgs: [observation.id]
    );
  }
  /// Delete a observation
  Future<int> deleteObservation(int observationId) async {
    final db = await database;
    return await db.delete(
        'observations',
        where: 'id = ?',
        whereArgs: [observationId]
    );
  }
}