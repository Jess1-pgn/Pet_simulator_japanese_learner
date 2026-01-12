import 'package:flutter/material.dart';

class AppTheme {
  // ==================== GRADIENTS ====================

  // Nouveau gradient principal (violet → rose)
  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF667EEA), // Violet
      Color(0xFF764BA2), // Violet foncé
      Color(0xFFF093FB), // Rose clair
    ],
  );

  // Gradient du background interne (comme HTML)
  static const LinearGradient phoneGradient = LinearGradient(
    begin: Alignment. topCenter,
    end: Alignment. bottomCenter,
    colors: [
      Color(0xFFFFEAA7), // Jaune pastel
      Color(0xFFFDCB6E), // Orange clair
      Color(0xFFFAB1A0), // Saumon
      Color(0xFFFD79A8), // Rose
      Color(0xFFA29BFE), // Violet clair
    ],
  );

  // Ancien gradient (pour compatibilité)
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment. topCenter,
    end: Alignment. bottomCenter,
    colors: [
      Color(0xFFFFE5EC),
      Color(0xFFFFF0F5),
      Color(0xFFE6F3FF),
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment. topLeft,
    end:  Alignment.bottomRight,
    colors: [
      Colors.white,
      Color(0xFFF8F9FA),
    ],
  );

  // Gradient de la barre circulaire
  static const List<Color> ringGradient = [
    Color(0xFFFF6B9D), // Rose
    Color(0xFFFECA57), // Orange/jaune
  ];

  // ==================== COULEURS ====================

  static const Color primaryColor = Color(0xFF667EEA);
  static const Color secondaryColor = Color(0xFFFF6B9D);
  static const Color accentColor = Color(0xFFFECA57);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color cardColor = Colors.white;

  // Couleurs pour les needs (ancien système)
  static const Color hungerColor = Color(0xFFFF9052);
  static const Color happinessColor = Color(0xFFFF6B9D);
  static const Color energyColor = Color(0xFF4CAF50);

  // Couleurs pour les moods du pet
  static const Map<String, Color> petMoodColors = {
    'happy': Color(0xFFFFF176),
    'sad': Color(0xFF64B5F6),
    'neutral': Color(0xFFBDBDBD),
    'depressed': Color(0xFF9E9E9E),
  };

  // ==================== DECORATIONS ====================

  // Glassmorphism effect
  static BoxDecoration glassDecoration = BoxDecoration(
    color: Colors.white. withOpacity(0.3),
    borderRadius: BorderRadius.circular(25),
    border: Border.all(
      color: Colors.white.withOpacity(0.5),
      width: 2,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors. black.withOpacity(0.15),
        blurRadius: 25,
        offset: const Offset(0, 8),
      ),
    ],
  );

  // Ombres pour cards
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

  // ==================== TEXT STYLES ====================

  // Titres principaux
  static const TextStyle titleStyle = TextStyle(
    fontSize:  28,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    shadows: [
      Shadow(
        color: Colors. black26,
        offset: Offset(0, 4),
        blurRadius: 12,
      ),
    ],
  );

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

  // Stats
  static const TextStyle statStyle = TextStyle(
    fontSize:  16,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  // Body text
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color:  Color(0xFF4F5D75),
  );

  // Caption/petit texte
  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    color: Color(0xFF9FA8B6),
  );

  // Boutons
  static const TextStyle buttonLabelStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    shadows: [
      Shadow(
        color: Colors.black26,
        offset: Offset(0, 2),
        blurRadius: 6,
      ),
    ],
  );

  // ==================== BORDER RADIUS ====================

  static BorderRadius smallRadius = BorderRadius.circular(12);
  static BorderRadius mediumRadius = BorderRadius.circular(16);
  static BorderRadius largeRadius = BorderRadius.circular(24);

  // ==================== THEME DATA ====================

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      useMaterial3: true,
      fontFamily: 'Roboto',
      colorScheme:  ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      textTheme: const TextTheme(
        displayLarge: titleStyle,
        displayMedium: headingStyle,
        displaySmall: subheadingStyle,
        bodyLarge: bodyStyle,
        bodyMedium: bodyStyle,
        bodySmall: captionStyle,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 8,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius:  BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}