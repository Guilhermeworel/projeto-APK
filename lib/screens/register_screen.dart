import 'package:flutter/material.dart';
import 'package:untitled/database/database.dart';
import 'package:untitled/database/user_session.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> register() async {
    final db = DatabaseHelper.instance;


    final id = await db.createUser(
    usernameController.text,
    emailController.text,
    passwordController.text,
    );

// Salva o usuário automaticamente
    await UserSession.saveUser(id);

    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Conta criada com sucesso!")),
    );

    Navigator.pushReplacementNamed(context, '/home');


    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Criar conta")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Senha"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              child: Text("Registrar"),
            ),
          ],
        ),
      ),
    );
  }
}
