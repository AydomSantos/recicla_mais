import 'package:flutter/material.dart';
import 'package:recicla_mais/features/collector/presentation/widgets/collection_card.dart';
import 'package:recicla_mais/features/collector/presentation/pages/available_collections_page.dart';
import 'package:recicla_mais/features/collector/presentation/pages/collection_history_page.dart';
import 'package:recicla_mais/features/collector/presentation/pages/settings_page.dart';

class CollectorHomePage extends StatefulWidget {
  const CollectorHomePage({super.key});

  @override
  State<CollectorHomePage> createState() => _CollectorHomePageState();
}

class _CollectorHomePageState extends State<CollectorHomePage> {
  int _selectedIndex = 0;

  // As listas agora são gerenciadas aqui, no widget pai.
  late List<CollectionCardData> _coletasDisponiveis;
  final List<CollectionCardData> _coletasAceitas = [];

  // Dados mockados que serão a fonte inicial
  static final List<CollectionCardData> _coletasMock = [
    CollectionCardData(
      tempoColeta: 'Hoje, 13:10 - 15:10',
      distanciaKm: '2.5 km',
      nomeSolicitante: 'Aydom',
      endereco: 'R. Jardim Esperança, 123',
      referencia: 'Casa com portão verde',
      tipoMaterial: 'Plástico',
      pesoEstimado: '7kg',
      detalhesAdicionais: 'Garrafas PET e embalagens limpas.',
      observacoes: 'Favor trazer sacos resistentes.',
      collectionCode: '12345',
      bairro: 'Centro',
    ),
    CollectionCardData(
      tempoColeta: 'Hoje, 15:30 - 17:00',
      distanciaKm: '5.1 km',
      nomeSolicitante: 'Maria Silva',
      endereco: 'Av. Paulista, 1000',
      referencia: 'Apto 52, Bloco B',
      tipoMaterial: 'Papelão e Vidro',
      pesoEstimado: '12kg',
      detalhesAdicionais: 'Caixas de papelão desmontadas e garrafas de vidro.',
      observacoes: 'Cuidado com os cacos de vidro.',
      collectionCode: '67890',
      bairro: 'Brasília',
    ),
    CollectionCardData(
      tempoColeta: 'Amanhã, 08:00 - 10:00',
      distanciaKm: '1.2 km',
      nomeSolicitante: 'João Souza',
      endereco: 'Rua das Flores, 45',
      referencia: 'Próximo ao mercado',
      tipoMaterial: 'Eletrônicos',
      pesoEstimado: '3kg',
      detalhesAdicionais: 'Teclados, mouses e cabos antigos.',
      observacoes: 'Ligar antes de chegar.',
      collectionCode: '11223',
      bairro: 'Primavera',
    ),
    CollectionCardData(
      tempoColeta: 'Amanhã, 14:00 - 16:00',
      distanciaKm: '8.5 km',
      nomeSolicitante: 'Empresa Tech',
      endereco: 'Av. Industrial, 500',
      referencia: 'Galpão 3',
      tipoMaterial: 'Papel e Plástico',
      pesoEstimado: '50kg',
      detalhesAdicionais: 'Grande quantidade de material de escritório.',
      observacoes: 'Procurar por Carlos na portaria.',
      collectionCode: '44556',
      bairro: 'Senador Nilo Coelho',
    ),
    CollectionCardData(
      tempoColeta: 'Sexta, 09:00 - 11:00',
      distanciaKm: '3.0 km',
      nomeSolicitante: 'Ana Pereira',
      endereco: 'Rua da Paz, 200',
      referencia: 'Casa amarela',
      tipoMaterial: 'Metal',
      pesoEstimado: '15kg',
      detalhesAdicionais: 'Latas de alumínio e panelas velhas.',
      observacoes: 'Pode tocar a campainha.',
      collectionCode: '77889',
      bairro: 'Baixão',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _coletasDisponiveis = List.from(_coletasMock);
  }

  // Função que move a coleta de 'disponível' para 'aceita' (Pendente)
  void _aceitarColeta(CollectionCardData coleta) {
    setState(() {
      _coletasDisponiveis.remove(coleta);
      // Cria uma nova instância com status pendente
      final novaColeta = CollectionCardData(
        tempoColeta: coleta.tempoColeta,
        distanciaKm: coleta.distanciaKm,
        nomeSolicitante: coleta.nomeSolicitante,
        endereco: coleta.endereco,
        referencia: coleta.referencia,
        tipoMaterial: coleta.tipoMaterial,
        pesoEstimado: coleta.pesoEstimado,
        detalhesAdicionais: coleta.detalhesAdicionais,
        observacoes: coleta.observacoes,
        status: CollectionStatus.pending,
        collectionCode: coleta.collectionCode,
        bairro: coleta.bairro,
      );
      _coletasAceitas.add(novaColeta);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Coleta de ${coleta.nomeSolicitante} aceita!')),
    );
  }

  // Função que finaliza a coleta (Concluída)
  void _finalizarColeta(CollectionCardData coleta) {
    setState(() {
      final index = _coletasAceitas.indexOf(coleta);
      if (index != -1) {
        _coletasAceitas[index] = CollectionCardData(
          tempoColeta: coleta.tempoColeta,
          distanciaKm: coleta.distanciaKm,
          nomeSolicitante: coleta.nomeSolicitante,
          endereco: coleta.endereco,
          referencia: coleta.referencia,
          tipoMaterial: coleta.tipoMaterial,
          pesoEstimado: coleta.pesoEstimado,
          detalhesAdicionais: coleta.detalhesAdicionais,
          observacoes: coleta.observacoes,
          status: CollectionStatus.completed,
          collectionCode: coleta.collectionCode,
          bairro: coleta.bairro,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Coleta de ${coleta.nomeSolicitante} finalizada!'),
      ),
    );
  }

  // Função que move a coleta de 'aceita' de volta para 'disponível'
  void _cancelarColeta(CollectionCardData coleta) {
    setState(() {
      _coletasAceitas.remove(coleta);
      // Retorna para disponível
      final novaColeta = CollectionCardData(
        tempoColeta: coleta.tempoColeta,
        distanciaKm: coleta.distanciaKm,
        nomeSolicitante: coleta.nomeSolicitante,
        endereco: coleta.endereco,
        referencia: coleta.referencia,
        tipoMaterial: coleta.tipoMaterial,
        pesoEstimado: coleta.pesoEstimado,
        detalhesAdicionais: coleta.detalhesAdicionais,
        observacoes: coleta.observacoes,
        status: CollectionStatus.available,
        collectionCode: coleta.collectionCode,
        bairro: coleta.bairro,
      );
      _coletasDisponiveis.add(novaColeta);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Coleta de ${coleta.nomeSolicitante} cancelada.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lista de páginas que a barra de navegação irá controlar
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
