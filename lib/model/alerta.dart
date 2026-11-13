class Alerta {
  final String id;
  final String titulo;
  final String descricao;
  final String categoriaId;
  final String categoriaTitulo;
  final String data;
  final double? latitude;
  final double? longitude;
  final String fonte;
  final String link;
  final bool aberto;
  final String origem;
  final int nivel;

  const Alerta({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.categoriaId,
    required this.categoriaTitulo,
    required this.data,
    required this.latitude,
    required this.longitude,
    required this.fonte,
    required this.link,
    required this.aberto,
    required this.origem,
    required this.nivel,
  });

  factory Alerta.fromJson(Map<String, dynamic> json) {
    final categorias = json['categories'] as List<dynamic>? ?? [];
    final categoria = categorias.isNotEmpty
        ? categorias.first as Map<String, dynamic>
        : <String, dynamic>{};

    final fontes = json['sources'] as List<dynamic>? ?? [];
    final fonte = fontes.isNotEmpty
        ? fontes.first as Map<String, dynamic>
        : <String, dynamic>{};

    final geometrias = json['geometry'] as List<dynamic>? ?? [];
    final geometria = geometrias.isNotEmpty
        ? geometrias.last as Map<String, dynamic>
        : <String, dynamic>{};

    double? latitude;
    double? longitude;
    final coordenadas = geometria['coordinates'];
    if (coordenadas is List &&
        coordenadas.length >= 2 &&
        coordenadas[0] is num &&
        coordenadas[1] is num) {
      longitude = (coordenadas[0] as num).toDouble();
      latitude = (coordenadas[1] as num).toDouble();
    }

    final String categoriaId = categoria['id'] ?? '';
    final String categoriaTitulo = categoria['title'] ?? '';
    final String tituloOriginal = json['title'] ?? '';
    final tipo = _nomeDoTipo(categoriaId, categoriaTitulo);

    final tituloPadrao = (latitude == null || longitude == null)
        ? tipo
        : '$tipo (${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)})';

    return Alerta(
      id: json['id'] ?? '',
      titulo: tituloPadrao,
      descricao:
          'Evento monitorado por satélite pela NASA. Nome original: $tituloOriginal',
      categoriaId: categoriaId,
      categoriaTitulo: categoriaTitulo,
      data: geometria['date'] ?? '',
      latitude: latitude,
      longitude: longitude,
      fonte: fonte['id'] ?? 'NASA EONET',
      link: fonte['url'] ?? json['link'] ?? '',
      aberto: json['closed'] == null,
      origem: 'satelite',
      nivel: 0,
    );
  }

  factory Alerta.fromMap(Map<String, dynamic> mapa) {
    return Alerta(
      id: mapa['id'] ?? '',
      titulo: mapa['titulo'] ?? '',
      descricao: mapa['descricao'] ?? '',
      categoriaId: mapa['categoriaId'] ?? '',
      categoriaTitulo: mapa['categoriaTitulo'] ?? '',
      data: mapa['data'] ?? '',
      latitude: (mapa['latitude'] as num?)?.toDouble(),
      longitude: (mapa['longitude'] as num?)?.toDouble(),
      fonte: mapa['fonte'] ?? '',
      link: mapa['link'] ?? '',
      aberto: mapa['aberto'] ?? true,
      origem: mapa['origem'] ?? 'previsao',
      nivel: mapa['nivel'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'categoriaId': categoriaId,
      'categoriaTitulo': categoriaTitulo,
      'data': data,
      'latitude': latitude,
      'longitude': longitude,
      'fonte': fonte,
      'link': link,
      'aberto': aberto,
      'origem': origem,
      'nivel': nivel,
    };
  }

  Alerta comTitulo(String novoTitulo) {
    return Alerta(
      id: id,
      titulo: novoTitulo,
      descricao: descricao,
      categoriaId: categoriaId,
      categoriaTitulo: categoriaTitulo,
      data: data,
      latitude: latitude,
      longitude: longitude,
      fonte: fonte,
      link: link,
      aberto: aberto,
      origem: origem,
      nivel: nivel,
    );
  }

  static String _nomeDoTipo(String categoriaId, String categoriaTitulo) {
    switch (categoriaId) {
      case 'wildfires':
        return 'Incêndio';
      case 'floods':
        return 'Enchente';
      case 'landslides':
        return 'Deslizamento';
      case 'tempExtremes':
        return 'Onda de calor';
      default:
        return categoriaTitulo;
    }
  }

  String get tipo {
    return _nomeDoTipo(categoriaId, categoriaTitulo);
  }

  String get origemRotulo {
    return origem == 'previsao' ? 'Previsão' : 'Satélite NASA';
  }

  String get nivelRotulo {
    switch (nivel) {
      case 0:
        return 'Risco baixo';
      case 1:
        return 'Risco moderado';
      case 2:
        return 'Risco alto';
      default:
        return 'Risco muito alto';
    }
  }

  String get situacao {
    if (origem == 'previsao') {
      return nivelRotulo;
    }
    return aberto ? 'Ativo' : 'Encerrado';
  }

  String get dataFormatada {
    final dataConvertida = DateTime.tryParse(data);
    if (dataConvertida == null) {
      return 'Data não informada';
    }
    final local = dataConvertida.toLocal();
    final dia = local.day.toString().padLeft(2, '0');
    final mes = local.month.toString().padLeft(2, '0');
    return '$dia/$mes/${local.year}';
  }

  String get coordenadasFormatadas {
    final lat = latitude;
    final lon = longitude;
    if (lat == null || lon == null) {
      return 'Não informadas';
    }
    return '${lat.toStringAsFixed(4)}, ${lon.toStringAsFixed(4)}';
  }

  List<String> get orientacoes {
    switch (categoriaId) {
      case 'floods':
        return [
          'Evite áreas alagadas e não atravesse água em movimento.',
          'Desligue a energia elétrica se a água entrar em casa.',
          'Procure um local alto e siga a Defesa Civil (telefone 199).',
        ];
      case 'landslides':
        return [
          'Afaste-se de encostas após chuvas intensas.',
          'Fique atento a rachaduras, árvores inclinadas e barulho de terra se movendo.',
          'Em caso de risco, saia do local e ligue para a Defesa Civil (199).',
        ];
      case 'wildfires':
        return [
          'Afaste-se da área e siga as rotas de evacuação indicadas.',
          'Feche portas e janelas e evite respirar fumaça.',
          'Ligue para o Corpo de Bombeiros (193).',
        ];
      case 'tempExtremes':
        return [
          'Beba água com frequência, mesmo sem sede.',
          'Evite sair ao sol entre 10h e 16h.',
          'Cuide de crianças, idosos e animais e procure atendimento em caso de tontura.',
        ];
      default:
        return [
          'Acompanhe as informações oficiais e siga as orientações das autoridades.',
        ];
    }
  }
}