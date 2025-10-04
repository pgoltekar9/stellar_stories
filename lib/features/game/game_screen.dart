import 'package:flutter/material.dart';
import 'dart:math' as math;

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin {
  late AnimationController _orbitController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  
  double sunEnergy = 70.0;
  int solarFlares = 0;
  int protectedPlanets = 0;
  bool isStormActive = false;
  
  final List<Planet> planets = [
    Planet(name: "Mercury", distance: 80, speed: 1.5, color: Colors.grey, size: 15),
    Planet(name: "Venus", distance: 110, speed: 1.2, color: Colors.orange.shade300, size: 20),
    Planet(name: "Earth", distance: 150, speed: 1.0, color: Colors.blue, size: 22),
    Planet(name: "Mars", distance: 190, speed: 0.8, color: Colors.red.shade400, size: 18),
  ];

  @override
  void initState() {
    super.initState();
    
    _orbitController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _particleController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _triggerSolarFlare() {
    setState(() {
      if (sunEnergy >= 20) {
        sunEnergy -= 20;
        solarFlares++;
        isStormActive = true;
        
        Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              isStormActive = false;
            });
          }
        });
      }
    });
  }

  void _rechargeEnergy() {
    setState(() {
      if (sunEnergy < 100) {
        sunEnergy = math.min(100, sunEnergy + 15);
      }
    });
  }

  void _protectPlanet() {
    setState(() {
      if (sunEnergy >= 10) {
        sunEnergy -= 10;
        protectedPlanets++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFF0A0E27),
              Color(0xFF000000),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Starfield background
            ...List.generate(100, (index) {
              final random = math.Random(index);
              return Positioned(
                left: random.nextDouble() * size.width,
                top: random.nextDouble() * size.height,
                child: Container(
                  width: random.nextDouble() * 3,
                  height: random.nextDouble() * 3,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3 + random.nextDouble() * 0.5),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),

            // Solar flare particles
            if (isStormActive)
              ...List.generate(20, (index) {
                return AnimatedBuilder(
                  animation: _particleController,
                  builder: (context, child) {
                    final angle = (index * 2 * math.pi / 20);
                    final distance = 60 + (_particleController.value * 150);
                    final x = centerX + math.cos(angle) * distance;
                    final y = centerY + math.sin(angle) * distance;
                    final opacity = 1 - _particleController.value;

                    return Positioned(
                      left: x,
                      top: y,
                      child: Opacity(
                        opacity: opacity,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.8),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),

            // Orbiting planets
            AnimatedBuilder(
              animation: _orbitController,
              builder: (context, child) {
                return Stack(
                  children: planets.map((planet) {
                    final angle = _orbitController.value * 2 * math.pi * planet.speed;
                    final x = centerX + math.cos(angle) * planet.distance;
                    final y = centerY + math.sin(angle) * planet.distance;

                    return Positioned(
                      left: x - planet.size / 2,
                      top: y - planet.size / 2,
                      child: Container(
                        width: planet.size,
                        height: planet.size,
                        decoration: BoxDecoration(
                          color: planet.color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: planet.color.withOpacity(0.6),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            // Orbit paths
            Center(
              child: Stack(
                children: planets.map((planet) {
                  return Container(
                    width: planet.distance * 2,
                    height: planet.distance * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Central Sun
            Center(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = 1.0 + (_pulseController.value * 0.1);
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.yellow,
                            Colors.orange,
                            Colors.deepOrange,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.8),
                            blurRadius: 40,
                            spreadRadius: 20,
                          ),
                          BoxShadow(
                            color: Colors.yellow.withOpacity(0.6),
                            blurRadius: 60,
                            spreadRadius: 30,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.wb_sunny,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Top UI Panel
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Spacer(),
                        _buildStatCard(
                          icon: Icons.bolt,
                          label: "Energy",
                          value: "${sunEnergy.toInt()}%",
                          color: Colors.yellow,
                        ),
                        SizedBox(width: 10),
                        _buildStatCard(
                          icon: Icons.flash_on,
                          label: "Flares",
                          value: "$solarFlares",
                          color: Colors.orange,
                        ),
                        SizedBox(width: 10),
                        _buildStatCard(
                          icon: Icons.shield,
                          label: "Protected",
                          value: "$protectedPlanets",
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                  
                  // Energy Bar
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: LinearProgressIndicator(
                        value: sunEnergy / 100,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          sunEnergy > 50 ? Colors.yellow : Colors.orange,
                        ),
                      ),
                    ),
                  ),

                  Spacer(),

                  // Game Title
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "☀️ THE SUNKEEPER ☀️",
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Manage the solar system's energy",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Control Buttons
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildControlButton(
                          icon: Icons.flash_on,
                          label: "Solar Flare",
                          gradient: LinearGradient(
                            colors: [Colors.orange, Colors.deepOrange],
                          ),
                          onPressed: sunEnergy >= 20 ? _triggerSolarFlare : null,
                          enabled: sunEnergy >= 20,
                        ),
                        _buildControlButton(
                          icon: Icons.battery_charging_full,
                          label: "Recharge",
                          gradient: LinearGradient(
                            colors: [Colors.yellow, Colors.amber],
                          ),
                          onPressed: sunEnergy < 100 ? _rechargeEnergy : null,
                          enabled: sunEnergy < 100,
                        ),
                        _buildControlButton(
                          icon: Icons.shield,
                          label: "Protect",
                          gradient: LinearGradient(
                            colors: [Colors.blue, Colors.cyan],
                          ),
                          onPressed: sunEnergy >= 10 ? _protectPlanet : null,
                          enabled: sunEnergy >= 10,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // Instructions
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "How to Play:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildInstruction("⚡", "Solar Flare: Release energy (-20%)"),
                        _buildInstruction("🔋", "Recharge: Restore energy (+15%)"),
                        _buildInstruction("🛡️", "Protect: Shield planets (-10%)"),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Gradient gradient,
    required VoidCallback? onPressed,
    required bool enabled,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            gradient: enabled ? gradient : null,
            color: enabled ? null : Colors.grey,
            borderRadius: BorderRadius.circular(20),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: gradient.colors.first.withOpacity(0.5),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 30),
              SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstruction(String emoji, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 16)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Planet {
  final String name;
  final double distance;
  final double speed;
  final Color color;
  final double size;

  Planet({
    required this.name,
    required this.distance,
    required this.speed,
    required this.color,
    required this.size,
  });
}