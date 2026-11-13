import 'dart:convert';

import 'package:http/http.dart' as http;

class LocalizacaoService {
  static const String _baseUrl =
      'https://api.bigdatacloud.net/data/reverse-geocode-client';

  Future<String?> buscarLocal(double latitude, double longitude) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl?latitude=$latitude&longitude=$longitude&localityLanguage=pt',
      );
      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        return null;
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final cidade = (json['city'] ?? json['locality'] ?? '') as String;
      final estado = (json['principalSubdivision'] ?? '') as String;
      final pais = (json['countryName'] ?? '') as String;

      final partes = [cidade, estado, pais]
          .where((parte) => parte.isNotEmpty)
          .toSet()
          .toList();
      if (partes.isEmpty) {
        return null;
      }
      return partes.join(', ');
    } catch (_) {
      return null;
    }
  }
}