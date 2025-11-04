import 'package:uuid/uuid.dart';

class Expense {
  String id;
  String category;
  double value;
  DateTime date;

  Expense({
    String? id,
    required this.category,
    required this.value,
    required this.date,
  }) : id = id ?? const Uuid().v4();
}
