import 'package:flutter/material.dart';

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
