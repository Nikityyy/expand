// lib/core/app_colors.dart
import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand Identity 2.0 (The Glacial Kit)
  static const Color styrianForest = Color(0xFF0F5838); // Primary - Deep Green
  static const Color glacialWhite =
      Color(0xFFFAFAFC); // Canvas - Cool Off-White
  static const Color steel = Color(0xFFF0F2F5); // Surface Light
  static const Color frost = Color(0xFF1A1F1F); // Surface Dark
  static const Color kaiserRed = Color(0xFFED2939); // Action/Alert - Signal Red
  static const Color glacierMint = Color(0xFF3ED685); // Success
  static const Color amber = Color(0xFFFFBF00); // Warning/Alert
  static const Color borderGrey = Color(0xFFD1D5DB); // Topographic Border

  // Functional Assignments
  static const Color primary = styrianForest;
  static const Color background = glacialWhite;
  static const Color surface = steel;
  static const Color surfaceDark = frost;
  static const Color error = kaiserRed;
  static const Color success = glacierMint;
  static const Color warning = amber;
  static const Color border = borderGrey;

  static const Color transparent = Colors.transparent;

  // Distinct Surface Nuances
  static const Color limestone = Color(0xFFF7F5F2); // Canvas/Background
  static const Color pebble = Color(0xFFE8E6E1); // Light surface/card separator
  static const Color slate = Color(0xFF2A3333); // Dark surface/UI separation
  static const Color slateLight = Color(0xFF5A6464); // Secondary text

  // Map fog overlay
  static const Color fogOverlay = Color(0xCC2A3333); // Slate @ 80% opacity
  static const Color pathLine = primary;
}
