import 'package:flutter/material.dart';

/// Gran Verde Cacao Farm — Brand Color Palette
/// Earthy greens, warm browns, and gold accents
class AppColors {
  AppColors._();

  // ── Primary (Cacao / Earth) ──────────────────────────────────────
  static const Color primary = Color(0xFF2E7D32);        // Deep forest green
  static const Color primaryLight = Color(0xFF4CAF50);    // Lighter green
  static const Color primaryDark = Color(0xFF1B5E20);     // Darkest green

  // ── Secondary (Cacao Brown) ──────────────────────────────────────
  static const Color secondary = Color(0xFF5D4037);       // Cacao brown
  static const Color secondaryLight = Color(0xFF8D6E63);  // Light cacao
  static const Color secondaryDark = Color(0xFF3E2723);   // Dark cacao

  // ── Accent (Gold / Harvest) ──────────────────────────────────────
  static const Color accent = Color(0xFFFFB300);          // Warm gold
  static const Color accentLight = Color(0xFFFFD54F);     // Light gold

  // ── Backgrounds ──────────────────────────────────────────────────
  static const Color background = Color(0xFFF5F1EB);      // Warm off-white
  static const Color surface = Color(0xFFFFFFFF);          // Pure white
  static const Color surfaceVariant = Color(0xFFF0EBE3);   // Warm surface
  static const Color border = Color(0xFFE0D8CE);           // Warm border

  // ── Text ─────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1B1B1B);
  static const Color textSecondary = Color(0xFF5A5A5A);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Status ───────────────────────────────────────────────────────
  static const Color success = Color(0xFF43A047);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF9A825);
  static const Color info = Color(0xFF1976D2);

  // ── Gradients ────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1B5E20),
      Color(0xFF2E7D32),
      Color(0xFF388E3C),
    ],
  );

  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF5D4037),
      Color(0xFF3E2723),
    ],
  );
}
