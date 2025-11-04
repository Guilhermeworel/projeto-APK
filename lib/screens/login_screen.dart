import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoginMode = true;
  String message = '';

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle Financeiro'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  isLoginMode ? 'Login' : 'Cadastro',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Usuário'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Senha'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final username = usernameController.text.trim();
                    final password = passwordController.text.trim();

                    if (isLoginMode) {
                      final success = appState.login(username, password);
                      if (!success) {
                        setState(() => message = 'Usuário ou senha incorretos!');
                      }
                    } else {
                      final success = appState.register(username, password);
                      setState(() => message = success
                          ? 'Usuário cadastrado com sucesso!'
                          : 'Usuário já existe!');
                    }
                  },
                  child: Text(isLoginMode ? 'Entrar' : 'Cadastrar'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    setState(() => isLoginMode = !isLoginMode);
                  },
                  child: Text(isLoginMode
                      ? 'Não tem conta? Cadastre-se'
                      : 'Já tem conta? Faça login'),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  style: const TextStyle(color: Colors.red),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
