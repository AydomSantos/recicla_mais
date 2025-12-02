import 'package:flutter/material.dart';
import 'package:recicla_mais/features/collector/presentation/widgets/collection_card.dart';
import 'package:recicla_mais/features/collector/presentation/pages/chat_page.dart';

/// Uma página que exibe os detalhes de uma coleta que está em andamento.
///
/// Fornece ao coletor as informações necessárias para realizar a coleta,
/// um placeholder para o mapa, e ações como iniciar um chat, visualizar a foto
/// do material, finalizar ou cancelar a coleta.
class CollectionInProgressPage extends StatelessWidget {
  /// Os dados da coleta em andamento.
  final CollectionCardData coleta;
  /// Callback acionado quando o coletor toca no botão "Finalizar coleta".
  final VoidCallback onFinalizar;
  /// Callback acionado quando o coletor toca no botão "Cancelar coleta".
  final VoidCallback onCancelar;

  const CollectionInProgressPage({
    super.key,
    required this.coleta,
    required this.onFinalizar,
    required this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Coleta em andamento!'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Coleta ativa até...
            Center(
              child: Text(
                'Coleta ativa até ${coleta.tempoColeta.split('-').last.trim()}', // Pega o horário final
                style: const TextStyle(fontSize: 22, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 24),

            // Informações
            _buildInfoRow('Nome', coleta.nomeSolicitante),
            const SizedBox(height: 8),
            _buildInfoRow('Endereço', coleta.endereco),
            const SizedBox(height: 8),
            _buildInfoRow(
              'Código de coleta',
              coleta.collectionCode,
              isBlue: true,
            ),

            const SizedBox(height: 24),

            // Botões de Ação (Foto e Chat)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            userName: coleta.nomeSolicitante,
                            userId: 'user_id_placeholder',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.chat_bubble_outline,
                      color: Color(0xFF3493F2),
                    ),
                    label: const Text(
                      'Chat',
                      style: TextStyle(fontSize: 16, color: Color(0xFF3493F2)),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF3493F2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
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
                                    Container(
                                      width: double.infinity,
                                      height: 300,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
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
                                            coleta.tipoMaterial,
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
                                      'Peso estimado: ${coleta.pesoEstimado}',
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
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.lightBlue,
                    ),
                    label: const Text(
                      'Ver Foto',
                      style: TextStyle(fontSize: 16, color: Colors.lightBlue),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.lightBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Placeholder do Mapa
            Container(
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.lightBlue),
                color: Colors.grey[200],
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 50, color: Colors.grey),
                    Text('Mapa aqui'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Botão Finalizar
            ElevatedButton(
              onPressed: onFinalizar,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3493F2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Finalizar coleta',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Botão Cancelar
            ElevatedButton(
              onPressed: onCancelar,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F), // Vermelho
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Cancelar coleta',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói uma linha de informação com um rótulo e um valor.
  Widget _buildInfoRow(String label, String value, {bool isBlue = false}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 18, color: Colors.grey),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: isBlue ? Colors.lightBlue : Colors.grey[700],
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
