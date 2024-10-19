import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper dbHero = DBHelper._secretDBConstructor();
  static Database? _database;

  DBHelper._secretDBConstructor();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'progressive_overload.db');

    await deleteDatabase(path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      PRAGMA foreign_keys = ON;
    ''');

    await db.execute('''
      CREATE TABLE workout (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        workout_date DATE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE 'set' (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workout_id INTEGER,
        reps INTEGER,
        weight DECIMAL(3, 1),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (workout_id) REFERENCES workout(id)
      )
    ''');
  }
}
