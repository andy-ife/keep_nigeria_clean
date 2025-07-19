import 'package:flutter/material.dart';
import 'package:keep_nigeria_clean/theme/colors.dart';
import 'package:keep_nigeria_clean/theme/styles.dart';

class AppTheme {
  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary).copyWith(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryLight,
      primaryFixedDim: AppColors.primaryDark,
      onPrimary: AppColors.white,
      onPrimaryContainer: AppColors.white,
      surface: AppColors.white,
      surfaceDim: AppColors.lightGrey,
      onSurface: AppColors.black,
      onSurfaceVariant: AppColors.grey,
      outline: AppColors.medGrey,
    ),
    textTheme: TextTheme(
      headlineMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 28.0,
        color: AppColors.white,
      ),

      titleMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 22.0,
        fontWeight: FontWeight.w600,
      ),

      bodyLarge: TextStyle(fontFamily: 'Poppins', fontSize: 16.0),
      bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 14.0),

      labelMedium: TextStyle(fontFamily: 'Poppins', fontSize: 12.0),

      labelSmall: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        fontSize: 11.0,
      ),
    ),
    textButtonTheme: TextButtonThemeData(style: AppButtonStyles.outlined),
  );
}
