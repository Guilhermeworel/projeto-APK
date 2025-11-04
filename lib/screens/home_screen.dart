import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/expense.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo, ${appState.loggedUser?.username}!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: appState.logout,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 3,
              child: ListTile(
                title: const Text('Rendimento Mensal'),
                subtitle: Text('R\$ ${appState.income.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final controller = TextEditingController();
                    final value = await showDialog<double>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Informe seu rendimento mensal'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: 'Ex: 2500'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              final val = double.tryParse(controller.text) ?? 0;
                              Navigator.pop(context, val);
                            },
                            child: const Text('Salvar'),
                          ),
                        ],
                      ),
                    );
                    if (value != null) appState.setIncome(value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 3,
              child: ListTile(
                title: const Text('Saldo Disponível'),
                subtitle: Text('R\$ ${appState.balance.toStringAsFixed(2)}'),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: appState.expenses.length,
                itemBuilder: (context, index) {
                  final Expense e = appState.expenses[index];
                  return ListTile(
                    title: Text(e.category),
                    subtitle: Text(e.date.toString().split(' ')[0]),
                    trailing: Text('R\$ ${e.value.toStringAsFixed(2)}'),
                    onLongPress: () => appState.removeExpense(e.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final categoryController = TextEditingController();
          final valueController = TextEditingController();
          final date = DateTime.now();

          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Novo Gasto'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: categoryController,
                    decoration: const InputDecoration(labelText: 'Categoria'),
                  ),
                  TextField(
                    controller: valueController,
                    decoration: const InputDecoration(labelText: 'Valor'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    final category = categoryController.text;
                    final value = double.tryParse(valueController.text) ?? 0;
                    if (category.isNotEmpty && value > 0) {
                      appState.addExpense(category, value, date);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Salvar'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
