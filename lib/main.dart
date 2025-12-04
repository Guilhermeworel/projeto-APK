import 'package:flutter/material.dart';
import 'database/database.dart';
import 'database/user_session.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/month_detail_screen.dart';
import 'screens/income_screen.dart';
import 'screens/report_screen.dart';
import 'screens/profile_screen.dart';  // ← ADICIONADO

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.instance.initDatabase();
  await UserSession.loadUser();

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

      /// Se está logado → vai para home
      /// Se não → vai para login
      initialRoute:
      UserSession.currentUserId == null ? '/login' : '/home',

      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => RegisterScreen(),
        '/home': (_) => const HomeScreen(),
        '/report': (_) => const ReportScreen(),
        '/profile': (_) => const ProfileScreen(),   // ← ADICIONADA
      },

      onGenerateRoute: (settings) {
        /// Rota para detalhes do mês
        if (settings.name == '/month_detail') {
          final args = settings.arguments;

          if (args is Map<String, dynamic>) {
            return MaterialPageRoute(
              builder: (_) => MonthDetailScreen(
                monthName: args['month'],
                year: args['year'],
              ),
            );
          }
          return _erro('Argumentos inválidos para /month_detail');
        }

        /// Rota para rendimentos
        if (settings.name == '/income') {
          final args = settings.arguments;

          if (args is Map<String, dynamic>) {
            return MaterialPageRoute(
              builder: (_) => IncomeScreen(
                monthName: args['month'],
                year: args['year'],
              ),
            );
          }
          return _erro('Argumentos inválidos para /income');
        }

        return null;
      },
    );
  }

  /// Tela padrão de erro
  MaterialPageRoute _erro(String msg) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("Erro")),
        body: Center(
          child: Text(
            msg,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
