import 'package:flutter/material.dart';
import 'routes/route_generator.dart';
import 'routes/app_routes.dart';
//main
void main() {
  runApp(SunkeeperApp());
}

class SunkeeperApp extends StatelessWidget {
  const SunkeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Captain Ray & The Sunkeeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFFFC107), // Sun-like yellow
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
