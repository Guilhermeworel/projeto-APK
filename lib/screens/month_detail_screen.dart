import 'package:flutter/material.dart';

class MonthDetailScreen extends StatelessWidget {
  final String monthName;

  const MonthDetailScreen({super.key, required this.monthName});

  @override
  Widget build(BuildContext context) {
    final gastos = [
      {'categoria': 'Alimentação', 'valor': 250.0, 'data': '02/11'},
      {'categoria': 'Transporte', 'valor': 80.0, 'data': '05/11'},
      {'categoria': 'Lazer', 'valor': 120.0, 'data': '10/11'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Gastos - $monthName'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumo de Gastos',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: gastos.length,
                itemBuilder: (context, index) {
                  final gasto = gastos[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.attach_money),
                      title: Text(gasto['categoria'].toString()),
                      subtitle: Text('Data: ${gasto['data']}'),
                      trailing: Text('R\$ ${gasto['valor']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Adicionar Gasto'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
