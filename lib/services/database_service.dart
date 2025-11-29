import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/hike.dart';
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
      name TEXT NOT NULL,
      location TEXT NOT NULL,
      date TEXT NOT NULL,
      length REAL NOT NULL,
      parkingAvailable INTEGER NOT NULL,
      difficulty TEXT NOT NULL,
      description TEXT
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
    final hikeMaps = await db.query('hikes', orderBy: 'name ASC');
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
  /// Delete all hikes
  Future<int> deleteAllHikes() async {
    final db = await database;
    return await db.delete('hikes');
  }
}