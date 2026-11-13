import 'package:flutter/material.dart';
import '../components/alerta_card.dart';
import '../components/categoria_chip.dart';
import '../components/estado_carregando.dart';
import '../components/estado_erro.dart';
import '../data/alertas_service.dart';
import '../data/preferencias_service.dart';
import '../model/alerta.dart';
import '../theme/app_theme.dart';
import 'detalhe_alerta_screen.dart';

enum EstadoTela { inicial, carregando, sucesso, erro }

class AlertasScreen extends StatefulWidget {
  const AlertasScreen({super.key});

  @override
  State<AlertasScreen> createState() => _AlertasScreenState();
}

class _AlertasScreenState extends State<AlertasScreen> {
  final AlertasService _servico = AlertasService();
  final PreferenciasService _preferencias = PreferenciasService();
  final TextEditingController _buscaController = TextEditingController();

  EstadoTela _estado = EstadoTela.inicial;
  String _mensagemErro = '';
  List<Alerta> _alertas = [];
  Set<String> _favoritos = {};
  String _categoriaSelecionada = 'todos';
  String _busca = '';
  bool _argumentoLido = false;

  final List<Map<String, dynamic>> _categorias = [
    {'id': 'todos', 'rotulo': 'Todos', 'icone': Icons.apps},
    {'id': 'floods', 'rotulo': 'Enchentes', 'icone': Icons.water_drop_outlined},
    {'id': 'landslides', 'rotulo': 'Deslizamentos', 'icone': Icons.terrain_outlined},
    {'id': 'wildfires', 'rotulo': 'Incêndios', 'icone': Icons.local_fire_department_outlined},
    {'id': 'tempExtremes', 'rotulo': 'Ondas de calor', 'icone': Icons.thermostat_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_argumentoLido) {
      return;
    }
    _argumentoLido = true;
    final argumento = ModalRoute.of(context)?.settings.arguments;
    if (argumento is String) {
      _categoriaSelecionada = argumento;
    }
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    setState(() {
      _estado = EstadoTela.carregando;
    });

    try {
      final alertas = await _servico.buscarAlertas();
      final favoritos = await _preferencias.obterFavoritos();
      if (!mounted) {
        return;
      }
      setState(() {
        _alertas = alertas;
        _favoritos = favoritos.map((f) => f.id).toSet();
        _estado = EstadoTela.sucesso;
      });
    } catch (erro) {
      if (!mounted) {
        return;
      }
      setState(() {
        _mensagemErro = erro.toString().replaceFirst('Exception: ', '');
        _estado = EstadoTela.erro;
      });
    }
  }

  List<Alerta> get _filtrados {
    return _alertas.where((alerta) {
      final categoriaOk = _categoriaSelecionada == 'todos' ||
          alerta.categoriaId == _categoriaSelecionada;
      final termo = _busca.trim().toLowerCase();
      final buscaOk = termo.isEmpty ||
          alerta.titulo.toLowerCase().contains(termo) ||
          alerta.tipo.toLowerCase().contains(termo);
      return categoriaOk && buscaOk;
    }).toList();
  }

  Future<void> _alternarFavorito(Alerta alerta) async {
    await _preferencias.alternarFavorito(alerta);
    if (!mounted) {
      return;
    }
    final agoraFavorito = !_favoritos.contains(alerta.id);
    setState(() {
      if (agoraFavorito) {
        _favoritos.add(alerta.id);
      } else {
        _favoritos.remove(alerta.id);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          agoraFavorito
              ? 'Adicionado aos favoritos'
              : 'Removido dos favoritos',
        ),
        duration: const Duration(seconds: 2),
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
    if (!mounted) {
      return;
    }
    final favoritos = await _preferencias.obterFavoritos();
    if (!mounted) {
      return;
    }
    setState(() {
      _favoritos = favoritos.map((f) => f.id).toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas'),
        actions: [
          IconButton(
            onPressed: _carregar,
            tooltip: 'Atualizar',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: TextField(
              controller: _buscaController,
              onChanged: (valor) {
                setState(() {
                  _busca = valor;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar por cidade ou tipo',
                prefixIcon: const Icon(Icons.search, color: AppTheme.tintaSuave),
                suffixIcon: _busca.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _buscaController.clear();
                          setState(() {
                            _busca = '';
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _categorias.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final categoria = _categorias[index];
                return CategoriaChip(
                  rotulo: categoria['rotulo'] as String,
                  icone: categoria['icone'] as IconData,
                  cor: AppTheme.verdeMedio,
                  selecionado: _categoriaSelecionada == categoria['id'],
                  onTap: () {
                    setState(() {
                      _categoriaSelecionada = categoria['id'] as String;
                    });
                  },
                );
              },
            ),
          ),
          Expanded(child: _conteudo()),
        ],
      ),
    );
  }

  Widget _conteudo() {
    if (_estado == EstadoTela.carregando || _estado == EstadoTela.inicial) {
      return const EstadoCarregando();
    }

    if (_estado == EstadoTela.erro) {
      return EstadoErro(
        mensagem: _mensagemErro,
        aoTentarNovamente: _carregar,
      );
    }

    final lista = _filtrados;

    if (lista.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Nenhum alerta encontrado para este filtro.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.tintaSuave),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        itemCount: lista.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final alerta = lista[index];
          return AlertaCard(
            alerta: alerta,
            favorito: _favoritos.contains(alerta.id),
            aoTocar: () {
              _abrirDetalhe(alerta);
            },
            aoFavoritar: () {
              _alternarFavorito(alerta);
            },
          );
        },
      ),
    );
  }
}