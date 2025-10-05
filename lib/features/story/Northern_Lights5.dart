import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:project_helios/features/story/Northern_Lights1.dart';
import 'package:project_helios/features/story/Northern_Lights6.dart';

class AuroraPage5 extends StatefulWidget {
  const AuroraPage5({super.key});

  @override
  State<AuroraPage5> createState() => _AuroraPage5State();
}

class _AuroraPage5State extends State<AuroraPage5> with TickerProviderStateMixin {
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
                colors: [Color(0xFF0B1B3F), Color(0xFF001F3F)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Twinkling stars
          ...List.generate(25, (index) {
            return AnimatedBuilder(
              animation: _starController,
              builder: (context, child) {
                return Positioned(
                  top: (index * 50) % size.height,
                  left: (index * 77) % size.width,
                  child: Opacity(
                    opacity: (math.sin(_starController.value * 2 * math.pi + index) + 1) / 2,
                    child: Icon(Icons.star, color: Colors.white, size: 6 + (index % 3) * 3),
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

          // Story Container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.35,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.blue.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blueAccent, width: 3),
                boxShadow: [
                  BoxShadow(color: Colors.blue.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 6)),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "🌌 Aurora's Adventure Continues:",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF004D7A)),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Aurora reached the peak of the icy mountains, where the auroras danced more vividly than ever before. "
                      "She realized that the lights were not just a spectacle, but a language of the universe, "
                      "telling stories of ancient cosmic events.\n\n"
                      ,
                      style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Title at Top
          SafeArea(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade900.withOpacity(0.8), Colors.blue.shade900.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.yellow.shade300, width: 2),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 10)],
              ),
              child: const Text(
                "⭐ Aurora and the Dancing Lights ⭐",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.yellow, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black87, blurRadius: 6)]),
              ),
            ),
          ),

          // Next Button
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AuroraPage6()));
              },
              backgroundColor: Colors.green.shade600,
              child: const Icon(Icons.arrow_forward, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
