import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:project_helios/features/home/home_screen.dart';

class NebulaMessagePage extends StatefulWidget {
  const NebulaMessagePage({super.key});

  @override
  State<NebulaMessagePage> createState() => _NebulaMessagePageState();
}

class _NebulaMessagePageState extends State<NebulaMessagePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToEndPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const StoryEndPage(), // End page integrated
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image (Nebula)
          Positioned.fill(
            child: Image.network(
              'YOUR_IMAGE_URL_HERE',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF0a0015),
                        Color(0xFF1a0030),
                        Color(0xFF2d1b4e),
                        Color(0xFF1a0030),
                        Color(0xFF0a0015),
                      ],
                      stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                    ),
                  ),
                );
              },
            ),
          ),

          // Animated Twinkling Stars Overlay
          ...List.generate(50, (index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final twinkle = math.sin(
                  (_controller.value * math.pi * 2) + (index * 0.5),
                );
                return Positioned(
                  top: (index * 37.0) % MediaQuery.of(context).size.height,
                  left: (index * 51.0) % MediaQuery.of(context).size.width,
                  child: Opacity(
                    opacity: ((twinkle + 1) / 2) * 0.6,
                    child: Container(
                      width: 2 + (index % 3),
                      height: 2 + (index % 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Main Content with Transparent Box
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.15),
                              Colors.purple.withOpacity(0.1),
                              Colors.blue.withOpacity(0.1),
                              Colors.white.withOpacity(0.12),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
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
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.yellow.withOpacity(0.4),
                                    Colors.orange.withOpacity(0.2),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: const Text(
                                '☀',
                                style: TextStyle(fontSize: 60),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              '"The next time your GPS glitches, maybe the Sun is saying hello."',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                height: 1.5,
                                letterSpacing: 0.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.purple.withOpacity(0.8),
                                    blurRadius: 20,
                                  ),
                                  const Shadow(
                                    color: Colors.black87,
                                    blurRadius: 10,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            Container(
                              width: 100,
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withOpacity(0.6),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Back Button
          SafeArea(
            child: Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Next Button → goes to End Page
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: _goToEndPage,
              backgroundColor: Colors.purple.shade700,
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
}

/// ✅ Full Story End Page
class StoryEndPage extends StatefulWidget {
  const StoryEndPage({super.key});

  @override
  State<StoryEndPage> createState() => _StoryEndPageState();
}

class _StoryEndPageState extends State<StoryEndPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 10, end: 30).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0D1B2A),
                  Color(0xFF1B263B),
                  Color(0xFF415A77),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Twinkling stars
          ...List.generate(50, (index) {
            final random = math.Random(index);
            return Positioned(
              top: random.nextDouble() * size.height,
              left: random.nextDouble() * size.width,
              child: Container(
                width: 2 + random.nextDouble() * 2,
                height: 2 + random.nextDouble() * 2,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),

          // THE END Text with glow
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Text(
                      "THE END",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 6,
                        shadows: [
                          Shadow(
                            color: Colors.orangeAccent,
                            blurRadius: _glowAnimation.value,
                          ),
                          Shadow(
                            color: Colors.yellowAccent,
                            blurRadius: _glowAnimation.value / 2,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "Thanks for joining Captain Ray's adventure!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
