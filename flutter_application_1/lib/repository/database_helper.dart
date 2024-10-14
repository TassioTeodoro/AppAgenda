import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contato.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'contatos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contatos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        telefone TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');
  }

  Future<int> addContato(Contato contato) async {
    Database db = await database;
    return await db.insert('contatos', contato.toMap());
  }

  Future<int> updateContato(Contato contato) async {
    Database db = await database;
    return await db.update(
      'contatos',
      contato.toMap(),
      where: 'id = ?',
      whereArgs: [contato.id],
    );
  }

  Future<int> deleteContato(int id) async {
    Database db = await database;
    return await db.delete(
      'contatos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Contato>> getContatos() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('contatos');

    return List.generate(maps.length, (i) {
      return Contato.fromMap(maps[i]);
    });
  }
}
