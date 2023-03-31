import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('permissions_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute(
      "CREATE TABLE permission_logs(id INTEGER PRIMARY KEY, permission TEXT, is_granted INTEGER, date TEXT, user TEXT)",
    );
  }

  Future<List<Map<String, dynamic>>> getLogs() async {
    final db = await instance.database;
    return await db.query('permission_logs');
  }

  Future<void> insertLog(String permission, bool isGranted) async {
    final db = await instance.database;
    final DateTime now = DateTime.now();
    final String formattedDate = "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}";
    await db.insert(
      'permission_logs',
      {
        'permission': permission,
        'is_granted': isGranted ? 1 : 0,
        'date': formattedDate,
        'user': 'user1', // TODO: replace with actual user ID
      },
    );
  }
}
