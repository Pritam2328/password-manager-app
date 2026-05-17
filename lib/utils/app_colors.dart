import 'package:flutter/material.dart';

class AppColors {
  // Main Theme Colors (White Background with Dark Header)
  static const Color background = Color(0xFFF8F9FA); // Very light grey/white
  static const Color headerDark = Color(0xFF1C1C24); // Premium dark for top header
  static const Color cardLight = Color(0xFFFFFFFF); // Pure white for cards
  
  // Accents
  static const Color accent = Color(0xFFE11D48); // Pink/Reddish accent
  static const Color accentDark = Color(0xFFBE123C);
  
  // Text Colors
  static const Color textDark = Color(0xFF111827); // Dark text for white bg
  static const Color textGrey = Color(0xFF6B7280); // Subtitle text
  static const Color textLight = Color(0xFFFFFFFF); // White text for dark headers
  
  // Utilities
  static const Color border = Color(0xFFE5E7EB);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}