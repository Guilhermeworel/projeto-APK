import 'package:flutter/material.dart';
import '../database/user_session.dart';
import '../database/database.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = UserSession.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil do Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usuário: ${user?['username'] ?? '—'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'E-mail: ${user?['email'] ?? '—'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () async {
                // Vai para a tela de edição
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const _EditProfileScreen()),
                );

                // 🔥 Atualiza a tela ao voltar
                setState(() {});
              },
              icon: const Icon(Icons.edit),
              label: const Text('Editar perfil'),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () {
                UserSession.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////
///  TELA INTERNA PARA EDITAR PERFIL (MESMO ARQUIVO)
//////////////////////////////////////////////

class _EditProfileScreen extends StatefulWidget {
  const _EditProfileScreen();

  @override
  State<_EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<_EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    final user = UserSession.currentUser!;
    nameController = TextEditingController(text: user['username']);
    emailController = TextEditingController(text: user['email']);
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      await DatabaseHelper.instance.updateUser(
        UserSession.currentUserId!,
        nameController.text,
        emailController.text,
      );

      // Atualiza sessão com os novos dados
      await UserSession.loadUser();

      // Volta para a tela de perfil
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Perfil")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nome"),
                validator: (v) => v!.isEmpty ? "Informe o nome" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) => v!.isEmpty ? "Informe o email" : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _save,
                child: const Text("Salvar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
