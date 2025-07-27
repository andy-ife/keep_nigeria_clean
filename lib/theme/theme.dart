import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_nigeria_clean/theme/colors.dart';
import 'package:keep_nigeria_clean/theme/styles.dart';

class AppTheme {
  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary).copyWith(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryLight,
      primaryFixedDim: AppColors.primaryDark,
      onPrimary: AppColors.white,
      onPrimaryContainer: AppColors.black,
      surface: AppColors.white,
      surfaceDim: AppColors.lightGrey,
      onSurface: AppColors.black,
      onSurfaceVariant: AppColors.grey,
      outline: AppColors.medGrey,

      onPrimaryFixed: AppColors.splashGrey,
      surfaceBright: AppColors.splashBackground,
    ),
    textTheme: TextTheme(
      headlineMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 28.0,
        color: AppColors.primary,
        fontWeight: FontWeight.w500,
      ),

      headlineSmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 22.0,
        color: AppColors.primary,
        fontWeight: FontWeight.w500,
      ),

      titleMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 22.0,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),

      bodyLarge: TextStyle(fontFamily: 'Poppins', fontSize: 16.0),
      bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 14.0),
      bodySmall: TextStyle(fontFamily: 'Poppins', fontSize: 12.0),

      labelMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
      ),

      labelSmall: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        fontSize: 11.0,
      ),
    ),
    textButtonTheme: TextButtonThemeData(style: AppButtonStyles.outlined),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0.0,
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.white,
        systemNavigationBarDividerColor: AppColors.lightGrey,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    ),
  );
}
