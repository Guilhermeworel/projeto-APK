import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/month_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle Financeiro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        scaffoldBackgroundColor: Colors.grey[100],
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/month_detail') {
          final args = settings.arguments;
          if (args is String) {
            return MaterialPageRoute(
              builder: (_) => MonthDetailScreen(monthName: args),
            );
          } else {
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(
                  child: Text('Erro: argumento inválido para /month_detail'),
                ),
              ),
            );
          }
        }
        return null;
      },
    );
  }
}
