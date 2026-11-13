import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: const [
          _Secao(
            titulo: 'O aplicativo',
            icone: Icons.shield_outlined,
            filhos: [
              _Texto(
                'O Spate reúne previsões e eventos monitorados por satélite para alertar a população sobre enchentes, deslizamentos, incêndios e ondas de calor no Brasil.',
              ),
              _Texto(
                'Projeto da Global Solution 2026, tema Indústria Espacial. Objetivos de Desenvolvimento Sustentável: ODS 9, ODS 11 e ODS 13.',
              ),
            ],
          ),
          SizedBox(height: 12),
          _Secao(
            titulo: 'Fontes de dados',
            icone: Icons.cloud_outlined,
            filhos: [
              _Item(
                titulo: 'Open-Meteo',
                texto:
                    'Previsão de chuva, temperatura e vento para 12 cidades brasileiras.',
              ),
              _Item(
                titulo: 'NASA EONET',
                texto:
                    'Eventos naturais monitorados por satélite na América do Sul.',
              ),
              _Item(
                titulo: 'BigDataCloud',
                texto:
                    'Identificação do local (cidade e estado) a partir das coordenadas.',
              ),
            ],
          ),
          SizedBox(height: 12),
          _Secao(
            titulo: 'Aviso',
            icone: Icons.warning_amber_outlined,
            filhos: [
              _Texto(
                'Os níveis de risco são estimativas simplificadas, inspiradas em critérios públicos de órgãos como o INMET, e não substituem os alertas oficiais. Em caso de emergência, ligue para a Defesa Civil (199) ou para os Bombeiros (193).',
              ),
            ],
          ),
          SizedBox(height: 12),
          _Secao(
            titulo: 'Desenvolvedores',
            icone: Icons.people_outline,
            filhos: [
              _Item(
                titulo: 'Yasmin Vaz De Siqueira',
                texto: 'RM556763',
              ),
              _Item(
                titulo: 'João Vinicius Hotz Nascimento',
                texto: 'RM556402',
              ),
            ],
          ),
          SizedBox(height: 12),
          _Secao(
            titulo: 'Créditos',
            icone: Icons.favorite_border,
            filhos: [
              _Texto(
                'Animações do Onboarding: LottieFiles, licença gratuita, com créditos aos autores originais.',
              ),
              _Texto('Ícones: Material Icons. Fonte: Inter (Google Fonts).'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Secao extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final List<Widget> filhos;

  const _Secao({
    required this.titulo,
    required this.icone,
    required this.filhos,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      shape: AppTheme.formaCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icone, size: 20, color: AppTheme.verdeMedio),
                const SizedBox(width: 8),
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...filhos,
          ],
        ),
      ),
    );
  }
}

class _Texto extends StatelessWidget {
  final String texto;

  const _Texto(this.texto);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
          color: AppTheme.tintaSuave,
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String titulo;
  final String texto;

  const _Item({required this.titulo, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            texto,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: AppTheme.tintaSuave,
            ),
          ),
        ],
      ),
    );
  }
}