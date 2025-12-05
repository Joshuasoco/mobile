import 'package:flutter/material.dart';
import 'arrow_path.dart';

class ArrowPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0

  ArrowPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final path = createArrowPath(size);
    final metrics = path.computeMetrics().first;

    final extract = metrics.extractPath(
      0,
      metrics.length * progress,
    );

    final paintStyle = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(extract, paintStyle);
  }

  @override
  bool shouldRepaint(covariant ArrowPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
