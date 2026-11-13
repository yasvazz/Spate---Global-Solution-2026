import 'package:flutter/material.dart';
import '../model/alerta.dart';
import '../theme/app_theme.dart';
import 'selo_risco.dart';

class AlertaCard extends StatelessWidget {
  final Alerta alerta;
  final bool favorito;
  final VoidCallback aoTocar;
  final VoidCallback aoFavoritar;

  const AlertaCard({
    super.key,
    required this.alerta,
    required this.favorito,
    required this.aoTocar,
    required this.aoFavoritar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      shape: AppTheme.formaCard,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: aoTocar,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 6, 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.verdeClaro,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  AppTheme.iconeDaCategoria(alerta.categoriaId),
                  color: AppTheme.verdeMedio,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alerta.titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${alerta.tipo} · ${alerta.origemRotulo}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.tintaSuave,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        SeloRisco(alerta: alerta),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            alerta.dataFormatada,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.tintaSuave,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: aoFavoritar,
                tooltip: favorito ? 'Remover dos favoritos' : 'Favoritar',
                icon: Icon(
                  favorito ? Icons.star : Icons.star_border,
                  color: favorito ? AppTheme.favorito : AppTheme.tintaSuave,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}