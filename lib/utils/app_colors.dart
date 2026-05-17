import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF0B0B0F);
  static const Color cardDark = Color(0xFF181822);
  static const Color accent = Color(0xFFF9325F);
  static const Color accentDark = Color(0xFFC71A43);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8B8B99);
  static const Color border = Color(0xFF2A2A35);
  static const Color success = Color(0xFF4ADE80);
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFF9325F), Color(0xFFFF5E80)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF232530), Color(0xFF16161E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}