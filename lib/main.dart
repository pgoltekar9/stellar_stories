import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_helios/routes/route_generator.dart';
import 'package:project_helios/routes/AppRoutes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(const SunkeeperApp());
}

class SunkeeperApp extends StatelessWidget {
  const SunkeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Captain Ray & The Sunkeeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B132B),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.orangeAccent,
        ),
      ),

      // ✅ Start with splash
      initialRoute: AppRoutes.splash,

      // ✅ All navigation handled by RouteGenerator
      onGenerateRoute: RouteGenerator.generateRoute,

    );
  }
}
