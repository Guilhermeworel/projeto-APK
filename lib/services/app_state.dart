import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/expense.dart';

class AppState extends ChangeNotifier {
  final Map<String, User> _users = {}; // username -> User
  User? _loggedUser;
  final List<Expense> _expenses = [];
  double _income = 0.0;

  User? get loggedUser => _loggedUser;
  List<Expense> get expenses => List.unmodifiable(_expenses);
  double get income => _income;

  // ---- Hashing ----
  String _hash(String plain) {
    final bytes = utf8.encode(plain);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // ---- Auth ----
  bool register(String username, String password, {String? email}) {
    if (_users.containsKey(username)) return false;
    final hashed = _hash(password);
    _users[username] = User(username: username, passwordHash: hashed, email: email);
    notifyListeners();
    return true;
  }

  bool login(String username, String password) {
    final u = _users[username];
    if (u == null) return false;
    final hashed = _hash(password);
    if (u.passwordHash != hashed) return false;
    _loggedUser = u;
    notifyListeners();
    return true;
  }

  void logout() {
    _loggedUser = null;
    notifyListeners();
  }

  bool changePassword(String username, String oldPassword, String newPassword) {
    final u = _users[username];
    if (u == null) return false;
    if (u.passwordHash != _hash(oldPassword)) return false;
    u.passwordHash = _hash(newPassword);
    // if current logged user changed his password, update reference too
    if (_loggedUser?.username == username) _loggedUser = u;
    notifyListeners();
    return true;
  }

  bool updateEmail(String username, String? newEmail) {
    final u = _users[username];
    if (u == null) return false;
    u.email = newEmail;
    if (_loggedUser?.username == username) _loggedUser = u;
    notifyListeners();
    return true;
  }

  // ---- Financeiro (em memória) ----
  void addExpense(String category, double value, DateTime date) {
    _expenses.add(Expense(category: category, value: value, date: date));
    notifyListeners();
  }

  void editExpense(String id, String newCategory, double newValue, DateTime newDate) {
    final idx = _expenses.indexWhere((e) => e.id == id);
    if (idx != -1) {
      _expenses[idx] = Expense(id: id, category: newCategory, value: newValue, date: newDate);
      notifyListeners();
    }
  }

  void removeExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void setIncome(double value) {
    _income = value;
    notifyListeners();
  }

  double get balance => _income - _expenses.fold<double>(0.0, (s, e) => s + e.value);

  Map<String, double> get categorySummary {
    final Map<String, double> map = {};
    for (final e in _expenses) {
      map[e.category] = (map[e.category] ?? 0.0) + e.value;
    }
    return map;
  }
}
