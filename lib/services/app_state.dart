import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/expense.dart';
import 'package:uuid/uuid.dart';

class AppState extends ChangeNotifier {
  final List<User> _users = [];
  User? _loggedUser;
  final List<Expense> _expenses = [];
  double _income = 0.0;

  User? get loggedUser => _loggedUser;
  List<Expense> get expenses => _expenses;
  double get income => _income;

  // ---- USUÁRIO ----
  bool register(String username, String password) {
    if (_users.any((u) => u.username == username)) return false;
    _users.add(User(username: username, password: password));
    notifyListeners();
    return true;
  }

  bool login(String username, String password) {
    final user = _users.firstWhere(
          (u) => u.username == username && u.password == password,
      orElse: () => User(username: '', password: ''),
    );
    if (user.username.isEmpty) return false;
    _loggedUser = user;
    notifyListeners();
    return true;
  }

  void logout() {
    _loggedUser = null;
    notifyListeners();
  }

  // ---- FINANCEIRO ----
  void addExpense(String category, double value, DateTime date) {
    final newExpense = Expense(
      id: const Uuid().v4(),
      category: category,
      value: value,
      date: date,
    );
    _expenses.add(newExpense);
    notifyListeners();
  }

  void editExpense(String id, String newCategory, double newValue, DateTime newDate) {
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index != -1) {
      _expenses[index] = Expense(
        id: id,
        category: newCategory,
        value: newValue,
        date: newDate,
      );
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

  double get balance => _income - _expenses.fold(0, (sum, e) => sum + e.value);

  Map<String, double> get categorySummary {
    final Map<String, double> summary = {};
    for (var e in _expenses) {
      summary[e.category] = (summary[e.category] ?? 0) + e.value;
    }
    return summary;
  }
}
