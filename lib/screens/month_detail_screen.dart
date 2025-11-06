import 'package:flutter/material.dart';
import 'income_screen.dart';

class MonthDetailScreen extends StatefulWidget {
  final String monthName;
  final int year;

  const MonthDetailScreen({
    super.key,
    required this.monthName,
    required this.year,
  });

  @override
  State<MonthDetailScreen> createState() => _MonthDetailScreenState();
}

class _MonthDetailScreenState extends State<MonthDetailScreen> {
  final List<Map<String, dynamic>> expenses = [];
  double? income; // Rendimento do mês
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  bool showAddExpense = false;

  void addExpense() {
    final name = nameController.text.trim();
    final amount = double.tryParse(amountController.text.trim());

    if (name.isNotEmpty && amount != null) {
      setState(() {
        expenses.add({
          'name': name,
          'amount': amount,
          'date': DateTime.now(),
        });
        nameController.clear();
        amountController.clear();
        showAddExpense = false;
      });
    }
  }

  Future<void> navigateToIncomeScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const IncomeScreen()),
    );

    if (result != null && result is double) {
      setState(() {
        income = result;
      });
    }
  }

  double get totalExpenses =>
      expenses.fold(0.0, (sum, e) => sum + (e['amount'] as double));

  double get balance => (income ?? 0) - totalExpenses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.monthName} / ${widget.year}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exibir rendimento e balanço
            if (income != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rendimento: R\$ ${income!.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Gastos: R\$ ${totalExpenses.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Saldo: R\$ ${balance.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: balance >= 0 ? Colors.green.shade800 : Colors.red.shade800,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            const Text(
              'Gastos do mês',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            if (showAddExpense)
              Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição do gasto',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Valor em R\$',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() => showAddExpense = false);
                        },
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton.icon(
                        onPressed: addExpense,
                        icon: const Icon(Icons.check),
                        label: const Text('Salvar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),

            Expanded(
              child: expenses.isEmpty
                  ? const Center(
                child: Text(
                  'Nenhum gasto adicionado ainda.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final exp = expenses[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading:
                      const Icon(Icons.attach_money, color: Colors.green),
                      title: Text(exp['name']),
                      subtitle: Text(
                          'Data: ${exp['date'].day}/${exp['date'].month}/${exp['date'].year}'),
                      trailing: Text(
                        'R\$ ${exp['amount'].toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Botões lado a lado (altura ajustada)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        showAddExpense = !showAddExpense;
                      });
                    },
                    icon: Icon(showAddExpense ? Icons.close : Icons.add),
                    label: Text(showAddExpense ? 'Fechar' : 'Adicionar Gasto'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: navigateToIncomeScreen,
                    icon: const Icon(Icons.account_balance_wallet_rounded),
                    label: const Text('Informar Rendimento'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10), // altura reduzida
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
