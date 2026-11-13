import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/alerta.dart';

class PreferenciasService {
  static const String _chaveNaoMostrarIntroducao = 'nao_mostrar_introducao';
  static const String _chaveFavoritos = 'favoritos';

  Future<bool> naoMostrarIntroducao() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_chaveNaoMostrarIntroducao) ?? false;
  }

  Future<void> salvarNaoMostrarIntroducao(bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_chaveNaoMostrarIntroducao, valor);
  }

  Future<List<Alerta>> obterFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList(_chaveFavoritos) ?? [];
    return lista
        .map((item) => Alerta.fromMap(jsonDecode(item) as Map<String, dynamic>))
        .toList();
  }

  Future<bool> ehFavorito(String id) async {
    final favoritos = await obterFavoritos();
    return favoritos.any((alerta) => alerta.id == id);
  }

  Future<void> alternarFavorito(Alerta alerta) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritos = await obterFavoritos();
    final existe = favoritos.any((item) => item.id == alerta.id);

    if (existe) {
      favoritos.removeWhere((item) => item.id == alerta.id);
    } else {
      favoritos.add(alerta);
    }

    await prefs.setStringList(
      _chaveFavoritos,
      favoritos.map((item) => jsonEncode(item.toMap())).toList(),
    );
  }
}