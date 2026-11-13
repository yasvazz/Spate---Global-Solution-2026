import 'package:flutter/material.dart';
import '../components/imagem_app.dart';
import '../data/preferencias_service.dart';
import '../routes.dart';
import '../theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controlador = PageController();
  final PreferenciasService _preferencias = PreferenciasService();

  int _paginaAtual = 0;
  bool _naoMostrarNovamente = false;

  final List<Map<String, dynamic>> _paginas = [
    {
      'animacao': 'assets/lottie/onboarding_satelite.lottie',
      'icone': Icons.satellite_alt,
      'titulo': 'Olhos no espaço',
      'texto':
          'Satélites e modelos de previsão ajudam a monitorar chuva, calor e focos de incêndio em todo o Brasil.',
    },
    {
      'animacao': 'assets/lottie/onboarding_alerta.lottie',
      'icone': Icons.notifications_active,
      'titulo': 'Alertas que importam',
      'texto':
          'Veja os eventos por tipo, filtre, busque por cidade e salve seus favoritos.',
    },
    {
      'animacao': 'assets/lottie/onboarding_protecao.lottie',
      'icone': Icons.shield_outlined,
      'titulo': 'Proteção para a população',
      'texto':
          'Cada alerta traz orientações de segurança e os contatos da Defesa Civil (199) e dos Bombeiros (193).',
    },
  ];

  bool get _ultimaPagina => _paginaAtual == _paginas.length - 1;

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  Future<void> _finalizar() async {
    await _preferencias.salvarNaoMostrarIntroducao(_naoMostrarNovamente);
    if (!mounted) {
      return;
    }
    Navigator.pushReplacementNamed(context, AppRotas.home);
  }

  void _avancar() {
    if (_ultimaPagina) {
      _finalizar();
      return;
    }
    _controlador.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _voltar() {
    _controlador.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextButton(
                  onPressed: _finalizar,
                  child: const Text('Pular'),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controlador,
                itemCount: _paginas.length,
                onPageChanged: (indice) {
                  setState(() {
                    _paginaAtual = indice;
                  });
                },
                itemBuilder: (context, indice) {
                  final pagina = _paginas[indice];
                  return _PaginaOnboarding(
                    animacao: pagina['animacao'] as String,
                    icone: pagina['icone'] as IconData,
                    titulo: pagina['titulo'] as String,
                    texto: pagina['texto'] as String,
                  );
                },
              ),
            ),
            _Indicador(total: _paginas.length, atual: _paginaAtual),
            if (_ultimaPagina)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CheckboxListTile(
                  value: _naoMostrarNovamente,
                  onChanged: (valor) {
                    setState(() {
                      _naoMostrarNovamente = valor ?? false;
                    });
                  },
                  title: const Text(
                    'Não mostrar novamente',
                    style: TextStyle(fontSize: 14),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppTheme.verdeProfundo,
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Row(
                children: [
                  if (_paginaAtual > 0)
                    TextButton(
                      onPressed: _voltar,
                      child: const Text('Voltar'),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _avancar,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(140, 48),
                    ),
                    child: Text(_ultimaPagina ? 'Começar' : 'Avançar'),
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

class _PaginaOnboarding extends StatelessWidget {
  final String animacao;
  final IconData icone;
  final String titulo;
  final String texto;

  const _PaginaOnboarding({
    required this.animacao,
    required this.icone,
    required this.titulo,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImagemApp(
            caminho: animacao,
            iconeAlternativo: icone,
            tamanho: 200,
            cor: AppTheme.verdeMedio,
          ),
          const SizedBox(height: 32),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Text(
            texto,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: AppTheme.tintaSuave,
            ),
          ),
        ],
      ),
    );
  }
}

class _Indicador extends StatelessWidget {
  final int total;
  final int atual;

  const _Indicador({required this.total, required this.atual});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (indice) {
        final ativo = indice == atual;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: ativo ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: ativo ? AppTheme.verdeProfundo : AppTheme.borda,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}