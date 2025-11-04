import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool _isRegister = false;
  String _message = '';

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final app = context.read<AppState>();
    final user = _usernameCtrl.text.trim();
    final pass = _passwordCtrl.text;
    final email = _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim();

    if (user.isEmpty || pass.isEmpty) {
      setState(() => _message = 'Preencha usuário e senha.');
      return;
    }

    if (_isRegister) {
      final ok = app.register(user, pass, email: email);
      if (ok) {
        setState(() {
          _message = 'Cadastro realizado. Faça login.';
          _isRegister = false;
          _passwordCtrl.clear();
        });
      } else {
        setState(() => _message = 'Usuário já existe.');
      }
    } else {
      final ok = app.login(user, pass);
      if (!ok) {
        setState(() => _message = 'Falha no login. Verifique usuário/senha.');
      } else {
        // Consumer in main will update and navigate to HomeScreen automatically
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(_isRegister ? 'Cadastro' : 'Login', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(controller: _usernameCtrl, decoration: const InputDecoration(labelText: 'Usuário')),
                const SizedBox(height: 8),
                TextField(controller: _passwordCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Senha')),
                const SizedBox(height: 8),
                if (_isRegister) TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'E-mail (opcional)')),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _submit, child: Text(_isRegister ? 'Cadastrar' : 'Entrar')),
                TextButton(
                  onPressed: () => setState(() {
                    _isRegister = !_isRegister;
                    _message = '';
                  }),
                  child: Text(_isRegister ? 'Já tenho conta' : 'Quero me cadastrar'),
                ),
                if (_message.isNotEmpty) Text(_message, style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
