import 'package:flutter/material.dart';
import 'package:untitled/database/database.dart';
import 'package:untitled/database/user_session.dart';
import 'income_screen.dart';

class MonthDetailScreen extends StatefulWidget {
  final String monthName;
  final int year;

  const MonthDetailScreen(
      {super.key, required this.monthName, required this.year,});

  @override
  State<MonthDetailScreen> createState() => _MonthDetailScreenState();
}

class _MonthDetailScreenState extends State<MonthDetailScreen> {
  List<Map<String, dynamic>> expenses = [];
  double? income;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  bool showAddExpense = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final userId = UserSession.currentUserId;
    if (userId == null) return;

    final db = DatabaseHelper.instance;

    final loadedIncome = await db.getIncome(
    userId,
    widget.year,
    _monthNumber(widget.monthName),
    );

    final loadedExpenses = await db.getExpensesByMonth(
    userId,
    widget.year,
    _monthNumber(widget.monthName),
    );

    setState(() {
    income = loadedIncome;
    expenses = loadedExpenses.map((e) {
    return {
    "id": e["id"],
    "name": e["name"],
    "amount": e["amount"],
    "date": e["date"],
    };
    }).toList();
    });

  }

  int _monthNumber(String name) {
    const months = {
      'Janeiro': 1,
      'Fevereiro': 2,
      'Março': 3,
      'Abril': 4,
      'Maio': 5,
      'Junho': 6,
      'Julho': 7,
      'Agosto': 8,
      'Setembro': 9,
      'Outubro': 10,
      'Novembro': 11,
      'Dezembro': 12,
    };
    return months[name]!;
  }

  Future<void> addExpense() async {
    final name = nameController.text.trim();
    final amount = double.tryParse(amountController.text.trim());
    if (name.isEmpty || amount == null) return;


    final userId = UserSession.currentUserId;
    if (userId == null) return;

    final date = DateTime.now();
    final month = _monthNumber(widget.monthName);

    final id = await DatabaseHelper.instance.addExpense(
      userId, widget.year, month, name, amount, date.toIso8601String(),);

    setState(() {
      expenses.insert(0, {
        'id': id,
        'name': name,
        'amount': amount,
        'date': date.toIso8601String(),
      });
    });

    nameController.clear();
    amountController.clear();
    showAddExpense = false;
  }

  Future<void> deleteExpense(int id) async {
    await DatabaseHelper.instance.deleteExpense(id);
    setState(() {
      expenses.removeWhere((e) => e['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final month = widget.monthName;
    final year = widget.year;


    return Scaffold(appBar: AppBar(title: Text("$month / $year"),
      actions: [
        IconButton(
          icon: const Icon(Icons.account_balance_wallet), onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) =>
              IncomeScreen(monthName: widget.monthName, year: widget.year,),),);
          _loadData();
        },),
      ],),
      body: Column(children: [
        if (income != null)Padding(padding: const EdgeInsets.all(14),
          child: Container(padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade300),),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Rendimento: R\$ ${income!.toStringAsFixed(2)}",
                  style: TextStyle(color: Colors.blue.shade900,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,),),
                const SizedBox(height: 6),
                Text("Gastos: R\$ ${_totalExpenses.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16, color: Colors.redAccent,),),
                const SizedBox(height: 6),
                Text("Saldo: R\$ ${_balance.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _balance >= 0 ? Colors.green.shade700 : Colors.red
                        .shade700,),),
              ],),),),
        Expanded(child: expenses.isEmpty
            ? const Center(child: Text(
          "Nenhum gasto registrado.", style: TextStyle(color: Colors.grey),),)
            : ListView.builder(
          itemCount: expenses.length, itemBuilder: (context, i) {
          final e = expenses[i];
          final date = DateTime.tryParse(e["date"] ?? "");

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6,),
            child: ListTile(title: Text(e["name"]),
              subtitle: Text(
                date == null ? "Data inválida" : "${date.day}/${date
                    .month}/${date.year}",),
              trailing: Row(mainAxisSize: MainAxisSize.min,
                children: [
                  Text("R\$ ${e["amount"].toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold,),),
                  IconButton(icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteExpense(e["id"]),),
                ],),),);
        },),),
        if (showAddExpense)Padding(padding: const EdgeInsets.all(16),
          child: Column(children: [
            TextField(controller: nameController,
              decoration: const InputDecoration(
                labelText: "Descrição", border: OutlineInputBorder(),),),
            const SizedBox(height: 12),
            TextField(controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Valor (R\$)", border: OutlineInputBorder(),),),
            const SizedBox(height: 12),
            ElevatedButton.icon(onPressed: addExpense,
              icon: const Icon(Icons.check),
              label: const Text("Salvar"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green,
                foregroundColor: Colors.white,),),
          ],),),
      ],),
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          showAddExpense = !showAddExpense;
        });
      }, child: Icon(showAddExpense ? Icons.close : Icons.add),),);
  }

  double get _totalExpenses {
    return expenses.fold(0.0, (sum, e) => sum + (e["amount"] as double));
  }

  double get _balance {
    return (income ?? 0) - _totalExpenses;
  }
}
