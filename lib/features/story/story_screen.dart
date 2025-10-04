import 'package:flutter/material.dart';
import 'dart:math' as math;

class StoryScreen extends StatefulWidget {
  final dynamic story;

  const StoryScreen({Key? key, this.story}) : super(key: key);

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with TickerProviderStateMixin {
  int currentPage = 0;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _sparkleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> pages = [
    {
      "text":
          "Meet Captain Ray, a brave space explorer who watches over our planet from the International Space Station.",
      "icon": Icons.rocket_launch,
      "color": Color(0xFF64B5F6),
    },
    {
      "text":
          "One day, Captain Ray notices something unusual on the Sun - a massive solar flare bursting with energy!",
      "icon": Icons.wb_sunny,
      "color": Color(0xFFFFA726),
    },
    {
      "text":
          "The solar flare releases a Coronal Mass Ejection (CME) - billions of tons of solar particles racing toward Earth at incredible speeds!",
      "icon": Icons.flash_on,
      "color": Color(0xFFFF5722),
    },
    {
      "text":
          "As the solar storm approaches, pilots in airplanes and astronauts in space must take precautions. The radiation can affect their equipment!",
      "icon": Icons.airplanemode_active,
      "color": Color(0xFF42A5F5),
    },
    {
      "text":
          "Power grids on Earth light up with alerts. The magnetic storm could disrupt electricity and satellites!",
      "icon": Icons.power,
      "color": Color(0xFFEF5350),
    },
    {
      "text":
          "But there's beauty in the storm too! The solar particles interact with Earth's atmosphere, creating magnificent auroras - nature's light show!",
      "icon": Icons.auto_awesome,
      "color": Color(0xFF9C27B0),
    },
    {
      "text":
          "Captain Ray smiles, knowing that understanding space weather helps keep everyone safe while letting us enjoy its wonders.",
      "icon": Icons.favorite,
      "color": Color(0xFFEC407A),
    },
    {
      "text":
          "Now it's your turn! Help Captain Ray manage the solar system and experience space weather in action!",
      "icon": Icons.sports_esports,
      "color": Color(0xFF66BB6A),
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _sparkleController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  void _nextPage() {
    if (currentPage == pages.length - 1) {
      Navigator.pushReplacementNamed(context, '/game');
    } else {
      setState(() {
        currentPage++;
        _fadeController.reset();
        _slideController.reset();
        _fadeController.forward();
        _slideController.forward();
      });
    }
  }

  void _previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        _fadeController.reset();
        _slideController.reset();
        _fadeController.forward();
        _slideController.forward();
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = pages[currentPage];
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset(
              'assets/images/bg2.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Animated gradient overlay matching page color
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  page["color"].withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                  page["color"].withOpacity(0.2),
                ],
              ),
            ),
          ),

          // Animated sparkles
          ...List.generate(8, (index) {
            return AnimatedBuilder(
              animation: _sparkleController,
              builder: (context, child) {
                final progress =
                    (_sparkleController.value + index * 0.125) % 1.0;
                final angle = (index * math.pi / 4);
                final distance = 100 + (progress * 50);
                final x = size.width / 2 + math.cos(angle) * distance;
                final y = size.height * 0.25 + math.sin(angle) * distance;
                final opacity = (1 - progress) * 0.6;

                return Positioned(
                  left: x,
                  top: y,
                  child: Opacity(
                    opacity: opacity,
                    child: Icon(
                      Icons.star,
                      color: page["color"],
                      size: 8,
                    ),
                  ),
                );
              },
            );
          }),

          SafeArea(
            child: Column(
              children: [
                // Header with page counter
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          "Page ${currentPage + 1} of ${pages.length}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 48),
                    ],
                  ),
                ),

                Spacer(),

                // Main icon with glow effect
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: page["color"].withOpacity(0.6),
                          blurRadius: 50,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                    child: Icon(
                      page["icon"],
                      size: 100,
                      color: page["color"],
                    ),
                  ),
                ),

                SizedBox(height: 40),

                // Story text container
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Text(
                        page["text"],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          height: 1.6,
                          fontWeight: FontWeight.w400,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.8),
                              offset: Offset(1, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

                Spacer(),

                // Progress dots
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (index) => AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: currentPage == index ? 30 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentPage == index
                              ? page["color"]
                              : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),

                // Navigation buttons
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Previous button
                      if (currentPage > 0)
                        _buildNavButton(
                          icon: Icons.arrow_back_ios,
                          label: "Previous",
                          onPressed: _previousPage,
                          isPrimary: false,
                        )
                      else
                        SizedBox(width: 100),

                      // Next / Play Game button
                      _buildNavButton(
                        icon: currentPage == pages.length - 1
                            ? Icons.sports_esports
                            : Icons.arrow_forward_ios,
                        label: currentPage == pages.length - 1
                            ? "Play Game"
                            : "Next",
                        onPressed: _nextPage,
                        isPrimary: true,
                        color: page["color"],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isPrimary,
    Color? color,
  }) {
    final buttonColor = color ?? Colors.white;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? LinearGradient(
                  colors: [
                    buttonColor,
                    buttonColor.withOpacity(0.7),
                  ],
                )
              : null,
          color: isPrimary ? null : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isPrimary
                ? Colors.transparent
                : Colors.white.withOpacity(0.4),
            width: 2,
          ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: buttonColor.withOpacity(0.5),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isPrimary || currentPage == pages.length - 1)
              Icon(
                icon,
                color: isPrimary ? Colors.black87 : Colors.white,
                size: 20,
              ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.black87 : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            if (isPrimary && currentPage != pages.length - 1)
              Icon(
                icon,
                color: Colors.black87,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}