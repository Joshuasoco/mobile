import 'package:flutter/material.dart';

Path createArrowPath(Size size) {
  final p = Path();
  final s = size;

  // Arrow shaft - straight horizontal line
  p.moveTo(s.width * 0.1, s.height * 0.5);
  p.lineTo(s.width * 0.7, s.height * 0.5);

  // Arrowhead - triangular point
  p.lineTo(s.width * 0.65, s.height * 0.35); // upper diagonal
  p.lineTo(s.width * 0.9, s.height * 0.5);   // tip point
  p.lineTo(s.width * 0.65, s.height * 0.65); // lower diagonal
  p.lineTo(s.width * 0.7, s.height * 0.5);   // back to shaft
  
  return p;
}