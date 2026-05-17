import 'package:flutter/material.dart';

class AppColors {
  // Main Theme Colors
  static const Color background = Color(0xFFF4F6F9); // Light grey/white
  static const Color headerDark = Color(0xFF1E1A2D);
  static const Color headerDarkEnd = Color(0xFF161122);
  static const Color cardLight = Colors.white;
  
  // Accents
  static const Color accent = Color(0xFFFF416C); // Pinkish Red Theme Color
  static const Color accentDark = Color(0xFFFF4B2B);
  
  // Text Colors
  static const Color textDark = Color(0xFF2C3A4B);
  static const Color textGrey = Color(0xFF9E9E9E); // Colors.grey.shade500 approx
  static const Color textLight = Colors.white;
  
  // Utilities
  static const Color border = Color(0xFFE5E7EB);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}