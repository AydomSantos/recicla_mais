import 'package:flutter/material.dart';
import 'package:recicla_mais/features/collector/presentation/widgets/collection_card.dart';
import 'package:recicla_mais/features/collector/presentation/pages/notifications_page.dart';

/// Uma página que exibe uma lista de coletas disponíveis para o coletor.
///
/// Permite que o usuário filtre as coletas por bairro, busque por nome do solicitante
/// e aceite uma coleta disponível.
class AvailableCollectionsPage extends StatefulWidget {
  /// A lista de coletas disponíveis a serem exibidas.
  final List<CollectionCardData> coletas;
  /// Callback acionado quando o coletor aceita uma coleta.
  final Function(CollectionCardData) onAceitarColeta;

  /// Cria uma instância de [AvailableCollectionsPage].
  const AvailableCollectionsPage({
    super.key,
    required this.coletas,
    required this.onAceitarColeta,
  });

  @override
  State<AvailableCollectionsPage> createState() =>
      _AvailableCollectionsPageState();
}

/// Gerencia o estado da página, incluindo a lógica de busca e filtro.
class _AvailableCollectionsPageState extends State<AvailableCollectionsPage> {
  /// O bairro atualmente selecionado para o filtro. Nulo se nenhum filtro de bairro estiver ativo.
  String? _bairroSelecionado;
  /// O termo de busca atual inserido pelo usuário no campo de texto.
  String _searchQuery = '';

  /// Retorna a lista de coletas após aplicar os filtros de bairro e busca.
  List<CollectionCardData> get _coletasFiltradas {
    return widget.coletas.where((coleta) {
      final matchBairro =
          _bairroSelecionado == null ||
          _bairroSelecionado == 'Todos' ||
          coleta.bairro == _bairroSelecionado;
      final matchSearch =
          _searchQuery.isEmpty ||
          coleta.nomeSolicitante.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      return matchBairro && matchSearch;
    }).toList();
  }

  /// Exibe um diálogo que permite ao usuário filtrar as coletas por bairro.
  void _showFilterDialog() {
    // Lista de bairros únicos
    final bairros = [
      'Todos',
      ...widget.coletas
          .map((c) => c.bairro)
          .where((b) => b.isNotEmpty)
          .toSet()
          .toList()
        ..sort(),
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrar por Bairro'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: bairros.length,
            itemBuilder: (context, index) {
              final bairro = bairros[index];
              return ListTile(
                title: Text(bairro),
                leading: Checkbox(
                  value: _bairroSelecionado == bairro || (_bairroSelecionado == null && bairro == 'Todos'),
                  onChanged: (value) {
                    setState(() {
                      _bairroSelecionado = bairro == 'Todos' ? null : bairro;
                    });
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  setState(() {
                    _bairroSelecionado = bairro == 'Todos' ? null : bairro;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitações de Coletas'),
        backgroundColor: const Color(
          0xFF3493F2,
        ), // Azul mais claro como na imagem
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de Busca e Filtro
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Busca por nome',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _showFilterDialog,
                  icon: const Icon(Icons.filter_list, size: 18),
                  label: Text(_bairroSelecionado ?? 'Filtro'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3493F2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Lista de Coletas
          Expanded(
            child: _coletasFiltradas.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma coleta encontrada.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _coletasFiltradas.length,
                    itemBuilder: (context, index) {
                      final coleta = _coletasFiltradas[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: CollectionDetailsCard(
                          data: coleta,
                          onVisualizarFotoTap: () {},
                          onAceitarColetaTap: () =>
                              widget.onAceitarColeta(coleta),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
