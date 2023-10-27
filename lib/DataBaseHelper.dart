import 'package:nihon/User.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._();

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getApplicationDocumentsDirectory();
    final path = join(databasePath.path, 'helpDB.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,

    );

  }


  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE User (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sinhala TEXT,
        japan TEXT
      )
    ''');
  }
  Future<int> insertData(String sinhala, String japan) async {
    final db = await instance.database;
    final Map<String, dynamic> row = {
      'sinhala': sinhala,
      'japan': japan,
    };
    return await db.insert('User', row);
  }
  Future<List<Map<String, dynamic>>> getData() async {
    final db = await instance.database;
    return await db.query('User');
  }
  Future<String?> findColumnValueById(String table, String columnName, int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      columns: [columnName],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.first[columnName] as String?;
    } else {
      return null;
    }
  }
}


