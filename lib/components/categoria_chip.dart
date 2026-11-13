import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CategoriaChip extends StatelessWidget {
  final String rotulo;
  final IconData icone;
  final Color cor;
  final bool selecionado;
  final VoidCallback onTap;

  const CategoriaChip({
    super.key,
    required this.rotulo,
    required this.icone,
    required this.cor,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      avatar: Icon(
        icone,
        size: 18,
        color: selecionado ? Colors.white : cor,
      ),
      label: Text(rotulo),
      selected: selecionado,
      onSelected: (_) {
        onTap();
      },
      showCheckmark: false,
      selectedColor: AppTheme.verdeProfundo,
      backgroundColor: Colors.white,
      shape: StadiumBorder(
        side: BorderSide(
          color: selecionado ? AppTheme.verdeProfundo : AppTheme.borda,
        ),
      ),
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: selecionado ? Colors.white : AppTheme.tinta,
      ),
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }
}