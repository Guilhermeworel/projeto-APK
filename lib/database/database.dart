import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Database? _database;

  Future<void> initDatabase() async {
    _database = await _initDB("finance_app.db");
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tabela de usuários
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
          )
        ''');

        // Rendimento de cada mês
        await db.execute('''
          CREATE TABLE incomes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            year INTEGER,
            month INTEGER,
            income REAL,
            UNIQUE(user_id, year, month)
          )
        ''');

        // Gastos de cada mês
        await db.execute('''
          CREATE TABLE expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            year INTEGER,
            month INTEGER,
            name TEXT,
            amount REAL,
            date TEXT
          )
        ''');
      },
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    await initDatabase();
    return _database!;
  }

  // -------------------------------------------------------
  // USUÁRIOS
  // -------------------------------------------------------

  Future<int> createUser(String username, String email, String password) async {
    final db = await database;
    return await db.insert(
      "users",
      {
        "username": username,
        "email": email,
        "password": password,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await database;
    final res = await db.query(
      "users",
      where: "email = ? AND password = ?",
      whereArgs: [email, password],
    );
    if (res.isNotEmpty) return res.first;
    return null;
  }

  /// Busca usuário por id — retorna null se não encontrado
  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await database;
    final res = await db.query(
      "users",
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );

    if (res.isNotEmpty) return res.first;
    return null;
  }

  /// Atualiza nome e email do usuário. Retorna número de linhas afetadas.
  Future<int> updateUser(int id, String username, String email) async {
    final db = await database;
    return await db.update(
      "users",
      {
        "username": username,
        "email": email,
      },
      where: "id = ?",
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  // -------------------------------------------------------
  // RENDIMENTO DO MÊS
  // -------------------------------------------------------

  Future<void> saveIncome(int userId, int year, int month, double income) async {
    final db = await database;

    // try insert; on conflict replace the income
    await db.insert(
      "incomes",
      {
        "user_id": userId,
        "year": year,
        "month": month,
        "income": income,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<double?> getIncome(int userId, int year, int month) async {
    final db = await database;

    final res = await db.query(
      "incomes",
      where: "user_id = ? AND year = ? AND month = ?",
      whereArgs: [userId, year, month],
      limit: 1,
    );

    if (res.isNotEmpty) {
      final val = res.first["income"];
      if (val is int) return val.toDouble();
      if (val is double) return val;
      if (val is num) return val.toDouble();
    }
    return null;
  }

  // -------------------------------------------------------
  // GASTOS
  // -------------------------------------------------------

  Future<int> addExpense(
      int userId,
      int year,
      int month,
      String name,
      double amount,
      String date,
      ) async {
    final db = await database;

    return await db.insert(
      "expenses",
      {
        "user_id": userId,
        "year": year,
        "month": month,
        "name": name,
        "amount": amount,
        "date": date,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getExpensesByMonth(
      int userId,
      int year,
      int month,
      ) async {
    final db = await database;

    return await db.query(
      "expenses",
      where: "user_id = ? AND year = ? AND month = ?",
      whereArgs: [userId, year, month],
      orderBy: "date DESC",
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete(
      "expenses",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateExpense(
      int id,
      String name,
      double amount,
      String date,
      ) async {
    final db = await database;

    return await db.update(
      "expenses",
      {
        "name": name,
        "amount": amount,
        "date": date,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
