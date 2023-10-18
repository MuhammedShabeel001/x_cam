import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PhotoDatabase {
  static final PhotoDatabase _instance = PhotoDatabase._internal();

  factory PhotoDatabase() => _instance;

  PhotoDatabase._internal();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'photos.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE photos(id INTEGER PRIMARY KEY, path TEXT)',
        );
      },
    );
  }

  Future<void> insertPhoto(String path) async {
    final db = await database;
    if (db == null) {
      return;
    }
    try {
      await db.insert('photos', {'path': path});
    } catch (e) {
      print('Error inserting photo: $e');
    }
  }

  Future<List<String>> getAllPhotos() async {
    final db = await database;
    if (db == null) {
      return [];
    }
    try {
      final List<Map<String, dynamic>> maps = await db.query('photos');
      return List.generate(maps.length, (i) {
        return maps[i]['path'] as String;
      });
    } catch (e) {
      print('Error fetching photos: $e');
      return [];
    }
  }
}
