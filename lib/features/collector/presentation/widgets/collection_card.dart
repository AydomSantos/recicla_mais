import 'package:flutter/material.dart';

// Force rebuild

/// Define os possíveis status de uma solicitação de coleta.
enum CollectionStatus {
  /// A coleta está disponível para ser aceita por um coletor.
  available,

  /// A coleta foi aceita e está aguardando a finalização.
  pending,

  /// A coleta foi concluída com sucesso.
  completed,
}

/// Representa o modelo de dados para uma única solicitação de coleta.
///
/// Esta classe imutável contém todas as informações necessárias para exibir
/// e gerenciar uma coleta, desde os detalhes do solicitante até o status atual.
class CollectionCardData {
  /// O intervalo de tempo estimado para a realização da coleta.
  final String tempoColeta;

  /// A distância aproximada até o local da coleta.
  final String distanciaKm;

  /// O nome do usuário que solicitou a coleta.
  final String nomeSolicitante;

  /// O endereço completo para a coleta.
  final String endereco;

  /// Um ponto de referência para ajudar a localizar o endereço.
  final String referencia;

  /// A categoria do material a ser coletado (ex: Plástico, Vidro).
  final String tipoMaterial;

  /// O peso aproximado do material.
  final String pesoEstimado;

  /// Informações adicionais sobre o material.
  final String detalhesAdicionais;

  /// Observações gerais do solicitante para o coletor.
  final String observacoes;

  /// O status atual da coleta (disponível, pendente, concluída).
  final CollectionStatus status;

  /// Um código único para identificar a coleta.
  final String collectionCode;

  /// O bairro onde a coleta será realizada, usado para filtros.
  final String bairro;

  /// Cria uma instância de [CollectionCardData].
  const CollectionCardData({
    required this.tempoColeta,
    required this.distanciaKm,
    required this.nomeSolicitante,
    required this.endereco,
    required this.referencia,
    required this.tipoMaterial,
    required this.pesoEstimado,
    required this.detalhesAdicionais,
    required this.observacoes,
    this.status = CollectionStatus.available,
    this.collectionCode = '',
    this.bairro = '',
  });
}

/// Um widget de card reutilizável que exibe os detalhes de uma [CollectionCardData].
///
/// Este card é altamente configurável através de callbacks para diferentes ações,
/// como aceitar, cancelar, finalizar, visualizar foto ou iniciar um chat.
class CollectionDetailsCard extends StatelessWidget {
  /// Os dados da coleta a serem exibidos no card.
  final CollectionCardData data;

  /// Callback acionado ao tocar no botão "Visualizar foto do material".
  final VoidCallback? onVisualizarFotoTap;

  /// Callback acionado ao tocar no ícone de chat.
  final VoidCallback? onChatTap;

  /// Callback acionado ao tocar no botão "Aceitar Solicitação".
  final VoidCallback? onAceitarColetaTap;

  /// Callback acionado ao tocar no botão "Cancelar".
  final VoidCallback? onCancelarColetaTap;

  /// Callback acionado ao tocar no botão "Finalizar".
  final VoidCallback? onFinalizarColetaTap;

  /// Callback acionado ao tocar no ícone de "Deletar" (Lixeira).
  final VoidCallback? onDeleteTap;

  /// Cria uma instância de [CollectionDetailsCard].
  const CollectionDetailsCard({
    super.key,
    required this.data,
    this.onVisualizarFotoTap,
    this.onChatTap,
    this.onAceitarColetaTap,
    this.onCancelarColetaTap,
    this.onFinalizarColetaTap,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // --- Header Azul (Tempo de Coleta) ---
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            color: const Color(0xFF3493F2),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white, size: 20),
                const SizedBox(width: 8.0),
                Text(
                  'Tempo de coleta: ${data.tempoColeta}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                if (onDeleteTap != null)
                  GestureDetector(
                    onTap: onDeleteTap,
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
              ],
            ),
          ),

          // --- Corpo do Card ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Informações do Solicitante
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Informações do Solicitante',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (onChatTap != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF3493F2,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.chat_bubble_outline,
                              color: Color(0xFF3493F2),
                            ),
                            onPressed: onChatTap,
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                if (onVisualizarFotoTap != null)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // Mostra diálogo com a imagem
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppBar(
                                  title: const Text('Foto do Material'),
                                  automaticallyImplyLeading: false,
                                  actions: [
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      // Placeholder de imagem
                                      Container(
                                        width: double.infinity,
                                        height: 300,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey[400]!,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.image,
                                              size: 80,
                                              color: Colors.grey[400],
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Imagem do Material',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              data.tipoMaterial,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Peso estimado: ${data.pesoEstimado}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF00C2FF),
                        side: const BorderSide(color: Color(0xFF00C2FF)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      child: const Text(
                        'Visualizar foto do material',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                _buildDetailRow('Nome', data.nomeSolicitante),
                _buildDetailRow('Endereço', data.endereco),
                _buildDetailRow('Ponto de Referência', data.referencia),

                const SizedBox(height: 16),
                const Text(
                  'Detalhes do Material',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 8),
                _buildDetailRow('Tipo Material', data.tipoMaterial),
                _buildDetailRow('Peso Estimado', data.pesoEstimado),

                const SizedBox(height: 16),
                const Text(
                  'Observações',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 8),
                Text(
                  data.observacoes,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),

                const SizedBox(height: 24),

                // --- Botões de Ação ---
                if (data.status == CollectionStatus.available &&
                    onAceitarColetaTap != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onAceitarColetaTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3493F2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Aceitar Solicitação',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                else if (data.status == CollectionStatus.pending) ...[
                  Row(
                    children: [
                      if (onFinalizarColetaTap != null)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onFinalizarColetaTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'Finalizar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      if (onCancelarColetaTap != null)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: onCancelarColetaTap,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Cancelar'),
                          ),
                        ),
                    ],
                  ),
                ] else if (data.status == CollectionStatus.completed)
                  const Center(
                    child: Text(
                      'Coleta Concluída',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói uma linha de detalhe com um rótulo em negrito e um valor.
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14.0, color: Colors.black87),
          children: <TextSpan>[
            TextSpan(
              text: '$label : ',
              style: const TextStyle(fontWeight: FontWeight.w600), // Semi-bold
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
