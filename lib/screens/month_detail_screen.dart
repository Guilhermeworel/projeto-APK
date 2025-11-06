import 'package:flutter/material.dart';
import 'income_screen.dart';

class MonthDetailScreen extends StatefulWidget {
  final String monthName;
  final int year;

  const MonthDetailScreen({super.key, required this.monthName, required this.year});

  @override
  State<MonthDetailScreen> createState() => _MonthDetailScreenState();
}

class _MonthDetailScreenState extends State<MonthDetailScreen> {
  final List<Map<String, dynamic>> expenses = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.monthName} / ${widget.year}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gastos do mês',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Lista de gastos
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
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.attach_money_rounded,
                          color: Colors.green),
                      title: Text(exp['name']),
                      subtitle: Text(
                          'Data: ${exp['date'].day}/${exp['date'].month}'),
                      trailing:
                      Text('R\$ ${exp['amount'].toStringAsFixed(2)}'),
                    ),
                  );
                },
              ),
            ),

            if (showAddExpense)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Descrição do gasto',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Valor em R\$',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: addExpense,
                          icon: const Icon(Icons.check),
                          label: const Text('Salvar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              showAddExpense = false;
                            });
                          },
                          child: const Text('Cancelar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),

      // Botões na parte inferior
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                showAddExpense = !showAddExpense;
              });
            },
            icon: Icon(showAddExpense ? Icons.close : Icons.add),
            label: Text(showAddExpense ? 'Fechar' : 'Adicionar Gasto'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const IncomeScreen()),
              );
            },
            icon: const Icon(Icons.account_balance_wallet_rounded),
            label: const Text('Informar Rendimento'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
