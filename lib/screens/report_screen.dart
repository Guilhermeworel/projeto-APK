import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dados = [
      {'ano': 2025, 'mes': 'Janeiro', 'gastos': 1250.0},
      {'ano': 2025, 'mes': 'Fevereiro', 'gastos': 980.0},
      {'ano': 2025, 'mes': 'Março', 'gastos': 1100.0},
      {'ano': 2024, 'mes': 'Dezembro', 'gastos': 800.0},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório Geral'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: dados.length,
          itemBuilder: (context, index) {
            final item = dados[index];
            return Card(
              child: ListTile(
                title: Text('${item['mes']} de ${item['ano']}'),
                subtitle: Text('Gasto total: R\$ ${item['gastos']}'),
                trailing: const Icon(Icons.bar_chart),
              ),
            );
          },
        ),
      ),
    );
  }
}
