import 'package:flutter/material.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary
      ),

      scaffoldBackgroundColor: AppColors.primaryLight,

      inputDecorationTheme: InputDecorationThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        labelStyle: TextStyle(color: AppColors.primaryBlack, fontSize: 14),
        iconColor: AppColors.lightGrey,
        prefixIconColor: AppColors.lightGrey,
        suffixIconColor: AppColors.lightGrey,

        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.lightGrey)
        ),

        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.lightGrey)
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primary, width: 2)
        ),

        errorStyle: const TextStyle(
          color: AppColors.primaryRed,
          fontSize: 12,
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryRed, width: 1.2),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryRed, width: 1.5),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: AppColors.primary);
          }
          return null;
        }),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.primary.withValues(alpha: 0.12);
          }
          return null;
        }),
      ),

      appBarTheme: AppBarThemeData(
        elevation: 1,
        scrolledUnderElevation: 4,
        shadowColor: Colors.grey.shade100,

        iconTheme: IconThemeData(
          color: AppColors.primary
        ),
      )
    );
  }

  static ThemeData get dark {
    return ThemeData();
  }
}