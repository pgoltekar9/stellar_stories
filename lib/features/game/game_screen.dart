import 'package:flutter/material.dart';
import 'package:project_helios/features/game/solar_system_view.dart';// your existing SolarSystemView

class SolarSystemGameScreen extends StatelessWidget {
  const SolarSystemGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Your full solar system game view
          const SolarSystemView(),

          // Back button
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
