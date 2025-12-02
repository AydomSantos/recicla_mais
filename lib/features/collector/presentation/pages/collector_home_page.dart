import 'package:flutter/material.dart';
import 'package:recicla_mais/features/collector/presentation/widgets/collection_card.dart';
import 'package:recicla_mais/features/collector/presentation/pages/available_collections_page.dart';
import 'package:recicla_mais/features/collector/presentation/pages/collection_history_page.dart';
import 'package:recicla_mais/features/collector/presentation/pages/settings_page.dart';

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
  late List<CollectionCardData> _coletasDisponiveis;

  /// A lista de coletas que foram aceitas por este coletor (status pendente ou concluído).
  final List<CollectionCardData> _coletasAceitas = [];

  /// Fonte de dados mockados para simular coletas disponíveis na inicialização.
  ///
  /// Em uma aplicação real, estes dados viriam de uma API ou banco de dados.
  static final List<CollectionCardData> _coletasMock = [
    
    
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
    CollectionCardData(
      tempoColeta: 'Hoje, 10:00 - 12:00',
      distanciaKm: '2.1 km',
      nomeSolicitante: 'Carlos Lima',
      endereco: 'Rua das Mangueiras, 150',
      referencia: 'Em frente à padaria Pão Quente',
      tipoMaterial: 'Vidro',
      pesoEstimado: '10kg',
      detalhesAdicionais: 'Garrafas de cerveja e potes de conserva.',
      observacoes: 'Material na calçada.',
      collectionCode: '54321',
      bairro: 'Centro',
    ),
    CollectionCardData(
      tempoColeta: 'Amanhã, 13:00 - 15:00',
      distanciaKm: '4.5 km',
      nomeSolicitante: 'Fernanda Oliveira',
      endereco: 'Av. dos Navegantes, 789',
      referencia: 'Prédio com sacada de vidro',
      tipoMaterial: 'Plástico (PET)',
      pesoEstimado: '5kg',
      detalhesAdicionais: 'Garrafas de refrigerante amassadas.',
      observacoes: 'Deixar na portaria com o Sr. José.',
      collectionCode: '98765',
      bairro: 'Gercino Coelho',
    ),
    CollectionCardData(
      tempoColeta: 'Hoje, 16:00 - 18:00',
      distanciaKm: '6.2 km',
      nomeSolicitante: 'Ricardo Almeida',
      endereco: 'Rua do Caju, 33',
      referencia: 'Casa de esquina com muro alto',
      tipoMaterial: 'Papelão',
      pesoEstimado: '20kg',
      detalhesAdicionais: 'Caixas de papelão de mudança.',
      observacoes: 'Material pesado, talvez precise de ajuda.',
      collectionCode: '13579',
      bairro: 'Areia Branca',
    ),
    CollectionCardData(
      tempoColeta: 'Sexta, 11:00 - 13:00',
      distanciaKm: '7.8 km',
      nomeSolicitante: 'Patrícia Costa',
      endereco: 'Travessa da Uva, 88',
      referencia: 'Ao lado da farmácia',
      tipoMaterial: 'Óleo de Cozinha',
      pesoEstimado: '5 litros',
      detalhesAdicionais: 'Óleo armazenado em garrafas PET.',
      observacoes: 'Cuidado para não vazar.',
      collectionCode: '24680',
      bairro: 'Dom Avelar',
    ),
    CollectionCardData(
      tempoColeta: 'Amanhã, 08:30 - 10:30',
      distanciaKm: '1.5 km',
      nomeSolicitante: 'Bruno Santos',
      endereco: 'Rua da Lapa, 1010',
      referencia: 'Apartamento 202',
      tipoMaterial: 'Pilhas e Baterias',
      pesoEstimado: '1kg',
      detalhesAdicionais: 'Pilhas AA, AAA e baterias de celular.',
      observacoes: 'Material em uma caixa de sapato.',
      collectionCode: '11235',
      bairro: 'Centro',
    ),
    CollectionCardData(
      tempoColeta: 'Hoje, 14:30 - 16:30',
      distanciaKm: '9.1 km',
      nomeSolicitante: 'Juliana Martins',
      endereco: 'Av. das Nações, 2050',
      referencia: 'Loja de roupas "Estilo"',
      tipoMaterial: 'Orgânico',
      pesoEstimado: '25kg',
      detalhesAdicionais: 'Restos de alimentos de restaurante.',
      observacoes: 'Retirar nos fundos.',
      collectionCode: '81321',
      bairro: 'João de Deus',
    ),
    CollectionCardData(
      tempoColeta: 'Sábado, 09:00 - 12:00',
      distanciaKm: '5.0 km',
      nomeSolicitante: 'Lucas Ferreira',
      endereco: 'Rua do Sol, 77',
      referencia: 'Portão azul',
      tipoMaterial: 'Misto',
      pesoEstimado: '12kg',
      detalhesAdicionais: 'Um pouco de tudo: papel, plástico e metal.',
      observacoes: 'Tudo separado em sacolas.',
      collectionCode: '34558',
      bairro: 'Gercino Coelho',
    ),
    CollectionCardData(
      tempoColeta: 'Amanhã, 15:00 - 17:00',
      distanciaKm: '10.2 km',
      nomeSolicitante: 'Mariana Rodrigues',
      endereco: 'Rua da Indústria, 900',
      referencia: 'Fábrica de calçados',
      tipoMaterial: 'Alumínio',
      pesoEstimado: '30kg',
      detalhesAdicionais: 'Restos de produção de alumínio.',
      observacoes: 'Falar com a gerente Lúcia.',
      collectionCode: '89144',
      bairro: 'Senador Nilo Coelho',
    ),
    CollectionCardData(
      tempoColeta: 'Hoje, 09:30 - 11:30',
      distanciaKm: '3.7 km',
      nomeSolicitante: 'Gustavo Pereira',
      endereco: 'Rua dos Artistas, 456',
      referencia: 'Próximo à escola de música',
      tipoMaterial: 'Ferro',
      pesoEstimado: '40kg',
      detalhesAdicionais: 'Peças de portão antigo e grades.',
      observacoes: 'Material muito pesado.',
      collectionCode: '23377',
      bairro: 'Areia Branca',
    ),
    CollectionCardData(
      tempoColeta: 'Sexta, 14:00 - 16:00',
      distanciaKm: '12.0 km',
      nomeSolicitante: 'Camila Gomes',
      endereco: 'Rua da Esperança, 1234',
      referencia: 'Condomínio "Vale Verde", Bloco C',
      tipoMaterial: 'Cobre',
      pesoEstimado: '8kg',
      detalhesAdicionais: 'Fios e cabos elétricos descascados.',
      observacoes: 'Autorizar entrada na portaria.',
      collectionCode: '61098',
      bairro: 'Cosme e Damião',
    ),
    CollectionCardData(
      tempoColeta: 'Amanhã, 10:00 - 12:00',
      distanciaKm: '2.8 km',
      nomeSolicitante: 'André Silva',
      endereco: 'Rua do Comércio, 300',
      referencia: 'Supermercado "Preço Bom"',
      tipoMaterial: 'Papelão',
      pesoEstimado: '100kg',
      detalhesAdicionais: 'Grande volume de caixas de mercadoria.',
      observacoes: 'Usar o acesso de cargas.',
      collectionCode: '75391',
      bairro: 'Centro',
    ),
    CollectionCardData(
      tempoColeta: 'Sábado, 10:00 - 11:00',
      distanciaKm: '8.8 km',
      nomeSolicitante: 'Beatriz Souza',
      endereco: 'Rua das Palmeiras, 50',
      referencia: 'Casa com jardim na frente',
      tipoMaterial: 'Vidro',
      pesoEstimado: '15kg',
      detalhesAdicionais: 'Garrafas de suco e potes de geleia.',
      observacoes: 'Material frágil, manusear com cuidado.',
      collectionCode: '95175',
      bairro: 'São Gonçalo',
    ),
    CollectionCardData(
      tempoColeta: 'Hoje, 15:30 - 17:30',
      distanciaKm: '4.2 km',
      nomeSolicitante: 'Rafael Azevedo',
      endereco: 'Av. Central, 1500',
      referencia: 'Oficina mecânica "Motor Forte"',
      tipoMaterial: 'Metal',
      pesoEstimado: '60kg',
      detalhesAdicionais: 'Sucata de peças de carro.',
      observacoes: 'Falar com o mecânico-chefe, Roberto.',
      collectionCode: '36985',
      bairro: 'Baixão',
    ),
    CollectionCardData(
      tempoColeta: 'Amanhã, 11:00 - 12:00',
      distanciaKm: '11.5 km',
      nomeSolicitante: 'Larissa Dias',
      endereco: 'Rua dos Pássaros, 99',
      referencia: 'Perto do parque ecológico',
      tipoMaterial: 'Plástico',
      pesoEstimado: '7kg',
      detalhesAdicionais: 'Embalagens diversas e brinquedos quebrados.',
      observacoes: 'Nenhuma.',
      collectionCode: '14725',
      bairro: 'Jatobá',
    ),
    CollectionCardData(
      tempoColeta: 'Sexta, 08:00 - 10:00',
      distanciaKm: '1.9 km',
      nomeSolicitante: 'Vinícius Rocha',
      endereco: 'Rua da Matriz, 10',
      referencia: 'Em frente à igreja',
      tipoMaterial: 'Eletrônicos',
      pesoEstimado: '2kg',
      detalhesAdicionais: 'Celular antigo e um rádio.',
      observacoes: 'Deixar na recepção da paróquia.',
      collectionCode: '85296',
      bairro: 'Centro',
    ),
    CollectionCardData(
      tempoColeta: 'Hoje, 13:30 - 15:30',
      distanciaKm: '6.7 km',
      nomeSolicitante: 'Gabriela Ribeiro',
      endereco: 'Rua da Horta, 44',
      referencia: 'Sítio "Recanto Feliz"',
      tipoMaterial: 'Orgânico',
      pesoEstimado: '18kg',
      detalhesAdicionais: 'Restos de poda de jardim e folhas secas.',
      observacoes: 'O acesso é por estrada de terra.',
      collectionCode: '36478',
      bairro: 'Loteamento Recife',
    ),
    CollectionCardData(
      tempoColeta: 'Amanhã, 16:00 - 18:00',
      distanciaKm: '5.3 km',
      nomeSolicitante: 'Matheus Barbosa',
      endereco: 'Av. das Américas, 777',
      referencia: 'Edifício "New York", apto 1504',
      tipoMaterial: 'Papel',
      pesoEstimado: '9kg',
      detalhesAdicionais: 'Revistas e jornais antigos.',
      observacoes: 'Interfonar para liberar a entrada.',
      collectionCode: '91827',
      bairro: 'Gercino Coelho',
    ),
    CollectionCardData(
      tempoColeta: 'Sábado, 11:00 - 13:00',
      distanciaKm: '13.2 km',
      nomeSolicitante: 'Amanda Nunes',
      endereco: 'Rua do Lago, 1',
      referencia: 'Clube de pesca',
      tipoMaterial: 'Misto',
      pesoEstimado: '22kg',
      detalhesAdicionais: 'Latas, garrafas PET e embalagens de comida.',
      observacoes: 'Material acumulado da limpeza do fim de semana.',
      collectionCode: '45612',
      bairro: 'Vila Eduardo',
    ),
    CollectionCardData(
      tempoColeta: 'Hoje, 11:00 - 13:00',
      distanciaKm: '2.5 km',
      nomeSolicitante: 'Felipe Castro',
      endereco: 'Rua Sete de Setembro, 580',
      referencia: 'Escritório de advocacia, 3º andar',
      tipoMaterial: 'Papel',
      pesoEstimado: '35kg',
      detalhesAdicionais: 'Documentos antigos para descarte.',
      observacoes: 'Material triturado em sacos.',
      collectionCode: '78932',
      bairro: 'Centro',
    ),
    CollectionCardData(
      tempoColeta: 'Amanhã, 09:00 - 11:00',
      distanciaKm: '7.1 km',
      nomeSolicitante: 'Letícia Monteiro',
      endereco: 'Rua das Orquídeas, 23',
      referencia: 'Floricultura "Bela Flor"',
      tipoMaterial: 'Orgânico',
      pesoEstimado: '14kg',
      detalhesAdicionais: 'Folhas, galhos e flores descartadas.',
      observacoes: 'Falar com a dona Letícia.',
      collectionCode: '19283',
      bairro: 'São Gonçalo',
    ),
  ];

  
  @override
  void initState() {
    super.initState();
    _coletasDisponiveis = List.from(_coletasMock);
  }

  /// Move uma coleta da lista de disponíveis para a lista de aceitas.
  ///
  /// Altera o status da [coleta] para `CollectionStatus.pending` e a adiciona
  /// à lista `_coletasAceitas`, removendo-a de `_coletasDisponiveis`.
  void _aceitarColeta(CollectionCardData coleta) {
    setState(() {
      _coletasDisponiveis.remove(coleta);
      // Cria uma nova instância com o status atualizado para pendente.
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

  /// Atualiza o status de uma coleta aceita para concluída.
  ///
  /// Encontra a [coleta] na lista `_coletasAceitas` e atualiza seu status
  /// para `CollectionStatus.completed`.
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

  /// Move uma coleta da lista de aceitas de volta para a lista de disponíveis.
  ///
  /// Altera o status da [coleta] para `CollectionStatus.available` e a move
  /// da lista `_coletasAceitas` para `_coletasDisponiveis`.
  void _cancelarColeta(CollectionCardData coleta) {
    setState(() {
      _coletasAceitas.remove(coleta);
      // Cria uma nova instância com o status atualizado para disponível.
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
