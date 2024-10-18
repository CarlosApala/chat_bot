import 'dart:convert';

import 'package:http/http.dart' as http;

class SerialCodeDataSource {
  final String apiUrl = 'https://your-api-url.com/validate-code';

  bool _isValidUUIDv4(String uuid) {
    final regex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    return regex.hasMatch(uuid);
  }

  Future<bool> validateCode(String serialCode) async {
    if (!_isValidUUIDv4(serialCode)) {
      print("El código serial no es un UUIDv4 válido.");
      return false; // O lanza una excepción si prefieres
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode(
          {'serialCode': serialCode}), // Asegúrate de enviar en formato JSON
      headers: {
        'Content-Type': 'application/json'
      }, // Asegúrate de incluir el encabezado adecuado
    );

    return response.statusCode == 200;
  }
}
