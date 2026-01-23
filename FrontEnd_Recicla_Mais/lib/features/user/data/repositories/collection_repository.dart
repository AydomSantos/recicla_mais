import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recicla_mais/shared/api_constants.dart';

class UserCollectionRepository {
  static Future<void> createCollection(
    Map<String, dynamic> collectionData,
  ) async {
    final uri = Uri.parse(ApiConstants.collectionsEndpoint);

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(collectionData),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao criar solicitação: ${response.statusCode}');
    }
  }
}
