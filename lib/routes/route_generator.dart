import 'package:flutter/material.dart';
import 'package:project_helios/features/game/game_screen.dart';
import 'package:project_helios/features/splash/splash_screen.dart';
import 'package:project_helios/features/story/CaptainRayPage1.dart';
import '../features/home/home_screen.dart';
import 'AppRoutes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case AppRoutes.game:
        return MaterialPageRoute(builder: (_) => SolarSystemGameScreen());
      case AppRoutes.story:
        return MaterialPageRoute(builder: (_) => const CaptainRayPage1());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Unknown route: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
