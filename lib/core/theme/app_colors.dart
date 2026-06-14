import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // === Primary Pastel Palette ===
  static const Color mintGreen = Color(0xFFDDEFE4);
  static const Color powderBlue = Color(0xFFCFE9F3);
  static const Color warmCream = Color(0xFFF7EFE7);
  static const Color softBeige = Color(0xFFE8DDD3);
  static const Color lightAqua = Color(0xFFBFE3E0);

  // === Deeper Shades ===
  static const Color deepMint = Color(0xFF8ECBA3);
  static const Color deepBlue = Color(0xFF7BBFD9);
  static const Color deepAqua = Color(0xFF6FC0BC);
  static const Color deepBeige = Color(0xFFCCBFB4);

  // === Emergency Colors ===
  static const Color emergencyRed = Color(0xFFFF5A5F);
  static const Color emergencyRedLight = Color(0xFFFFECED);
  static const Color emergencyRedGlow = Color(0x40FF5A5F);
  static const Color warningAmber = Color(0xFFFFB347);
  static const Color warningAmberLight = Color(0xFFFFF3E0);
  static const Color successGreen = Color(0xFF4CAF7D);
  static const Color successGreenLight = Color(0xFFE8F5EE);

  // === Neutral Palette ===
  static const Color white = Color(0xFFFFFFFF);
  static const Color almostWhite = Color(0xFFF9F7F5);
  static const Color surfaceLight = Color(0xFFF2EDE8);
  static const Color divider = Color(0xFFE0D9D2);

  // === Text Colors ===
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textTertiary = Color(0xFFA0AEC0);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // === Dark Mode ===
  static const Color darkBackground = Color(0xFF1A1F2E);
  static const Color darkSurface = Color(0xFF252B3B);
  static const Color darkCard = Color(0xFF2D3448);
  static const Color darkCardElevated = Color(0xFF353C52);
  static const Color darkTextPrimary = Color(0xFFE8F0FE);
  static const Color darkTextSecondary = Color(0xFF9AA5BE);

  // === Neumorphic Shadows ===
  static const Color neuLight = Color(0xFFFFFFFF);
  static const Color neuDark = Color(0xFFCEC5BB);
  static const Color neuDarkMode = Color(0xFF141929);
  static const Color neuLightDarkMode = Color(0xFF303A52);

  // === Gradients ===
  static const LinearGradient mintGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [mintGreen, lightAqua],
  );

  static const LinearGradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [powderBlue, lightAqua],
  );

  static const LinearGradient creamGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warmCream, softBeige],
  );

  static const LinearGradient emergencyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF5A5F), Color(0xFFFF8C94)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [mintGreen, powderBlue, lightAqua],
    stops: [0.0, 0.5, 1.0],
  );

  static const RadialGradient sosGlowGradient = RadialGradient(
    colors: [emergencyRedGlow, Colors.transparent],
    radius: 1.5,
  );
}
