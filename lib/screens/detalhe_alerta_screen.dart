import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/selo_risco.dart';
import '../data/preferencias_service.dart';
import '../model/alerta.dart';
import '../theme/app_theme.dart';

class DetalheAlertaScreen extends StatefulWidget {
  final Alerta alerta;

  const DetalheAlertaScreen({super.key, required this.alerta});

  @override
  State<DetalheAlertaScreen> createState() => _DetalheAlertaScreenState();
}

class _DetalheAlertaScreenState extends State<DetalheAlertaScreen> {
  final PreferenciasService _preferencias = PreferenciasService();

  bool _favorito = false;

  @override
  void initState() {
    super.initState();
    _carregarFavorito();
  }

  Future<void> _carregarFavorito() async {
    final favoritos = await _preferencias.obterFavoritos();
    if (!mounted) {
      return;
    }
    setState(() {
      _favorito = favoritos.any((f) => f.id == widget.alerta.id);
    });
  }

  Future<void> _alternarFavorito() async {
    await _preferencias.alternarFavorito(widget.alerta);
    if (!mounted) {
      return;
    }
    setState(() {
      _favorito = !_favorito;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _favorito ? 'Adicionado aos favoritos' : 'Removido dos favoritos',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _copiarLink() async {
    await Clipboard.setData(ClipboardData(text: widget.alerta.link));
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link copiado'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alerta = widget.alerta;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhe do alerta'),
        actions: [
          IconButton(
            onPressed: _alternarFavorito,
            tooltip: _favorito ? 'Remover dos favoritos' : 'Favoritar',
            icon: Icon(
              _favorito ? Icons.star : Icons.star_border,
              color: _favorito ? AppTheme.favorito : AppTheme.tintaSuave,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          _Cabecalho(alerta: alerta),
          const SizedBox(height: 16),
          _CartaoInformacoes(alerta: alerta),
          const SizedBox(height: 12),
          _CartaoOrientacoes(alerta: alerta),
          const SizedBox(height: 20),
          if (alerta.link.isNotEmpty)
            ElevatedButton.icon(
              onPressed: _copiarLink,
              icon: const Icon(Icons.link),
              label: const Text('Copiar link da fonte'),
            ),
          if (alerta.link.isNotEmpty) const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
          ),
        ],
      ),
    );
  }
}

class _Cabecalho extends StatelessWidget {
  final Alerta alerta;

  const _Cabecalho({required this.alerta});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.verdeClaro,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            AppTheme.iconeDaCategoria(alerta.categoriaId),
            color: AppTheme.verdeMedio,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alerta.titulo,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),
              SeloRisco(alerta: alerta),
            ],
          ),
        ),
      ],
    );
  }
}

class _CartaoInformacoes extends StatelessWidget {
  final Alerta alerta;

  const _CartaoInformacoes({required this.alerta});

  @override
  Widget build(BuildContext context) {
    final linhas = <Widget>[
      _LinhaInfo(
        icone: Icons.category_outlined,
        rotulo: 'Tipo',
        valor: alerta.tipo,
      ),
      _LinhaInfo(
        icone: Icons.calendar_today_outlined,
        rotulo: 'Última atualização',
        valor: alerta.dataFormatada,
      ),
      _LinhaInfo(
        icone: Icons.info_outline,
        rotulo: 'Situação',
        valor: alerta.situacao,
      ),
    ];

    if (alerta.latitude != null && alerta.longitude != null) {
      linhas.add(
        _LinhaInfo(
          icone: Icons.place_outlined,
          rotulo: 'Coordenadas',
          valor: alerta.coordenadasFormatadas,
        ),
      );
    }

    linhas.add(
      _LinhaInfo(
        icone: Icons.cloud_outlined,
        rotulo: 'Fonte',
        valor: alerta.fonte,
      ),
    );

    linhas.add(
      _LinhaInfo(
        icone: Icons.notes,
        rotulo: 'Descrição',
        valor: alerta.descricao,
      ),
    );

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
            for (int i = 0; i < linhas.length; i++) ...[
              linhas[i],
              if (i < linhas.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1, color: AppTheme.borda),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LinhaInfo extends StatelessWidget {
  final IconData icone;
  final String rotulo;
  final String valor;

  const _LinhaInfo({
    required this.icone,
    required this.rotulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icone, size: 20, color: AppTheme.verdeMedio),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rotulo,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.tintaSuave,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CartaoOrientacoes extends StatelessWidget {
  final Alerta alerta;

  const _CartaoOrientacoes({required this.alerta});

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
            const Row(
              children: [
                Icon(
                  Icons.health_and_safety_outlined,
                  size: 20,
                  color: AppTheme.verdeMedio,
                ),
                SizedBox(width: 8),
                Text(
                  'Como se proteger',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (final orientacao in alerta.orientacoes)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.check_circle_outline,
                        size: 18,
                        color: AppTheme.verdeMedio,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        orientacao,
                        style: const TextStyle(fontSize: 14, height: 1.45),
                      ),
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