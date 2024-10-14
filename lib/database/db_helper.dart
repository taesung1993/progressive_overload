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
    return await openDatabase(path, version: 1);
  }
}
