import 'package:flutter/material.dart';
import 'package:recicla_mais/features/collector/presentation/widgets/collection_card.dart';
import 'package:recicla_mais/features/collector/presentation/pages/collection_in_progress_page.dart';

class CollectionHistoryPage extends StatelessWidget {
  final List<CollectionCardData> coletas;
  final Function(CollectionCardData) onCancelarColeta;
  final Function(CollectionCardData) onFinalizarColeta;

  const CollectionHistoryPage({
    super.key,
    required this.coletas,
    required this.onCancelarColeta,
    required this.onFinalizarColeta,
  });

  @override
  Widget build(BuildContext context) {
    // Filtra as coletas por status
    final pendentes = coletas
        .where((c) => c.status == CollectionStatus.pending)
        .toList();
    final concluidas = coletas
        .where((c) => c.status == CollectionStatus.completed)
        .toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: const Text('Histórico de Coletas'),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Pendentes'),
              Tab(text: 'Concluídas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Aba Pendentes
            _buildList(pendentes, isPending: true),
            // Aba Concluídas
            _buildList(concluidas, isPending: false),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<CollectionCardData> lista, {required bool isPending}) {
    if (lista.isEmpty) {
      return Center(
        child: Text(
          isPending ? 'Nenhuma coleta pendente.' : 'Nenhuma coleta concluída.',
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (context, index) {
        final coleta = lista[index];
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: GestureDetector(
            onTap: isPending
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CollectionInProgressPage(
                          coleta: coleta,
                          onFinalizar: () {
                            Navigator.pop(context);
                            onFinalizarColeta(coleta);
                          },
                          onCancelar: () {
                            Navigator.pop(context);
                            onCancelarColeta(coleta);
                          },
                        ),
                      ),
                    );
                  }
                : null,
            child: CollectionDetailsCard(
              data: coleta,
              onVisualizarFotoTap: () {},
              // Se for pendente, passa as ações de cancelar e finalizar
              onCancelarColetaTap: isPending
                  ? () => onCancelarColeta(coleta)
                  : null,
              onFinalizarColetaTap: isPending
                  ? () => onFinalizarColeta(coleta)
                  : null,
            ),
          ),
        );
      },
    );
  }
}
