import 'package:flutter/material.dart';
import 'package:recicla_mais/components/card_colector.dart';

class HistoricoColetasPage extends StatelessWidget {
  final List<ColetaCardData> coletas;
  final Function(ColetaCardData) onCancelarColeta;

  const HistoricoColetasPage({
    super.key,
    required this.coletas,
    required this.onCancelarColeta,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Histórico de Coletas'),
        automaticallyImplyLeading: false, // Remove o botão de voltar
      ),
      body: coletas.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma coleta foi aceita ainda.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: coletas.length,
              itemBuilder: (context, index) {
                final coleta = coletas[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  // Reutilizamos o mesmo card, mas sem a função de 'aceitar'
                  child: DetalhesColetaCard(
                      data: coleta,
                      onVisualizarFotoTap: () {},
                      onCancelarColetaTap: () => onCancelarColeta(coleta)),
                );
              },
            ),
    );
  }
}