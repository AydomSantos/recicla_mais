import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recicla_mais/features/collector/presentation/widgets/collection_card.dart';

class ApiService {
  // Endereço do backend local.
  // Se estiver rodando no emulador Android, use 'http://10.0.2.2:8000'
  // Se estiver no Windows, use 'http://127.0.0.1:8000'
  static const String baseUrl = 'http://127.0.0.1:8000'; 

  static Future<List<CollectionCardData>> getCollections({String? status}) async {
    final uri = Uri.parse('$baseUrl/collections').replace(queryParameters: status != null ? {'status': status} : null);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => _fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar coletas: ${response.statusCode}');
    }
  }

  static Future<CollectionCardData> acceptCollection(String code) async {
    final response = await http.patch(Uri.parse('$baseUrl/collections/$code/accept'));
    if (response.statusCode == 200) {
      return _fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Falha ao aceitar coleta');
    }
  }

  static Future<CollectionCardData> finalizeCollection(String code) async {
    final response = await http.patch(Uri.parse('$baseUrl/collections/$code/finalize'));
    if (response.statusCode == 200) {
      return _fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Falha ao finalizar coleta');
    }
  }

  static Future<CollectionCardData> cancelCollection(String code) async {
    final response = await http.patch(Uri.parse('$baseUrl/collections/$code/cancel'));
    if (response.statusCode == 200) {
      return _fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Falha ao cancelar coleta');
    }
  }

  // Método auxiliar para converter JSON em objeto Dart
  static CollectionCardData _fromJson(Map<String, dynamic> json) {
    return CollectionCardData(
      collectionCode: json['collectionCode'] ?? '',
      tempoColeta: json['tempoColeta'] ?? '',
      distanciaKm: json['distanciaKm'] ?? '',
      nomeSolicitante: json['nomeSolicitante'] ?? '',
      endereco: json['endereco'] ?? '',
      referencia: json['referencia'] ?? '',
      tipoMaterial: json['tipoMaterial'] ?? '',
      pesoEstimado: json['pesoEstimado'] ?? '',
      detalhesAdicionais: json['detalhesAdicionais'] ?? '',
      observacoes: json['observacoes'] ?? '',
      bairro: json['bairro'] ?? '',
      status: _mapStatus(json['status']),
    );
  }

  static CollectionStatus _mapStatus(String? status) {
    switch (status) {
      case 'pending':
        return CollectionStatus.pending;
      case 'completed':
        return CollectionStatus.completed;
      case 'approved':
        return CollectionStatus.approved; 
      case 'rejected':
        return CollectionStatus.rejected;
      case 'available':
      default:
        return CollectionStatus.available;
    }
  }
}