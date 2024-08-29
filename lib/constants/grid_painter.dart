import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  final ThemeData theme;

  GridPainter(this.theme);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = theme.brightness == Brightness.light
          ? Colors.black.withOpacity(0.09)
          : Colors.grey.withOpacity(0.1)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 25) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += 25) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}