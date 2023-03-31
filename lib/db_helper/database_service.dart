import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'permissions_database.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  // When the database is first created, create a table to store breeds
// and a table to store dogs.
  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {logs} TABLE statement on the database.
    await db.execute(
      "CREATE TABLE permission_logs(id INTEGER PRIMARY KEY, permission TEXT, is_granted INTEGER, date TEXT, user TEXT)",
    );
  }
}
