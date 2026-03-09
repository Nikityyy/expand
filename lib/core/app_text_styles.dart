// lib/core/app_text_styles.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  // Primary Font: Outfit
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: AppColors.styrianForest,
    height: 1.1,
    letterSpacing: -1.0,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.styrianForest,
    height: 1.2,
    letterSpacing: -1.0,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.styrianForest,
    letterSpacing: -0.5,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.slate,
    letterSpacing: -0.2,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.frost,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.slateLight,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.slateLight,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.glacialWhite,
    letterSpacing: 0.5,
  );

  static const TextStyle label = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.slate,
    letterSpacing: 0,
  );

  static const TextStyle buttonLarge = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.glacialWhite,
  );

  // Data Font: JetBrains Mono (using 'JetBrains Mono' font family)
  // Ensure you define it in pubspec if you want it exact, otherwise this will fallback
  // The provided expanding app already has jetbrains_mono mapped as JetBrains Mono
  static const TextStyle heroNumber = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: AppColors.styrianForest,
    letterSpacing: -1.0,
  );

  static const TextStyle dataMedium = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.styrianForest,
  );

  static const TextStyle dataLabel = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.styrianForest,
  );
}
