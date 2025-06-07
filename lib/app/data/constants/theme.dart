import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppThemes {
  static ThemeData light() {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.backgroundColor,
      fontFamily: 'MapoGoldenPier',
      colorScheme: ColorScheme.light(
        primary: AppColors.accentGreen,
        // 상승 강조색
        secondary: AppColors.accentRed,
        // 하락 강조색
        surface: AppColors.cardBackground,
        background: AppColors.backgroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'MapoGoldenPier',
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.chipColor,
        labelStyle: const TextStyle(fontSize: 12, color: Colors.black87),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        selectedColor: AppColors.accentGreen.withOpacity(0.8),
        secondarySelectedColor: AppColors.accentRed.withOpacity(0.8),
      ),
      cardColor: AppColors.cardBackground,
      cardTheme: const CardTheme(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.cardBackground,
        selectedItemColor: AppColors.accentGreen,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        labelSmall: TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.accentBlue,
        inactiveTrackColor: Colors.grey[300],
        thumbColor: AppColors.accentBlue,
        overlayColor: AppColors.accentBlue.withOpacity(0.2),
        trackHeight: 4,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
        valueIndicatorColor: AppColors.accentBlue,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackgroundColor,
      fontFamily: 'MapoGoldenPier',
      colorScheme: ColorScheme.dark(
        primary: AppColors.accentGreen,
        secondary: AppColors.accentRed,
        surface: AppColors.darkCardBackground,
        background: AppColors.darkBackgroundColor,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackgroundColor,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'MapoGoldenPier',
        ),
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkChipColor,
        labelStyle: const TextStyle(fontSize: 12, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        selectedColor: AppColors.accentGreen.withOpacity(0.8),
        secondarySelectedColor: AppColors.accentRed.withOpacity(0.8),
      ),
      cardColor: AppColors.darkCardBackground,
      cardTheme: const CardTheme(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkCardBackground,
        selectedItemColor: AppColors.accentGreen,
        unselectedItemColor: AppColors.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16, color: AppColors.darkTextPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.darkTextSecondary),
        labelSmall: TextStyle(fontSize: 12, color: AppColors.darkTextSecondary),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: Colors.tealAccent,
        inactiveTrackColor: Colors.grey[700],
        thumbColor: Colors.tealAccent,
        overlayColor: Colors.tealAccent.withOpacity(0.2),
        trackHeight: 4,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
        valueIndicatorColor: Colors.teal,
      ),
    );
  }
}
