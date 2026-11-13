import 'package:flutter/material.dart';
import '../model/alerta.dart';
import '../theme/app_theme.dart';

class SeloRisco extends StatelessWidget {
  final Alerta alerta;

  const SeloRisco({super.key, required this.alerta});

  @override
  Widget build(BuildContext context) {
    Color corFundo;
    Color corTexto;

    if (alerta.origem == 'previsao') {
      corFundo = AppTheme.fundoDoNivel(alerta.nivel);
      corTexto = AppTheme.textoDoNivel(alerta.nivel);
    } else if (alerta.aberto) {
      corFundo = const Color(0xFFFEF0DC);
      corTexto = const Color(0xFF8F4A06);
    } else {
      corFundo = const Color(0xFFE8EEED);
      corTexto = AppTheme.tintaSuave;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: corFundo,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        alerta.situacao,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: corTexto,
        ),
      ),
    );
  }
}