import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'Todo Manager';
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration searchDebounce = Duration(milliseconds: 300);

  static const String dummyEmail = 'admin@gmail.com';
  static const String dummyPassword = '123456';
}

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF5B67F1);
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color accent = Color(0xFF38BDF8);
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF334155);
}

class AppShadows {
  AppShadows._();

  static List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> elevated = [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.12),
      blurRadius: 32,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> soft = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
}

class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
}
