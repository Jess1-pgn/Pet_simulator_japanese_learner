import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs principales
  static const Color primaryColor = Color(0xFF6B4CE6);
  static const Color secondaryColor = Color(0xFFFF6B9D);
  static const Color accentColor = Color(0xFFFFC947);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color cardColor = Colors.white;

  // Couleurs pour les needs
  static const Color hungerColor = Color(0xFFFF9052);
  static const Color happinessColor = Color(0xFFFF6B9D);
  static const Color energyColor = Color(0xFF4CAF50);

  // Couleurs pour les moods du pet
  static const Map<String, Color> petMoodColors = {
    'happy':  Color(0xFFFFF176),
    'sad': Color(0xFF64B5F6),
    'hungry': Color(0xFFFFB74D),
    'sleepy': Color(0xFFBA68C8),
    'annoyed': Color(0xFFEF5350),
    'neutral': Color(0xFFBDBDBD),
  };

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment. topCenter,
    end: Alignment. bottomCenter,
    colors: [
      Color(0xFFE3F2FD),
      Color(0xFFF5F7FA),
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment. bottomRight,
    colors: [
      Colors.white,
      Color(0xFFF8F9FA),
    ],
  );

  // Ombres
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color:  Colors.black.withOpacity(0.15),
      blurRadius: 15,
      offset: const Offset(0, 5),
    ),
  ];

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color(0xFF2D3142),
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color(0xFF4F5D75),
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color:  Color(0xFF4F5D75),
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    color: Color(0xFF9FA8B6),
  );

  // Border Radius
  static BorderRadius smallRadius = BorderRadius.circular(12);
  static BorderRadius mediumRadius = BorderRadius.circular(16);
  static BorderRadius largeRadius = BorderRadius.circular(24);
}