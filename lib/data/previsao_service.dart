import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/alerta.dart';

class PrevisaoService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  static const List<_Cidade> _cidades = [
    _Cidade('São Paulo', 'SP', -23.5505, -46.6333),
    _Cidade('Rio de Janeiro', 'RJ', -22.9068, -43.1729),
    _Cidade('Belo Horizonte', 'MG', -19.9167, -43.9345),
    _Cidade('Salvador', 'BA', -12.9777, -38.5016),
    _Cidade('Recife', 'PE', -8.0476, -34.8770),
    _Cidade('Fortaleza', 'CE', -3.7319, -38.5267),
    _Cidade('Manaus', 'AM', -3.1190, -60.0217),
    _Cidade('Porto Alegre', 'RS', -30.0346, -51.2177),
    _Cidade('Curitiba', 'PR', -25.4284, -49.2733),
    _Cidade('Brasília', 'DF', -15.7939, -47.8828),
    _Cidade('Cuiabá', 'MT', -15.6014, -56.0979),
    _Cidade('Petrópolis', 'RJ', -22.5112, -43.1779),
  ];

  Future<List<Alerta>> buscarAlertas() async {
    final latitudes = _cidades.map((cidade) => cidade.latitude).join(',');
    final longitudes = _cidades.map((cidade) => cidade.longitude).join(',');
    final uri = Uri.parse(
      '$_baseUrl?latitude=$latitudes&longitude=$longitudes'
      '&daily=temperature_2m_max,precipitation_sum,wind_speed_10m_max'
      '&timezone=America%2FSao_Paulo&past_days=2&forecast_days=3',
    );

    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json'},
    ).timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception(
        'Não foi possível carregar a previsão. '
        'Código HTTP: ${response.statusCode}',
      );
    }

    final decodificado = jsonDecode(response.body);
    final respostas = decodificado is List ? decodificado : [decodificado];

    final alertas = <Alerta>[];
    for (var i = 0; i < respostas.length && i < _cidades.length; i++) {
      alertas.addAll(
        _gerarAlertas(_cidades[i], respostas[i] as Map<String, dynamic>),
      );
    }
    return alertas;
  }

  List<Alerta> _gerarAlertas(_Cidade cidade, Map<String, dynamic> resposta) {
    final diario = resposta['daily'] as Map<String, dynamic>;
    final datas =
        (diario['time'] as List<dynamic>).map((data) => data.toString()).toList();
    if (datas.isEmpty) {
      return [];
    }

    final temperaturas = _numeros(diario['temperature_2m_max']);
    final chuvas = _numeros(diario['precipitation_sum']);
    final ventos = _numeros(diario['wind_speed_10m_max']);
    final inicio = datas.length > 3 ? datas.length - 3 : 0;

    return [
      _alertaEnchente(cidade, datas, chuvas, inicio),
      _alertaDeslizamento(cidade, datas, chuvas),
      _alertaIncendio(cidade, datas, temperaturas, chuvas, ventos),
      _alertaCalor(cidade, datas, temperaturas, inicio),
    ];
  }

  Alerta _alertaEnchente(
    _Cidade cidade,
    List<String> datas,
    List<double> chuvas,
    int inicio,
  ) {
    final indice = _indiceDoMaximo(chuvas, inicio);
    final chuva = chuvas[indice];
    return _criarAlerta(
      cidade: cidade,
      categoriaId: 'floods',
      data: datas[indice],
      nivel: _calcularNivel(chuva, 20, 50, 100),
      detalhe:
          'Chuva máxima prevista de ${chuva.toStringAsFixed(0)} mm em um dia '
          '(${_formatarDia(datas[indice])}).',
    );
  }

  Alerta _alertaDeslizamento(
    _Cidade cidade,
    List<String> datas,
    List<double> chuvas,
  ) {
    var melhorSoma = 0.0;
    var melhorIndice = chuvas.length - 1;
    for (var i = 2; i < chuvas.length; i++) {
      final soma = chuvas[i] + chuvas[i - 1] + chuvas[i - 2];
      if (soma >= melhorSoma) {
        melhorSoma = soma;
        melhorIndice = i;
      }
    }
    return _criarAlerta(
      cidade: cidade,
      categoriaId: 'landslides',
      data: datas[melhorIndice],
      nivel: _calcularNivel(melhorSoma, 50, 100, 150),
      detalhe:
          'Chuva acumulada de ${melhorSoma.toStringAsFixed(0)} mm em 3 dias '
          'até ${_formatarDia(datas[melhorIndice])}. '
          'O solo encharcado aumenta o risco em encostas.',
    );
  }

  Alerta _alertaIncendio(
    _Cidade cidade,
    List<String> datas,
    List<double> temperaturas,
    List<double> chuvas,
    List<double> ventos,
  ) {
    final diasSecos = chuvas.where((chuva) => chuva < 1).length;
    final temperaturaMaxima = _maximo(temperaturas);
    final ventoMaximo = _maximo(ventos);

    var pontos = 0;
    if (temperaturaMaxima >= 35) {
      pontos += 2;
    } else if (temperaturaMaxima >= 30) {
      pontos += 1;
    }
    if (diasSecos >= 5) {
      pontos += 2;
    } else if (diasSecos >= 3) {
      pontos += 1;
    }
    if (ventoMaximo >= 30) {
      pontos += 1;
    }

    var nivel = 0;
    if (pontos >= 4) {
      nivel = 3;
    } else if (pontos == 3) {
      nivel = 2;
    } else if (pontos == 2) {
      nivel = 1;
    }

    final indice = _indiceDoMaximo(temperaturas, 0);
    return _criarAlerta(
      cidade: cidade,
      categoriaId: 'wildfires',
      data: datas[indice],
      nivel: nivel,
      detalhe:
          '$diasSecos de ${datas.length} dias sem chuva relevante, '
          'máxima de ${temperaturaMaxima.toStringAsFixed(0)} °C e vento de '
          'até ${ventoMaximo.toStringAsFixed(0)} km/h.',
    );
  }

  Alerta _alertaCalor(
    _Cidade cidade,
    List<String> datas,
    List<double> temperaturas,
    int inicio,
  ) {
    final indice = _indiceDoMaximo(temperaturas, inicio);
    final temperatura = temperaturas[indice];
    return _criarAlerta(
      cidade: cidade,
      categoriaId: 'tempExtremes',
      data: datas[indice],
      nivel: _calcularNivel(temperatura, 33, 35, 38),
      detalhe:
          'Temperatura máxima prevista de ${temperatura.toStringAsFixed(0)} °C '
          'em ${_formatarDia(datas[indice])}.',
    );
  }

  Alerta _criarAlerta({
    required _Cidade cidade,
    required String categoriaId,
    required String data,
    required int nivel,
    required String detalhe,
  }) {
    return Alerta(
      id: 'PREV_${cidade.nome}_${categoriaId}_$data',
      titulo: '${cidade.nome} (${cidade.uf})',
      descricao: '$detalhe ${_mensagemDoNivel(nivel)}',
      categoriaId: categoriaId,
      categoriaTitulo: '',
      data: data,
      latitude: cidade.latitude,
      longitude: cidade.longitude,
      fonte: 'Open-Meteo',
      link: 'https://open-meteo.com',
      aberto: true,
      origem: 'previsao',
      nivel: nivel,
    );
  }

  String _mensagemDoNivel(int nivel) {
    switch (nivel) {
      case 0:
        return 'Sem risco relevante no momento.';
      case 1:
        return 'Fique atento às atualizações.';
      case 2:
        return 'Evite áreas de risco e acompanhe a Defesa Civil.';
      default:
        return 'Risco severo: siga as orientações da Defesa Civil.';
    }
  }

  int _calcularNivel(double valor, double moderado, double alto, double muitoAlto) {
    if (valor >= muitoAlto) {
      return 3;
    }
    if (valor >= alto) {
      return 2;
    }
    if (valor >= moderado) {
      return 1;
    }
    return 0;
  }

  List<double> _numeros(dynamic lista) {
    return (lista as List<dynamic>)
        .map((valor) => (valor as num?)?.toDouble() ?? 0.0)
        .toList();
  }

  double _maximo(List<double> valores) {
    var maximo = 0.0;
    for (final valor in valores) {
      if (valor > maximo) {
        maximo = valor;
      }
    }
    return maximo;
  }

  int _indiceDoMaximo(List<double> valores, int inicio) {
    var indice = inicio;
    for (var i = inicio; i < valores.length; i++) {
      if (valores[i] > valores[indice]) {
        indice = i;
      }
    }
    return indice;
  }

  String _formatarDia(String data) {
    final partes = data.split('-');
    if (partes.length != 3) {
      return data;
    }
    return '${partes[2]}/${partes[1]}';
  }
}

class _Cidade {
  final String nome;
  final String uf;
  final double latitude;
  final double longitude;

  const _Cidade(this.nome, this.uf, this.latitude, this.longitude);
}