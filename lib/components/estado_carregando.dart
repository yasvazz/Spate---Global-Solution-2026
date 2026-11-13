import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EstadoCarregando extends StatelessWidget {
  final String mensagem;

  const EstadoCarregando({
    super.key,
    this.mensagem = 'Buscando alertas...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppTheme.verdeMedio),
          const SizedBox(height: 16),
          Text(
            mensagem,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.tintaSuave,
            ),
          ),
        ],
      ),
    );
  }
}