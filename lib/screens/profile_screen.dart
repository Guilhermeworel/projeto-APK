import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil do Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Usuário: exemplo', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            const Text('E-mail: exemplo@email.com', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              label: const Text('Editar e-mail'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.lock),
              label: const Text('Alterar senha'),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushReplacementNamed(context, '/'),
              icon: const Icon(Icons.logout),
              label: const Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}
