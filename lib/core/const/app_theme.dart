import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grostok/core/const/app_colors.dart';

class AppTheme {
  static final appTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.white,
    brightness: Brightness.dark,
    textTheme: GoogleFonts.interTextTheme(),
    appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white, foregroundColor: Colors.black),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade700,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      labelStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.5),
          fontSize: 17,
          fontWeight: FontWeight.w100),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    ),
  );
}
