import 'package:flutter/material.dart';
import 'package:recicla_mais/features/collector/presentation/widgets/collection_card.dart';

class CollectionInProgressPage extends StatelessWidget {
  final CollectionCardData coleta;
  final VoidCallback onFinalizar;
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

            // Botão Visualizar Foto
            OutlinedButton(
              onPressed: () {
                // Ação para ver foto
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.lightBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Visualizar foto do lixo',
                style: TextStyle(fontSize: 16, color: Colors.lightBlue),
              ),
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
              onPressed: () {
                onFinalizar();
                Navigator.pop(context); // Volta para a lista
              },
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
              onPressed: () {
                onCancelar();
                Navigator.pop(context); // Volta para a lista
              },
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
