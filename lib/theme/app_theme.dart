import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color verdeProfundo = Color(0xFF14284B);
  static const Color verdeMedio = Color(0xFF2D5FAA);
  static const Color verdeClaro = Color(0xFFE8EEF8);
  static const Color coral = Color(0xFF2D5FAA);
  static const Color fundo = Color(0xFFF5F7FA);
  static const Color tinta = Color(0xFF101C2E);
  static const Color tintaSuave = Color(0xFF56657A);
  static const Color borda = Color(0xFFDDE3EC);
  static const Color favorito = Color(0xFFE8A317);

  static const Color azulEspaco = verdeProfundo;
  static const Color laranja = coral;

  static Color corDaCategoria(String categoriaId) {
    return verdeMedio;
  }

  static Color corDoNivel(int nivel) {
    switch (nivel) {
      case 0:
        return const Color(0xFF2E9E75);
      case 1:
        return const Color(0xFFD9A21B);
      case 2:
        return const Color(0xFFE07B1A);
      default:
        return const Color(0xFFD6392B);
    }
  }

  static Color fundoDoNivel(int nivel) {
    switch (nivel) {
      case 0:
        return const Color(0xFFE1F3EA);
      case 1:
        return const Color(0xFFFFF4CC);
      case 2:
        return const Color(0xFFFEF0DC);
      default:
        return const Color(0xFFFDE8E5);
    }
  }

  static Color textoDoNivel(int nivel) {
    switch (nivel) {
      case 0:
        return const Color(0xFF0E6B4C);
      case 1:
        return const Color(0xFF7A5200);
      case 2:
        return const Color(0xFF8F4A06);
      default:
        return const Color(0xFFA3231A);
    }
  }

  static IconData iconeDaCategoria(String categoriaId) {
    switch (categoriaId) {
      case 'floods':
        return Icons.water_drop_outlined;
      case 'landslides':
        return Icons.terrain_outlined;
      case 'wildfires':
        return Icons.local_fire_department_outlined;
      case 'tempExtremes':
        return Icons.thermostat_outlined;
      default:
        return Icons.warning_amber_outlined;
    }
  }

  static String gifDaCategoria(String categoriaId) {
    switch (categoriaId) {
      case 'floods':
        return 'assets/gifs/enchente.gif';
      case 'landslides':
        return 'assets/gifs/deslizamento.gif';
      case 'wildfires':
        return 'assets/gifs/incendio.gif';
      case 'tempExtremes':
        return 'assets/gifs/calor.gif';
      default:
        return 'assets/gifs/alerta.gif';
    }
  }

  static const ShapeBorder formaCard = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(14)),
    side: BorderSide(color: borda),
  );

  static ThemeData get tema {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: verdeProfundo,
        primary: verdeProfundo,
        secondary: verdeMedio,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: fundo,
    );

    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: tinta,
        displayColor: tinta,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: fundo,
        foregroundColor: tinta,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: tinta,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: verdeProfundo,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: verdeProfundo,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: verdeProfundo),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: verdeMedio,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        hintStyle: GoogleFonts.inter(fontSize: 14, color: tintaSuave),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borda),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borda),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: verdeProfundo, width: 1.5),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: tinta,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}