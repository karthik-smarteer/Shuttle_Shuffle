import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.primaryBackground,
      primaryColor: AppColors.accent,
      fontFamily: 'Poppins',
      
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accent,
        background: AppColors.primaryBackground,
        surface: AppColors.primaryBackground,
        onBackground: AppColors.text,
        onSurface: AppColors.text,
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.text),
        bodyMedium: TextStyle(color: AppColors.text),
        titleLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.text,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
