import 'package:flutter/material.dart';
import '../routes.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Cabecalho(),
              const SizedBox(height: 20),
              const _Destaque(),
              const SizedBox(height: 24),
              const Text(
                'Tipos de risco',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              const _GradeRiscos(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRotas.favoritos);
                      },
                      icon: const Icon(Icons.star_border),
                      label: const Text('Favoritos'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRotas.sobre);
                      },
                      icon: const Icon(Icons.info_outline),
                      label: const Text('Sobre'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const _CardEmergencia(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Cabecalho extends StatelessWidget {
  const _Cabecalho();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.verdeProfundo,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.shield_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Spate',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _Destaque extends StatelessWidget {
  const _Destaque();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.verdeProfundo,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Previsão e alertas de risco para o Brasil',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enchentes, deslizamentos, incêndios e ondas de calor, com orientações para a população.',
            style: TextStyle(fontSize: 14, color: Color(0xFFC9D6EA), height: 1.4),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRotas.alertas);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.verdeProfundo,
            ),
            child: const Text('Ver todos os alertas'),
          ),
        ],
      ),
    );
  }
}

class _GradeRiscos extends StatelessWidget {
  const _GradeRiscos();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: const [
        _CardRisco(
          id: 'floods',
          titulo: 'Enchentes',
          icone: Icons.water_drop_outlined,
          corIcone: Color(0xFF2563B0),
          corFundo: Color(0xFFE3EEFB),
        ),
        _CardRisco(
          id: 'landslides',
          titulo: 'Deslizamentos',
          icone: Icons.terrain_outlined,
          corIcone: Color(0xFF8A5A2B),
          corFundo: Color(0xFFF3EAE0),
        ),
        _CardRisco(
          id: 'wildfires',
          titulo: 'Incêndios',
          icone: Icons.local_fire_department_outlined,
          corIcone: Color(0xFFC2410C),
          corFundo: Color(0xFFFDE9E3),
        ),
        _CardRisco(
          id: 'tempExtremes',
          titulo: 'Ondas de calor',
          icone: Icons.thermostat_outlined,
          corIcone: Color(0xFFB45309),
          corFundo: Color(0xFFFFF1D6),
        ),
      ],
    );
  }
}

class _CardRisco extends StatelessWidget {
  final String id;
  final String titulo;
  final IconData icone;
  final Color corIcone;
  final Color corFundo;

  const _CardRisco({
    required this.id,
    required this.titulo,
    required this.icone,
    required this.corIcone,
    required this.corFundo,
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
        onTap: () {
          Navigator.pushNamed(context, AppRotas.alertas, arguments: id);
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: corFundo,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icone, color: corIcone),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Ver alertas',
                    style: TextStyle(fontSize: 12, color: AppTheme.tintaSuave),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardEmergencia extends StatelessWidget {
  const _CardEmergencia();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      shape: AppTheme.formaCard,
      child: const Padding(
        padding: EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFFFDE8E5),
              child: Icon(Icons.phone_outlined, color: Color(0xFFA3231A)),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Emergência',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Defesa Civil 199 · Bombeiros 193',
                    style: TextStyle(fontSize: 12, color: AppTheme.tintaSuave),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}