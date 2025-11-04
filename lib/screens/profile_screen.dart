import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final user = app.loggedUser;

    Future<void> _changePassword() async {
      final oldCtrl = TextEditingController();
      final newCtrl = TextEditingController();
      final confirmCtrl = TextEditingController();

      final res = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('Alterar senha'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: oldCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Senha atual')),
                TextField(controller: newCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Nova senha')),
                TextField(controller: confirmCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Confirmar nova senha')),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancelar')),
              ElevatedButton(
                onPressed: () {
                  if (newCtrl.text != confirmCtrl.text) {
                    // keep dialog open; show snackbar outside instead
                    Navigator.pop(c, false);
                    return;
                  }
                  Navigator.pop(c, true);
                },
                child: const Text('Salvar'),
              )
            ],
          ));

      if (res == true) {
        if (user == null) return;
        final ok = app.changePassword(user.username, oldCtrl.text, newCtrl.text);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Senha alterada' : 'Senha atual incorreta')));
      } else if (res == false && newCtrl.text != confirmCtrl.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('As senhas não coincidem')));
      }
    }

    Future<void> _editEmail() async {
      final ctrl = TextEditingController(text: user?.email ?? '');
      final res = await showDialog<String?>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Editar e-mail'),
          content: TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'E-mail')),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancelar')),
            ElevatedButton(onPressed: () => Navigator.pop(c, ctrl.text.trim()), child: const Text('Salvar')),
          ],
        ),
      );
      if (res != null && user != null) {
        app.updateEmail(user.username, res.isEmpty ? null : res);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('E-mail atualizado')));
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil do Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Usuário: ${user?.username ?? '-'}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('E-mail: ${user?.email ?? 'Não informado'}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton.icon(onPressed: _editEmail, icon: const Icon(Icons.edit), label: const Text('Editar e-mail')),
            const SizedBox(height: 12),
            ElevatedButton.icon(onPressed: _changePassword, icon: const Icon(Icons.lock), label: const Text('Alterar senha')),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                app.logout();
                // Consumer in main will return to login
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sair'),
            )
          ],
        ),
      ),
    );
  }
}
