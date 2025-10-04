import 'package:flutter/material.dart';
import '../../../../routes/app_routes.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 1);
  int _currentPage = 1;
  late AnimationController _floatController;
  late AnimationController _starController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _starController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatController.dispose();
    _starController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });

    if (page == 0) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          Navigator.pushNamed(context, AppRoutes.game);
          _pageController.jumpToPage(1);
        }
      });
    } else if (page == 2) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          Navigator.pushNamed(context, AppRoutes.story, arguments: null);
          _pageController.jumpToPage(1);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              _buildGamePage(),
              _buildHomePage(),
              _buildStoryPage(),
            ],
          ),

          // Minimalist page indicator
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPageDot(0),
                const SizedBox(width: 12),
                _buildPageDot(1),
                const SizedBox(width: 12),
                _buildPageDot(2),
              ],
            ),
          ),

          // Subtle swipe hint
          if (_currentPage == 1)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 2000),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: 0.2 + (value * 0.2),
                    child: child,
                  );
                },
                child: const Text(
                  "Swipe to explore",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPageDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: _currentPage == index ? 28 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Colors.white.withOpacity(0.8)
            : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  // 🪐 Home Page (replaces Sun with Rocket)
  Widget _buildHomePage() {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0D1B2A),
            Color(0xFF1B263B),
            Color(0xFF415A77),
          ],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Twinkling stars
            ...List.generate(40, (index) {
              final random = math.Random(index);
              return AnimatedBuilder(
                animation: _starController,
                builder: (context, child) {
                  final twinkle = random.nextDouble() > 0.5
                      ? _starController.value
                      : 1 - _starController.value;
                  return Positioned(
                    left: random.nextDouble() * size.width,
                    top: random.nextDouble() * size.height,
                    child: Opacity(
                      opacity: 0.2 + (twinkle * 0.4),
                      child: Container(
                        width: 1.5 + random.nextDouble() * 2,
                        height: 1.5 + random.nextDouble() * 2,
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

            // 🚀 Floating Rocket (main animation)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _floatAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: Icon(
                          Icons.rocket_launch_rounded,
                          size: 100,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 40,
                              color: Colors.orange.withOpacity(0.4),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 60),

                  const Text(
                    "CAPTAIN RAY",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      letterSpacing: 5,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: 80,
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white.withOpacity(0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "The Sunkeeper",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.white60,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Space Weather Education",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: Colors.white10,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🧩 Story and Game pages remain unchanged
  Widget _buildStoryPage() => _buildThemedPage(
        icon: Icons.auto_stories,
        title: "STORY",
        description:
            "Journey with Captain Ray through\nthe mysteries of space weather",
        gradientColors: const [Color(0xFF1A2F4A), Color(0xFF2C5282)],
        chevron: Icons.chevron_right,
      );

  Widget _buildGamePage() => _buildThemedPage(
        icon: Icons.sports_esports,
        title: "GAME",
        description: "Take control as the Sun and\nmanage your solar system",
        gradientColors: const [Color(0xFF0F2027), Color(0xFF203A43)],
        chevron: Icons.chevron_left,
      );

  // 🔹 Shared builder for Story/Game pages
  Widget _buildThemedPage({
    required IconData icon,
    required String title,
    required String description,
    required List<Color> gradientColors,
    required IconData chevron,
  }) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Subtle glowing orbs
            Positioned(
              top: 120,
              right: -80,
              child: _orb(240, 0.03),
            ),
            Positioned(
              bottom: 180,
              left: -100,
              child: _orb(280, 0.02),
            ),

            // Twinkling stars
            ...List.generate(20, (index) {
              final random = math.Random(index + 100);
              return AnimatedBuilder(
                animation: _starController,
                builder: (context, child) {
                  final twinkle = random.nextDouble() > 0.5
                      ? _starController.value
                      : 1 - _starController.value;
                  return Positioned(
                    left: random.nextDouble() * size.width,
                    top: random.nextDouble() * size.height,
                    child: Opacity(
                      opacity: 0.2 + (twinkle * 0.3),
                      child: const CircleAvatar(
                        radius: 1,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  );
                },
              );
            }),

            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _floatAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatAnimation.value * 0.5),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.08),
                          ),
                          child: Icon(
                            icon,
                            size: 45,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 50),

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                        height: 1.8,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 40),

                  Icon(chevron, color: Colors.white10, size: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orb(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white.withOpacity(opacity),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
