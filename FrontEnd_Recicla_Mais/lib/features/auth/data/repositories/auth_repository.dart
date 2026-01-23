import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recicla_mais/shared/api_constants.dart';

class AuthRepository {
  static Future<Map<String, dynamic>> login(String email, String senha) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/users/login');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else if (response.statusCode == 401) {
      throw Exception('Credenciais inválidas');
    } else {
      throw Exception('Erro ao fazer login: ${response.statusCode}');
    }
  }
}
