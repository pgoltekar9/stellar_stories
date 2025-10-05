import 'package:flutter/material.dart';
import 'package:nasa_hackathon/features/game/game_screen.dart';
import 'package:nasa_hackathon/features/home/home_screen.dart';
import 'package:nasa_hackathon/features/splash/splash_screen.dart';
import 'package:nasa_hackathon/features/story/story_screen.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //f
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case AppRoutes.story:
        return MaterialPageRoute(
          builder: (_) => StoryScreen(story: args),
        );

      case AppRoutes.game:
        return MaterialPageRoute(builder: (_) => GameScreen());

      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(String? routeName) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'No route defined for $routeName',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
