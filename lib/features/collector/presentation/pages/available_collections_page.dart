import 'package:flutter/material.dart';
import 'package:recicla_mais/features/collector/presentation/widgets/collection_card.dart';

class AvailableCollectionsPage extends StatelessWidget {
  final List<CollectionCardData> coletas;
  final Function(CollectionCardData) onAceitarColeta;

  const AvailableCollectionsPage({
    super.key,
    required this.coletas,
    required this.onAceitarColeta,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coletas Disponíveis'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // Remove o botão de voltar
      ),
      body: coletas.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma coleta disponível no momento.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: coletas.length,
              itemBuilder: (context, index) {
                final coleta = coletas[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: CollectionDetailsCard(
                    data: coleta,
                    onVisualizarFotoTap: () {},
                    onAceitarColetaTap: () => onAceitarColeta(coleta),
                  ),
                );
              },
            ),
    );
  }
}
