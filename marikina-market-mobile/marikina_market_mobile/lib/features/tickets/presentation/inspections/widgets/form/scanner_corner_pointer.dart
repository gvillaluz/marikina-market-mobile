import 'dart:math' as math;

import 'package:flutter/material.dart';

class ScannerCornersPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double cornerLength;
  final double borderRadius;

  ScannerCornersPainter({
    required this.color,
    this.strokeWidth = 4,
    this.cornerLength = 24,
    this.borderRadius = 16,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;
    final r = borderRadius;
    final l = cornerLength;

    // Top-left
    canvas.drawArc(Rect.fromLTWH(0, 0, r * 2, r * 2), math.pi, math.pi / 2, false, paint);
    canvas.drawLine(Offset(0, r), Offset(0, r + l), paint);
    canvas.drawLine(Offset(r, 0), Offset(r + l, 0), paint);

    // Top-right
    canvas.drawArc(Rect.fromLTWH(w - r * 2, 0, r * 2, r * 2), -math.pi / 2, math.pi / 2, false, paint);
    canvas.drawLine(Offset(w - r - l, 0), Offset(w - r, 0), paint);
    canvas.drawLine(Offset(w, r), Offset(w, r + l), paint);

    // Bottom-right
    canvas.drawArc(Rect.fromLTWH(w - r * 2, h - r * 2, r * 2, r * 2), 0, math.pi / 2, false, paint);
    canvas.drawLine(Offset(w, h - r - l), Offset(w, h - r), paint);
    canvas.drawLine(Offset(w - r, h), Offset(w - r - l, h), paint);

    // Bottom-left
    canvas.drawArc(Rect.fromLTWH(0, h - r * 2, r * 2, r * 2), math.pi / 2, math.pi / 2, false, paint);
    canvas.drawLine(Offset(r + l, h), Offset(r, h), paint);
    canvas.drawLine(Offset(0, h - r), Offset(0, h - r - l), paint);
  }

  @override
  bool shouldRepaint(covariant ScannerCornersPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}