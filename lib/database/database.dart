import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Database? _database;

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), "finance.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            password TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE incomes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL NOT NULL,
            month TEXT NOT NULL,
            year INTEGER NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            description TEXT NOT NULL,
            amount REAL NOT NULL,
            month TEXT NOT NULL,
            year INTEGER NOT NULL,
            date TEXT NOT NULL
          );
        ''');
      },
    );
  }

  // ==============================
  // USERS
  // ==============================
  Future<int> registerUser(String username, String password) async {
    final db = await database;

    return await db.insert("users", {
      "username": username,
      "password": password,
    });
  }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    final db = await database;

    final res = await db.query(
      "users",
      where: "username = ? AND password = ?",
      whereArgs: [username, password],
    );

    if (res.isNotEmpty) return res.first;
    return null;
  }

  // ==============================
  // INCOME
  // ==============================
  Future<void> saveIncome(double value, String month, int year) async {
    final db = await database;

    await db.insert("incomes", {
      "amount": value,
      "month": month,
      "year": year,
    });
  }

  Future<double?> getIncome(String month, int year) async {
    final db = await database;

    final res = await db.query(
      "incomes",
      where: "month = ? AND year = ?",
      whereArgs: [month, year],
    );

    if (res.isEmpty) return null;
    return res.last["amount"] as double;
  }

  // ==============================
  // EXPENSES
  // ==============================
  Future<void> saveExpense(
      String description, double amount, String month, int year) async {
    final db = await database;

    await db.insert("expenses", {
      "description": description,
      "amount": amount,
      "month": month,
      "year": year,
      "date": DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getExpenses(
      String month, int year) async {
    final db = await database;

    return await db.query(
      "expenses",
      where: "month = ? AND year = ?",
      whereArgs: [month, year],
      orderBy: "date DESC",
    );
  }
}
