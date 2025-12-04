import 'package:flutter/material.dart';
import 'package:untitled/database/database.dart';
import 'package:untitled/database/user_session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    final db = DatabaseHelper.instance;


    final user = await db.getUser(
    emailController.text,
    passwordController.text,
    );

    if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Usuário ou senha incorretos")),
    );
    return;
    }

// Salva sessão do usuário
    await UserSession.saveUser(user["id"]);

    Navigator.pushReplacementNamed(context, '/home');


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bem-vindo!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: const Text('Entrar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Criar conta'),
            )
          ],
        ),
      ),
    );
  }
}
