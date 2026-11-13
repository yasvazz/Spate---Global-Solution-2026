import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_theme.dart';

class ImagemApp extends StatelessWidget {
  final String caminho;
  final IconData iconeAlternativo;
  final double tamanho;
  final Color cor;

  const ImagemApp({
    super.key,
    required this.caminho,
    required this.iconeAlternativo,
    this.tamanho = 120,
    this.cor = AppTheme.verdeMedio,
  });

  @override
  Widget build(BuildContext context) {
    if (caminho.endsWith('.lottie')) {
      return Lottie.asset(
        caminho,
        width: tamanho,
        height: tamanho,
        fit: BoxFit.contain,
        repeat: true,
        errorBuilder: (context, erro, pilha) {
          return Icon(iconeAlternativo, size: tamanho, color: cor);
        },
      );
    }

    return Image.asset(
      caminho,
      width: tamanho,
      height: tamanho,
      fit: BoxFit.contain,
      errorBuilder: (context, erro, pilha) {
        return Icon(iconeAlternativo, size: tamanho, color: cor);
      },
    );
  }
}