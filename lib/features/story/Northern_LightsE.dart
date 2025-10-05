import 'package:flutter/material.dart';
import 'package:project_helios/features/home/home_screen.dart';
import 'aurora_ribbon_painter.dart';
import 'dart:math' as math;

class AuroraEndPage extends StatefulWidget {
  const AuroraEndPage({super.key});

  @override
  State<AuroraEndPage> createState() => _AuroraEndPageState();
}

class _AuroraEndPageState extends State<AuroraEndPage> with TickerProviderStateMixin {
  late AnimationController _starController;
  late AnimationController _ribbonController;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _ribbonController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _starController.dispose();
    _ribbonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0B1B3F),
                  Color(0xFF001F3F),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Twinkling stars
          ...List.generate(50, (index) {
            final random = math.Random(index);
            return AnimatedBuilder(
              animation: _starController,
              builder: (context, child) {
                return Positioned(
                  top: random.nextDouble() * size.height,
                  left: random.nextDouble() * size.width,
                  child: Opacity(
                    opacity: 0.2 + (_starController.value * 0.6),
                    child: Container(
                      width: 2 + random.nextDouble() * 2,
                      height: 2 + random.nextDouble() * 2,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Aurora ribbons
          AnimatedBuilder(
            animation: _ribbonController,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: AuroraRibbonPainter(_ribbonController.value),
              );
            },
          ),

          // Centered message
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.blue.withOpacity(0.1),
                    Colors.purple.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 60,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.celebration_rounded,
                    size: 80,
                    color: Colors.yellowAccent,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "THE END",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 6,
                      shadows: [
                        Shadow(color: Colors.black87, blurRadius: 6),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Thanks for following Aurora’s adventure across the Northern Lights!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.5,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => HomeScreen()),
                      );
                    },
                    child: const Text(
                      "Back to Home",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
