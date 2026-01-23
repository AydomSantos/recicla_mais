import 'package:flutter/material.dart';
import 'package:recicla_mais/features/collector/presentation/widgets/collection_card.dart';
import 'package:recicla_mais/features/collector/presentation/pages/available_collections_page.dart';
import 'package:recicla_mais/features/collector/presentation/pages/collection_history_page.dart';
import 'package:recicla_mais/features/collector/presentation/pages/settings_page.dart';
import 'package:recicla_mais/features/collector/data/repositories/collection_repository.dart';

/// A página principal para o coletor, que gerencia a navegação entre as
/// telas de coletas disponíveis, histórico e configurações.
class CollectorHomePage extends StatefulWidget {
  const CollectorHomePage({super.key});

  @override
  State<CollectorHomePage> createState() => _CollectorHomePageState();
}

/// Gerencia o estado da `CollectorHomePage`, incluindo o índice da aba selecionada
/// e as listas de coletas. Este widget atua como o "dono" do estado das coletas,
/// passando os dados e callbacks para os widgets filhos.
class _CollectorHomePageState extends State<CollectorHomePage> {
  /// O índice da aba atualmente selecionada na `BottomNavigationBar`.
  int _selectedIndex = 0;

  /// A lista de coletas que ainda não foram aceitas por nenhum coletor.
  List<CollectionCardData> _coletasDisponiveis = [];

  /// A lista de coletas que foram aceitas por este coletor (status pendente ou concluído).
  List<CollectionCardData> _coletasAceitas = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Carrega os dados do backend
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // Busca coletas aprovadas pelo admin
      final disponiveis = await CollectionRepository.getCollections(
        status: 'approved',
      );

      // Busca coletas pendentes e concluídas para o histórico
      final pendentes = await CollectionRepository.getCollections(
        status: 'pending',
      );
      final concluidas = await CollectionRepository.getCollections(
        status: 'completed',
      );

      setState(() {
        _coletasDisponiveis = disponiveis;
        _coletasAceitas = [...pendentes, ...concluidas];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao carregar dados: $e')));
      }
    }
  }

  /// Move uma coleta da lista de disponíveis para a lista de aceitas.
  ///
  /// Altera o status da [coleta] para `CollectionStatus.pending` e a adiciona
  /// à lista `_coletasAceitas`, removendo-a de `_coletasDisponiveis`.
  Future<void> _aceitarColeta(CollectionCardData coleta) async {
    try {
      await CollectionRepository.acceptCollection(coleta.collectionCode);
      await _loadData(); // Recarrega as listas
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Coleta de ${coleta.nomeSolicitante} aceita!'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao aceitar: $e')));
      }
    }
  }

  /// Atualiza o status de uma coleta aceita para concluída.
  Future<void> _finalizarColeta(CollectionCardData coleta) async {
    try {
      await CollectionRepository.finalizeCollection(coleta.collectionCode);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Coleta de ${coleta.nomeSolicitante} finalizada!'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao finalizar: $e')));
      }
    }
  }

  /// Move uma coleta da lista de aceitas de volta para a lista de disponíveis.
  Future<void> _cancelarColeta(CollectionCardData coleta) async {
    try {
      await CollectionRepository.cancelCollection(coleta.collectionCode);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Coleta de ${coleta.nomeSolicitante} cancelada.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao cancelar: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    /// Lista de widgets que correspondem a cada item da `BottomNavigationBar`.
    final List<Widget> pages = [
      AvailableCollectionsPage(
        coletas: _coletasDisponiveis,
        onAceitarColeta: _aceitarColeta,
      ),
      CollectionHistoryPage(
        coletas: _coletasAceitas,
        onCancelarColeta: _cancelarColeta,
        onFinalizarColeta: _finalizarColeta,
      ),
      const SettingsPage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Disponíveis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}
