import 'dart:async';

import '../model/alerta.dart';
import 'eonet_service.dart';
import 'previsao_service.dart';

class AlertasService {
  final PrevisaoService _previsaoService = PrevisaoService();
  final EonetService _eonetService = EonetService();

  Future<List<Alerta>> buscarAlertas() async {
    final satelitesFuturo = _buscarSatelites();
    final previsoes = await _buscarPrevisoes();
    final satelites = await satelitesFuturo;

    previsoes.sort((a, b) {
      final porNivel = b.nivel.compareTo(a.nivel);
      if (porNivel != 0) {
        return porNivel;
      }
      return a.titulo.compareTo(b.titulo);
    });

    return [...previsoes, ...satelites];
  }

  Future<List<Alerta>> _buscarPrevisoes() async {
    try {
      return await _previsaoService.buscarAlertas();
    } on TimeoutException {
      throw Exception('A consulta demorou demais. Tente novamente.');
    } catch (erro) {
      if (erro.toString().startsWith('Exception: ')) {
        rethrow;
      }
      throw Exception(
        'Falha de conexão. Verifique sua internet e tente novamente.',
      );
    }
  }

  Future<List<Alerta>> _buscarSatelites() async {
    try {
      return await _eonetService.buscarAlertas();
    } catch (_) {
      return [];
    }
  }
}