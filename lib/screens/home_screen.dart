import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/expense.dart';
import 'profile_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final df = DateFormat('dd/MM/yyyy');

    Future<void> _showAddExpenseDialog() async {
      final catCtrl = TextEditingController();
      final valCtrl = TextEditingController();
      DateTime chosen = DateTime.now();

      await showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Adicionar gasto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: catCtrl, decoration: const InputDecoration(labelText: 'Categoria')),
              TextField(controller: valCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Valor')),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Data: ${df.format(chosen)}'),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(context: context, initialDate: chosen, firstDate: DateTime(2000), lastDate: DateTime(2100));
                      if (picked != null) chosen = picked;
                    },
                    child: const Text('Escolher'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                final cat = catCtrl.text.trim();
                final val = double.tryParse(valCtrl.text.replaceAll(',', '.')) ?? 0;
                if (cat.isNotEmpty && val > 0) {
                  app.addExpense(cat, val, chosen);
                  Navigator.pop(c);
                }
              },
              child: const Text('Salvar'),
            )
          ],
        ),
      );
    }

    Future<void> _showEditExpenseDialog(Expense e) async {
      final catCtrl = TextEditingController(text: e.category);
      final valCtrl = TextEditingController(text: e.value.toString());
      DateTime chosen = e.date;

      await showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Editar gasto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: catCtrl, decoration: const InputDecoration(labelText: 'Categoria')),
              TextField(controller: valCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Valor')),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Data: ${df.format(chosen)}'),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(context: context, initialDate: chosen, firstDate: DateTime(2000), lastDate: DateTime(2100));
                      if (picked != null) chosen = picked;
                    },
                    child: const Text('Escolher'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                final cat = catCtrl.text.trim();
                final val = double.tryParse(valCtrl.text.replaceAll(',', '.')) ?? 0;
                if (cat.isNotEmpty && val > 0) {
                  app.editExpense(e.id, cat, val, chosen);
                  Navigator.pop(c);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo, ${app.loggedUser?.username ?? 'Usuário'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              app.logout();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('Rendimento Mensal'),
                subtitle: Text('R\$ ${app.income.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final ctrl = TextEditingController(text: app.income.toString());
                    final value = await showDialog<double?>(
                      context: context,
                      builder: (c) => AlertDialog(
                        title: const Text('Definir rendimento mensal'),
                        content: TextField(controller: ctrl, keyboardType: TextInputType.numberWithOptions(decimal: true)),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancelar')),
                          ElevatedButton(onPressed: () {
                            final v = double.tryParse(ctrl.text.replaceAll(',', '.')) ?? 0.0;
                            Navigator.pop(c, v);
                          }, child: const Text('Salvar')),
                        ],
                      ),
                    );
                    if (value != null) app.setIncome(value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(child: ListTile(title: const Text('Saldo disponível'), subtitle: Text('R\$ ${app.balance.toStringAsFixed(2)}'))),
            const SizedBox(height: 12),
            const Align(alignment: Alignment.centerLeft, child: Text('Gastos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            Expanded(
              child: app.expenses.isEmpty
                  ? const Center(child: Text('Nenhum gasto cadastrado'))
                  : ListView.builder(
                itemCount: app.expenses.length,
                itemBuilder: (context, i) {
                  final e = app.expenses[i];
                  return Dismissible(
                    key: Key(e.id),
                    background: Container(color: Colors.red, alignment: Alignment.centerLeft, padding: const EdgeInsets.only(left: 16), child: const Icon(Icons.delete, color: Colors.white)),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (_) => app.removeExpense(e.id),
                    child: ListTile(
                      title: Text(e.category),
                      subtitle: Text('${df.format(e.date)}'),
                      trailing: Text('R\$ ${e.value.toStringAsFixed(2)}'),
                      onTap: () => _showEditExpenseDialog(e),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            const Align(alignment: Alignment.centerLeft, child: Text('Resumo por categoria', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: app.categorySummary.entries.map((entry) => Chip(label: Text('${entry.key}: R\$ ${entry.value.toStringAsFixed(2)}'))).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
