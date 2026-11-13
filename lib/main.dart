import 'package:flutter/material.dart';

import 'routes.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SpateApp());
}

class SpateApp extends StatelessWidget {
  const SpateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.tema,
      initialRoute: AppRotas.splash,
      routes: AppRotas.rotas,
    );
  }
}