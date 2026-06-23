import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFF5F2ED);
  static const primary = Color(0xFF2D5A3D);
  static const primaryLight = Color(0xFFE8F0EB);
  static const accent = Color(0xFF4A7C59);
  static const textDark = Color(0xFF1A1A1A);
  static const textMuted = Color(0xFF6B6B6B);
  static const textLight = Color(0xFF9E9E9E);
  static const cardBg = Color(0xFFFFFFFF);
  static const navBg = Color(0xFFDDEBE1);
  static const danger = Color(0xFFB83232);
  static const dangerLight = Color(0xFFFFF3F3);
  static const warning = Color(0xFFF5A623);
  static const warningLight = Color(0xFFFFF8E8);
  static const gold = Color(0xFFD4A017);
  static const surface = Color(0xFFF0EDE8);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          surface: AppColors.background,
        ),
        fontFamily: 'Georgia',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textDark,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      );
}
