class CollectionModel {
  final String collectionCode;
  final String tempoColeta;
  final String distanciaKm;
  final String nomeSolicitante;
  final String endereco;
  final String referencia;
  final String tipoMaterial;
  final String pesoEstimado;
  final String detalhesAdicionais;
  final String observacoes;
  final String bairro;
  final String status;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;

  CollectionModel({
    required this.collectionCode,
    required this.tempoColeta,
    required this.distanciaKm,
    required this.nomeSolicitante,
    required this.endereco,
    required this.referencia,
    required this.tipoMaterial,
    required this.pesoEstimado,
    required this.detalhesAdicionais,
    required this.observacoes,
    required this.bairro,
    required this.status,
    this.imageUrl,
    this.latitude,
    this.longitude,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
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
      status: json['status'] ?? 'available',
      imageUrl: json['imageUrl'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collectionCode': collectionCode,
      'tempoColeta': tempoColeta,
      'distanciaKm': distanciaKm,
      'nomeSolicitante': nomeSolicitante,
      'endereco': endereco,
      'referencia': referencia,
      'tipoMaterial': tipoMaterial,
      'pesoEstimado': pesoEstimado,
      'detalhesAdicionais': detalhesAdicionais,
      'observacoes': observacoes,
      'bairro': bairro,
      'status': status,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
