import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recicla_mais/shared/api_constants.dart';
import 'package:recicla_mais/features/collector/domain/models/collection_model.dart';
import 'package:recicla_mais/features/collector/presentation/widgets/collection_card.dart';

class CollectionRepository {
  static Future<List<CollectionCardData>> getCollections({
    String? status,
  }) async {
    final uri = Uri.parse(
      ApiConstants.collectionsEndpoint,
    ).replace(queryParameters: status != null ? {'status': status} : null);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body
            .map(
              (dynamic item) =>
                  _mapModelToCardData(CollectionModel.fromJson(item)),
            )
            .toList();
      } else {
        throw Exception('Failed to load collections: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching collections: $e');
    }
  }

  static Future<void> acceptCollection(String code) async {
    final uri = Uri.parse('${ApiConstants.collectionsEndpoint}/$code/accept');
    final response = await http.patch(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to accept collection');
    }
  }

  static Future<void> finalizeCollection(String code) async {
    final uri = Uri.parse('${ApiConstants.collectionsEndpoint}/$code/finalize');
    final response = await http.patch(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to finalize collection');
    }
  }

  static Future<void> cancelCollection(String code) async {
    final uri = Uri.parse('${ApiConstants.collectionsEndpoint}/$code/cancel');
    final response = await http.patch(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel collection');
    }
  }

  // Helper to map Domain Model to Presentation Data
  static CollectionCardData _mapModelToCardData(CollectionModel model) {
    return CollectionCardData(
      collectionCode: model.collectionCode,
      tempoColeta: model.tempoColeta,
      distanciaKm: model.distanciaKm,
      nomeSolicitante: model.nomeSolicitante,
      endereco: model.endereco,
      referencia: model.referencia,
      tipoMaterial: model.tipoMaterial,
      pesoEstimado: model.pesoEstimado,
      detalhesAdicionais: model.detalhesAdicionais,
      observacoes: model.observacoes,
      bairro: model.bairro,
      status: _mapStatus(model.status),
    );
  }

  static CollectionStatus _mapStatus(String status) {
    switch (status) {
      case 'available':
        return CollectionStatus.available;
      case 'pending':
        return CollectionStatus.pending;
      case 'completed':
        return CollectionStatus.completed;
      case 'approved':
        return CollectionStatus.approved;
      case 'rejected':
        return CollectionStatus.rejected;
      default:
        return CollectionStatus.available;
    }
  }
}
