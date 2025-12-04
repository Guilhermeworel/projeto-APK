import 'package:flutter/material.dart';
import 'package:untitled/database/database.dart';
import 'package:untitled/database/user_session.dart';

class IncomeScreen extends StatelessWidget {
  final String monthName;
  final int year;

  const IncomeScreen({
    super.key,
    required this.monthName,
    required this.year,
  });

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

  @override
  Widget build(BuildContext context) {
    final TextEditingController incomeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rendimento Mensal'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Informe o seu rendimento de $monthName / $year',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: incomeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor em R\$',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                final value = double.tryParse(incomeController.text);
                if (value == null) {
                  Navigator.pop(context, null);
                  return;
                }

                final userId = UserSession.currentUserId;
                if (userId == null) {
                  Navigator.pop(context, null);
                  return;
                }

                await DatabaseHelper.instance.saveIncome(
                  userId,
                  year,
                  _monthNumber(monthName),
                  value,
                );

                Navigator.pop(context, value);
              },
              icon: const Icon(Icons.check),
              label: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
