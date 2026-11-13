import 'package:flutter/material.dart';
import '../components/alerta_card.dart';
import '../components/estado_carregando.dart';
import '../data/preferencias_service.dart';
import '../model/alerta.dart';
import '../theme/app_theme.dart';
import 'detalhe_alerta_screen.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  final PreferenciasService _preferencias = PreferenciasService();

  bool _carregando = true;
  List<Alerta> _favoritos = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final favoritos = await _preferencias.obterFavoritos();
    if (!mounted) {
      return;
    }
    setState(() {
      _favoritos = favoritos;
      _carregando = false;
    });
  }

  Future<void> _remover(Alerta alerta) async {
    await _preferencias.alternarFavorito(alerta);
    await _carregar();
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removido dos favoritos'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _abrirDetalhe(Alerta alerta) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalheAlertaScreen(alerta: alerta),
      ),
    );
    await _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: _corpo(),
    );
  }

  Widget _corpo() {
    if (_carregando) {
      return const EstadoCarregando(mensagem: 'Carregando favoritos...');
    }

    if (_favoritos.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_border, size: 48, color: AppTheme.tintaSuave),
              SizedBox(height: 16),
              Text(
                'Nenhum favorito ainda',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 8),
              Text(
                'Toque na estrela de um alerta para guardá-lo aqui.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.tintaSuave),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: _favoritos.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final alerta = _favoritos[index];
        return AlertaCard(
          alerta: alerta,
          favorito: true,
          aoTocar: () {
            _abrirDetalhe(alerta);
          },
          aoFavoritar: () {
            _remover(alerta);
          },
        );
      },
    );
  }
}