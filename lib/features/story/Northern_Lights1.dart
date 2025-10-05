import 'package:flutter/material.dart';
import 'package:project_helios/features/home/home_screen.dart';
import 'dart:math' as math;

import 'package:project_helios/features/story/Northern_Lights2.dart';

class AuroraPage1 extends StatefulWidget {
  const AuroraPage1({super.key});

  @override
  State<AuroraPage1> createState() => _AuroraPage1State();
}

class _AuroraPage1State extends State<AuroraPage1>
    with TickerProviderStateMixin {
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
          // 🔹 Gradient background (dark sky)
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

          // 🔹 Twinkling Stars
          ...List.generate(25, (index) {
            return AnimatedBuilder(
              animation: _starController,
              builder: (context, child) {
                return Positioned(
                  top: (index * 50) % size.height,
                  left: (index * 77) % size.width,
                  child: Opacity(
                    opacity: (math.sin(_starController.value * 2 * math.pi + index) + 1) / 2,
                    child: Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 6 + (index % 3) * 3,
                    ),
                  ),
                );
              },
            );
          }),

          // 🔹 Aurora Ribbons (new style matching your uploaded image)
          AnimatedBuilder(
            animation: _ribbonController,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: AuroraRibbonPainter(_ribbonController.value),
              );
            },
          ),

          // 🔹 Story Container (larger, scrollable)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.35,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    const Color(0xFFE0F7FA),
                    Colors.blue.shade50,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blueAccent, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "🌌 Aurora's Adventure:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004D7A),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "One crisp winter night, Aurora the explorer gazed up at the dark sky. Suddenly, "
                      "streaks of green, pink, and violet shimmered above! The Northern Lights danced across "
                      "the sky like magical ribbons.\n\n"
                      "Aurora could hear whispers of ancient legends told by the stars: that these lights "
                      "were messages from the sky spirits, guiding travelers and inspiring dreamers.\n\n"
                      "With wide eyes and a racing heart, Aurora imagined soaring through the sparkling ribbons, "
                      "chasing the dancing lights across the frozen landscape. Each wave of color told a story, "
                      "and every twinkle promised a new adventure!",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🔹 Title at Top
          SafeArea(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.shade900.withOpacity(0.8),
                    Colors.blue.shade900.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.yellow.shade300, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Text(
                "⭐ Aurora and the Dancing Lights ⭐",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black87, blurRadius: 6)],
                ),
              ),
            ),
          ),

          // 🔹 Next Button
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuroraPage2()),
                );
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

// 🔹 Aurora Ribbon Painter (matching uploaded image)
class AuroraRibbonPainter extends CustomPainter {
  final double animationValue;
  AuroraRibbonPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final gradients = [
      LinearGradient(colors: [Colors.green.shade400, Colors.purple.shade400]),
      LinearGradient(colors: [Colors.blue.shade300, Colors.pink.shade300]),
    ];

    for (int i = 0; i < gradients.length; i++) {
      final paint = Paint()
        ..shader = gradients[i].createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round;

      final path = Path();
      path.moveTo(0, size.height * 0.4 + i * 20 + animationValue * 30);
      path.quadraticBezierTo(
        size.width * 0.25, size.height * 0.35 + animationValue * 25,
        size.width * 0.5, size.height * 0.45 + animationValue * 30,
      );
      path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.55 + animationValue * 25,
        size.width, size.height * 0.5 + animationValue * 30,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant AuroraRibbonPainter oldDelegate) => true;
}
