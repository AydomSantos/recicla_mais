import 'package:flutter/material.dart';
import 'package:recicla_mais/features/collector/presentation/widgets/collection_card.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  // Mock pending requests
  final List<CollectionCardData> _pendingRequests = [
    const CollectionCardData(
      tempoColeta: '08:00 - 12:00',
      distanciaKm: '2.5km',
      nomeSolicitante: 'João Silva',
      endereco: 'Rua das Flores, 123, Centro, São Paulo',
      referencia: 'Próximo ao mercado',
      tipoMaterial: 'Plástico',
      pesoEstimado: '5kg',
      detalhesAdicionais: 'Garrafas PET',
      observacoes: 'Favor coletar pela manhã',
      status: CollectionStatus.pending,
      collectionCode: 'COL-001',
      bairro: 'Centro',
    ),
    const CollectionCardData(
      tempoColeta: '14:00 - 18:00',
      distanciaKm: '1.2km',
      nomeSolicitante: 'Maria Santos',
      endereco: 'Av. Principal, 456, Jardim, São Paulo',
      referencia: 'Edifício azul',
      tipoMaterial: 'Papel',
      pesoEstimado: '3kg',
      detalhesAdicionais: 'Caixas de papelão',
      observacoes: 'Portaria recebe',
      status: CollectionStatus.pending,
      collectionCode: 'COL-002',
      bairro: 'Jardim',
    ),
  ];

  void _showApproveDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aprovar Solicitação'),
        content: Text(
          'Deseja aprovar a solicitação ${_pendingRequests[index].collectionCode}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _pendingRequests.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Solicitação aprovada com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            child: const Text('Aprovar'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rejeitar Solicitação'),
        content: Text(
          'Deseja rejeitar a solicitação ${_pendingRequests[index].collectionCode}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _pendingRequests.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Solicitação rejeitada.'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Rejeitar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Administrativo'),
        backgroundColor: const Color(0xFF3493F2),
        foregroundColor: Colors.white,
      ),
      body: _pendingRequests.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma solicitação pendente',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _pendingRequests.length,
              itemBuilder: (context, index) {
                final request = _pendingRequests[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    children: [
                      CollectionDetailsCard(
                        data: request,
                        onVisualizarFotoTap: () {
                          // Mock photo view
                        },
                      ),
                      const SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // Se a largura for muito pequena, exibe os botões em coluna
                          if (constraints.maxWidth < 320) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _showApproveDialog(index),
                                  icon: const Icon(Icons.check),
                                  label: const Text('Aprovar'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  onPressed: () => _showRejectDialog(index),
                                  icon: const Icon(Icons.close),
                                  label: const Text('Rejeitar'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          // Caso contrário, exibe em linha
                          return Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _showApproveDialog(index),
                                  icon: const Icon(Icons.check),
                                  label: const Text('Aprovar'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _showRejectDialog(index),
                                  icon: const Icon(Icons.close),
                                  label: const Text('Rejeitar'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
