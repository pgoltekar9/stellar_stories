import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:project_helios/features/story/CaptionRayPage9.dart';

class captain_ray_page8 extends StatefulWidget {
  const captain_ray_page8({super.key});

  @override
  State<captain_ray_page8> createState() => _captain_ray_page8State();
}

class _captain_ray_page8State extends State<captain_ray_page8>
    with TickerProviderStateMixin {
  late AnimationController _cloudController;
  late AnimationController _planeController;
  late AnimationController _sunRayController;
  late AnimationController _starController;

  @override
  void initState() {
    super.initState();
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _planeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _sunRayController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _planeController.dispose();
    _sunRayController.dispose();
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      body: Stack(
        children: [
          // 🔹 Enhanced Sky Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF012E64),
                  Color(0xFF1E5A9A),
                  Color(0xFF3D9BE9),
                  Color(0xFF87CEEB)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),

          // 🔹 Animated Twinkling Stars
          ...List.generate(20, (index) {
            return AnimatedBuilder(
              animation: _starController,
              builder: (context, child) {
                return Positioned(
                  top: 50.0 + (index * 25) % 300,
                  left: (index * 47) % MediaQuery.of(context).size.width,
                  child: Opacity(
                    opacity: (math.sin(_starController.value * math.pi * 2 +
                                index) +
                            1) /
                        2,
                    child: Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 8 + (index % 3) * 4,
                    ),
                  ),
                );
              },
            );
          }),

          // 🔹 Sun with Animated Rays
          Positioned(
            top: 60,
            right: 60,
            child: AnimatedBuilder(
              animation: _sunRayController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _sunRayController.value * 2 * math.pi,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Sun rays
                      ...List.generate(8, (index) {
                        return Transform.rotate(
                          angle: (index * math.pi / 4),
                          child: Container(
                            width: 4,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.yellow.withOpacity(0.8),
                                  Colors.transparent
                                ],
                                begin: Alignment.center,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        );
                      }),
                      // Sun core
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.yellow.shade300,
                              Colors.orange.shade400,
                              Colors.orange.shade600,
                              Colors.transparent
                            ],
                            stops: const [0.3, 0.6, 0.8, 1.0],
                            radius: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.yellow.withOpacity(0.5),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // 🔹 Animated Clouds
          AnimatedBuilder(
            animation: _cloudController,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: 120,
                    left: -100 + (_cloudController.value * MediaQuery.of(context).size.width * 1.5),
                    child: _buildCloud(100, 50),
                  ),
                  Positioned(
                    top: 200,
                    left: -150 + (_cloudController.value * MediaQuery.of(context).size.width * 1.3),
                    child: _buildCloud(130, 60),
                  ),
                  Positioned(
                    top: 280,
                    left: -120 + (_cloudController.value * MediaQuery.of(context).size.width * 1.6),
                    child: _buildCloud(110, 55),
                  ),
                ],
              );
            },
          ),

          // 🔹 Birds Flying
          Positioned(
            top: 180,
            left: 100,
            child: CustomPaint(
              size: const Size(60, 30),
              painter: BirdPainter(),
            ),
          ),
          Positioned(
            top: 220,
            left: 200,
            child: CustomPaint(
              size: const Size(50, 25),
              painter: BirdPainter(),
            ),
          ),

          // 🔹 Additional Plane in Sky (Realistic Small Aircraft)
          AnimatedBuilder(
            animation: _cloudController,
            builder: (context, child) {
              return Positioned(
                top: 150,
                left: -120 + (_cloudController.value * MediaQuery.of(context).size.width * 1.4),
                child: Transform.rotate(
                  angle: 0.05,
                  child: CustomPaint(
                    size: const Size(140, 60),
                    painter: SmallAircraftPainter(),
                  ),
                ),
              );
            },
          ),

          // 🔹 Control Tower
          Positioned(
            bottom: 200,
            left: MediaQuery.of(context).size.width * 0.2,
            child: _buildControlTower(),
          ),

          // 🔹 Runway with better design
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 220),
              painter: EnhancedRunwayPainter(),
            ),
          ),

          // 🔹 Animated Airplane
          AnimatedBuilder(
            animation: _planeController,
            builder: (context, child) {
              return Positioned(
                bottom: 160 + (_planeController.value * 20),
                right: 50,
                child: Transform.rotate(
                  angle: -0.05 + (_planeController.value * 0.1),
                  child: Column(
                    children: [
                      // Plane body
                      Container(
                        width: 120,
                        height: 35,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.grey.shade200,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade900.withOpacity(0.6),
                              blurRadius: 15,
                              spreadRadius: 3,
                              offset: const Offset(3, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Colors.lightBlue.shade300,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Wing
                      Container(
                        width: 90,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // 🔹 Captain Ray Character (Enhanced)
          Positioned(
            bottom: 150,
            left: 40,
            child: Column(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.shade300,
                        Colors.orange.shade600,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "🧑‍✈",
                      style: TextStyle(fontSize: 45),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: const Text(
                    "Captain Ray 👨‍✈",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2C4168),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Enhanced Comic Dialogue Box
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    const Color(0xFFE8F0FF),
                    Colors.blue.shade50,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blueAccent, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "👨‍✈",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Captain Ray:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C4168),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "I guided SkyDancer using landmarks and my compass — the old-fashioned way!\n"
                    "When I finally landed, the base crew cheered\n"
                    "Looks like you just flew through a solar storm, Captain Ray!” they said.\n"
                    "I couldn’t help but grin — I’d met the Sun’s power face to face.",
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

          // 🔹 Enhanced Title at Top
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
              child: Text(
                "⭐ Captain Ray and the Storm from the Sun ⭐",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.yellow.shade100,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(color: Colors.black87, blurRadius: 6),
                  ],
                ),
              ),
            ),
          ),

          // 🔹 Next Button (Bottom Right)
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => captain_ray_page9()),
                );
              },
              backgroundColor: Colors.orange.shade600,
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloud(double width, double height) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: height * 0.3,
          child: Container(
            width: width * 0.5,
            height: height * 0.7,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          left: width * 0.3,
          top: 0,
          child: Container(
            width: width * 0.6,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: height * 0.2,
          child: Container(
            width: width * 0.5,
            height: height * 0.8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlTower() {
    return Column(
      children: [
        // Top glass cabin
        Container(
          width: 60,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.lightBlue.shade100,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            border: Border.all(color: Colors.blue.shade800, width: 2),
          ),
          child: Center(
            child: Icon(Icons.radar, color: Colors.red.shade700, size: 20),
          ),
        ),
        // Tower body
        Container(
          width: 45,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey.shade300, Colors.grey.shade500],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(color: Colors.grey.shade700, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildWindow(),
              _buildWindow(),
              _buildWindow(),
            ],
          ),
        ),
        // Base
        Container(
          width: 55,
          height: 15,
          color: Colors.grey.shade600,
        ),
      ],
    );
  }

  Widget _buildWindow() {
    return Container(
      width: 25,
      height: 12,
      decoration: BoxDecoration(
        color: Colors.yellow.shade200,
        border: Border.all(color: Colors.grey.shade800),
      ),
    );
  }
}

// 🎨 Enhanced Runway Painter
class EnhancedRunwayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Main runway
    final runwayPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.grey.shade700, Colors.grey.shade900],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), runwayPaint);

    // Side lines
    final sidePaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    
    canvas.drawLine(
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.3, size.height),
      sidePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, 0),
      Offset(size.width * 0.7, size.height),
      sidePaint,
    );

    // Center dashed line
    final centerLinePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    const dashWidth = 30.0;
    const dashSpace = 20.0;
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashWidth),
        centerLinePaint,
      );
      startY += dashWidth + dashSpace;
    }

    // Runway lights
    final lightPaint = Paint()..color = Colors.blue.shade300;
    for (int i = 0; i < 8; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.25, i * (size.height / 7)),
        4,
        lightPaint,
      );
      canvas.drawCircle(
        Offset(size.width * 0.75, i * (size.height / 7)),
        4,
        lightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 🦅 Bird Painter
class BirdPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // Left wing
    path.moveTo(size.width * 0.3, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.2, size.height * 0.2,
      size.width * 0.1, size.height * 0.3,
    );
    
    // Right wing
    path.moveTo(size.width * 0.3, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.2,
      size.width * 0.7, size.height * 0.3,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ✈ Small Aircraft Painter (Realistic Design)
class SmallAircraftPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Fuselage (body)
    final bodyPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.grey.shade200, Colors.white, Colors.grey.shade300],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(size.width * 0.2, size.height * 0.35, size.width * 0.6, size.height * 0.25));
    
    final bodyPath = Path();
    bodyPath.moveTo(size.width * 0.15, size.height * 0.47);
    bodyPath.quadraticBezierTo(
      size.width * 0.2, size.height * 0.35,
      size.width * 0.4, size.height * 0.38,
    );
    bodyPath.lineTo(size.width * 0.7, size.height * 0.42);
    bodyPath.quadraticBezierTo(
      size.width * 0.75, size.height * 0.43,
      size.width * 0.78, size.height * 0.48,
    );
    bodyPath.lineTo(size.width * 0.75, size.height * 0.58);
    bodyPath.quadraticBezierTo(
      size.width * 0.7, size.height * 0.58,
      size.width * 0.4, size.height * 0.55,
    );
    bodyPath.lineTo(size.width * 0.15, size.height * 0.52);
    bodyPath.close();
    canvas.drawPath(bodyPath, bodyPaint);

    // Main wings
    final wingPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final wingPath = Path();
    wingPath.moveTo(size.width * 0.4, size.height * 0.47);
    wingPath.lineTo(size.width * 0.1, size.height * 0.65);
    wingPath.lineTo(size.width * 0.15, size.height * 0.68);
    wingPath.lineTo(size.width * 0.45, size.height * 0.5);
    wingPath.close();
    canvas.drawPath(wingPath, wingPaint);

    wingPath.moveTo(size.width * 0.4, size.height * 0.47);
    wingPath.lineTo(size.width * 0.1, size.height * 0.3);
    wingPath.lineTo(size.width * 0.15, size.height * 0.27);
    wingPath.lineTo(size.width * 0.45, size.height * 0.45);
    wingPath.close();
    canvas.drawPath(wingPath, wingPaint);

    // Blue stripes
    final stripePaint = Paint()
      ..color = Colors.blue.shade700
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.45),
      Offset(size.width * 0.7, size.height * 0.48),
      stripePaint,
    );

    // Tail wing
    final tailPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final tailPath = Path();
    tailPath.moveTo(size.width * 0.75, size.height * 0.48);
    tailPath.lineTo(size.width * 0.85, size.height * 0.25);
    tailPath.lineTo(size.width * 0.9, size.height * 0.28);
    tailPath.lineTo(size.width * 0.8, size.height * 0.5);
    tailPath.close();
    canvas.drawPath(tailPath, tailPaint);

    // Red logo on tail
    final logoPaint = Paint()
      ..color = Colors.red.shade700
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.35),
      6,
      logoPaint,
    );

    // Cockpit window
    final windowPaint = Paint()
      ..color = Colors.blue.shade200.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    
    final windowPath = Path();
    windowPath.addOval(Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.4,
      size.width * 0.12,
      size.height * 0.12,
    ));
    canvas.drawPath(windowPath, windowPaint);

    // Propeller
    final propPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 3;
    
    canvas.drawLine(
      Offset(size.width * 0.13, size.height * 0.35),
      Offset(size.width * 0.13, size.height * 0.6),
      propPaint,
    );

    // Propeller center
    final propCenterPaint = Paint()
      ..color = Colors.red.shade900;
    
    canvas.drawCircle(
      Offset(size.width * 0.13, size.height * 0.475),
      4,
      propCenterPaint,
    );

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    
    canvas.drawPath(bodyPath.shift(const Offset(3, 5)), shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

