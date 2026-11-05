import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BancoLocalizacoes {
  static final BancoLocalizacoes instance = BancoLocalizacoes._init();
  static Database? _database;

  BancoLocalizacoes._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('localizacoes.db');
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

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE localizacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        precisao REAL NOT NULL,
        instante TEXT NOT NULL
      )
    ''');
  }
}