import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contato.dart';
import '../models/user.dart';  // Importar o modelo User também

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
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Criar tabela de contatos
    await db.execute('''
      CREATE TABLE contatos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        telefone TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');

    // Criar tabela de usuários
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Adicionar a tabela de usuários na atualização da versão
      await db.execute('''
        CREATE TABLE usuarios (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL
        )
      ''');
    }
  }

  // Métodos relacionados à tabela "usuarios"
  Future<int> addUsuario(User user) async {
    Database db = await database;
    return await db.insert('usuarios', user.toMap());
  }

  Future<User?> getUsuario(String username, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUsuarioByUsername(String username) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Métodos relacionados à tabela "contatos"
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
