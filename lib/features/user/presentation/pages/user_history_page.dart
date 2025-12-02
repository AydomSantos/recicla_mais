import 'package:flutter/material.dart';
import 'package:recicla_mais/features/collector/presentation/widgets/collection_card.dart';
import 'user_collection_details_page.dart';

class UserHistoryPage extends StatelessWidget {
  const UserHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final List<CollectionCardData> history = [
      const CollectionCardData(
        tempoColeta: 'Hoje, 13:10 - 15:10',
        distanciaKm: '2.5km',
        nomeSolicitante: 'Thompson',
        endereco: 'Rua Marinete Francisca, Brasiliana, Arapiraca',
        referencia: 'Próximo ao mercado',
        tipoMaterial: 'Plástico',
        pesoEstimado: '5kg',
        detalhesAdicionais: 'Garrafas PET',
        observacoes: 'Ligar quando chegar',
        status: CollectionStatus.pending,
        collectionCode: '12345',
      ),
      const CollectionCardData(
        tempoColeta: 'Ontem, 10:00 - 12:00',
        distanciaKm: '1.0km',
        nomeSolicitante: 'Thompson',
        endereco: 'Rua Marinete Francisca, Brasiliana, Arapiraca',
        referencia: 'Próximo ao mercado',
        tipoMaterial: 'Papel',
        pesoEstimado: '2kg',
        detalhesAdicionais: 'Jornais e revistas',
        observacoes: '',
        status: CollectionStatus.completed,
        collectionCode: '67890',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Solicitações'),
        backgroundColor: const Color(0xFF3493F2),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final data = history[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserCollectionDetailsPage(data: data),
                  ),
                );
              },
              child: AbsorbPointer(
                // We want to handle the tap on the card ourselves to navigate to details
                // But CollectionDetailsCard might have buttons.
                // If we want the whole card to be clickable to go to details, we can wrap it.
                // However, CollectionDetailsCard has buttons.
                // Let's use a simplified view or just the card.
                // The user said "use the cards that are ready".
                // If I use AbsorbPointer, buttons inside won't work.
                // If I don't, buttons work.
                // Let's assume the user wants to see the card and click it to see details?
                // Or maybe the card itself IS the details view in the list?
                // The prompt says "quero a opção de ver os detalhes".
                // So clicking the card should go to details.
                child: CollectionDetailsCard(
                  data: data,
                  // Disable buttons in the list view if we want navigation on tap
                  // Or just pass null callbacks
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
