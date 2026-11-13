import 'package:flutter/material.dart';
import '../components/imagem_app.dart';
import '../data/preferencias_service.dart';
import '../routes.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PreferenciasService _preferencias = PreferenciasService();

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    await Future.delayed(const Duration(seconds: 3));
    final pularIntroducao = await _preferencias.naoMostrarIntroducao();
    if (!mounted) {
      return;
    }
    Navigator.pushReplacementNamed(
      context,
      pularIntroducao ? AppRotas.home : AppRotas.onboarding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.verdeProfundo,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImagemApp(
              caminho: 'assets/images/logo.png',
              iconeAlternativo: Icons.shield_outlined,
              tamanho: 120,
              cor: Colors.white,
            ),
            SizedBox(height: 24),
            Text(
              'Spate',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Alertas de risco para a população',
              style: TextStyle(fontSize: 14, color: Color(0xFFC9D6EA)),
            ),
          ],
        ),
      ),
    );
  }
}