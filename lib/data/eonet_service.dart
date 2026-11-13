import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/alerta.dart';
import 'localizacao_service.dart';

class EonetService {
  static const String _baseUrl = 'https://eonet.gsfc.nasa.gov/api/v3/events';
  static const String _americaDoSul = '-82,13,-34,-56';
  static const List<String> _categorias = [
    'wildfires',
    'floods',
    'landslides',
    'tempExtremes',
  ];

  final LocalizacaoService _localizacaoService = LocalizacaoService();

  Future<List<Alerta>> buscarAlertas() async {
    final resultados = await Future.wait(
      _categorias.map((categoria) => _buscarPorCategoria(categoria)),
    );
    final alertas = resultados.expand((lista) => lista).toList();
    alertas.sort((a, b) => b.data.compareTo(a.data));
    return alertas;
  }

  Future<List<Alerta>> _buscarPorCategoria(String categoria) async {
    final uri = Uri.parse(
      '$_baseUrl?category=$categoria&bbox=$_americaDoSul'
      '&status=all&days=90&limit=5',
    );
    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json'},
    ).timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception(
        'Não foi possível carregar os eventos de satélite. '
        'Código HTTP: ${response.statusCode}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final eventos = json['events'] as List<dynamic>? ?? [];
    final alertas = eventos
        .map((evento) => Alerta.fromJson(evento as Map<String, dynamic>))
        .toList();

    return Future.wait(alertas.map((alerta) => _comLocalizacao(alerta)));
  }

  Future<Alerta> _comLocalizacao(Alerta alerta) async {
    final latitude = alerta.latitude;
    final longitude = alerta.longitude;
    if (latitude == null || longitude == null) {
      return alerta;
    }
    final local = await _localizacaoService.buscarLocal(latitude, longitude);
    if (local == null) {
      return alerta;
    }
    return alerta.comTitulo('${alerta.tipo} em $local');
  }
}