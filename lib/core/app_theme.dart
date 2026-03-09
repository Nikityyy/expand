// lib/core/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static const double borderRadius = 12.0;

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.limestone,
      colorScheme: const ColorScheme.light(
        primary: AppColors.styrianForest,
        onPrimary: Colors.white,
        secondary: AppColors.glacierMint,
        onSecondary: AppColors.slate,
        surface: AppColors.pebble,
        onSurface: AppColors.slate,
        error: AppColors.kaiserRed,
      ),
      fontFamily: 'Outfit',
      // ── Page Transitions ───────────────────────────────────────────────────
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      // ── App Bar ────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.limestone,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: AppTextStyles.titleLarge,
        iconTheme: const IconThemeData(color: AppColors.slate),
      ),
      // ── Cards ──────────────────────────────────────────────────────────────
      cardTheme: const CardThemeData(
        color: AppColors.pebble,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          side: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      // ── Filled Button ──────────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.styrianForest,
          foregroundColor: Colors.white,
          textStyle: AppTextStyles.buttonLarge,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          minimumSize:
              const Size(double.infinity, 64), // Matches Kalorat ActionButton
          elevation: 0,
        ),
      ),
      // ── Outlined Button ────────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.styrianForest,
          side: const BorderSide(color: AppColors.styrianForest, width: 1.5),
          textStyle: AppTypography.buttonLarge
              .copyWith(color: AppColors.styrianForest),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          minimumSize: const Size(double.infinity, 64),
          elevation: 0,
        ),
      ),
      // ── Input Fields ────────────────────────────────────────────────────────
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.pebble,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          borderSide: BorderSide(color: AppColors.styrianForest, width: 1.5),
        ),
        hintStyle: TextStyle(
          fontFamily: 'Outfit',
          color: AppColors.slateLight,
          fontSize: 15,
        ),
      ),
      // ── Navigation Bar ─────────────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.styrianForest,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Colors.white, size: 24);
          }
          return const IconThemeData(color: AppColors.slateLight, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.styrianForest,
            );
          }
          return const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.slateLight,
          );
        }),
      ),
      // ── Divider ──────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 0,
      ),
    );
  }
}
