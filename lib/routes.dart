import 'package:flutter/material.dart';

import 'screens/alertas_screen.dart';
import 'screens/favoritos_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/sobre_screen.dart';
import 'screens/splash_screen.dart';

class AppRotas {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String alertas = '/alertas';
  static const String favoritos = '/favoritos';
  static const String sobre = '/sobre';

  static Map<String, WidgetBuilder> get rotas => {
        splash: (_) => const SplashScreen(),
        onboarding: (_) => const OnboardingScreen(),
        home: (_) => const HomeScreen(),
        alertas: (_) => const AlertasScreen(),
        favoritos: (_) => const FavoritosScreen(),
        sobre: (_) => const SobreScreen(),
      };
} 