import 'package:flutter/material.dart';
import 'package:recicla_mais/features/collector/presentation/widgets/collection_card.dart';
import 'package:recicla_mais/features/collector/presentation/pages/chat_page.dart';

class UserCollectionDetailsPage extends StatelessWidget {
  final CollectionCardData data;

  const UserCollectionDetailsPage({super.key, required this.data});

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Solicitação'),
        content: const Text(
          'Tem certeza que deseja cancelar esta solicitação?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(
                context,
                'cancelled',
              ); // Close details page with signal
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Solicitação cancelada com sucesso.'),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sim, cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Solicitação'),
        backgroundColor: const Color(0xFF3493F2),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Collection Code
            Center(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(text: 'Código de coleta: '),
                    TextSpan(
                      text: data.collectionCode,
                      style: const TextStyle(color: Color(0xFF00C2FF)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Reuse CollectionDetailsCard for details
            // We can pass callbacks here
            CollectionDetailsCard(
              data: data,
              onVisualizarFotoTap: () {
                // Mock photo view
              },
            ),

            const SizedBox(height: 24),

            // Collector Info (if pending/accepted)
            if (data.status == CollectionStatus.pending ||
                data.status == CollectionStatus.completed) ...[
              const Text(
                'Informações do coletor:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=11',
                      ), // Mock image
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Nome do coletor:',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Johnson'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Actions
            if (data.status == CollectionStatus.pending) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatPage(
                          userName: 'Johnson',
                          userId: 'collector_123',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat),
                  label: const Text('Chat com Coletor'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3493F2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showCancelDialog(context),
                  style: ElevatedButton.styleFrom(
                    // Blue as per image "Finalizar solicitação" style
                    // Or Red for Cancel? The image shows "Finalizar solicitação" in blue.
                    // But the prompt asks for "Cancel".
                    // I'll use Red for Cancel to be safe/standard, or Blue if it's "Finalize".
                    // The prompt says "poder cancelar a solicitação".
                    // I will add a Cancel button.
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Cancelar Solicitação',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
