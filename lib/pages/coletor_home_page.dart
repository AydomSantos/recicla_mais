import 'package:flutter/material.dart';
import 'package:recicla_mais/components/card_colector.dart';
import 'package:recicla_mais/pages/coletas_disponiveis_page.dart';
import 'package:recicla_mais/pages/historico_coletas.dart';

class ColetorHomePage extends StatefulWidget {
  const ColetorHomePage({super.key});

  @override
  State<ColetorHomePage> createState() => _ColetorHomePageState();
}

class _ColetorHomePageState extends State<ColetorHomePage> {
  int _selectedIndex = 0;

  // As listas agora são gerenciadas aqui, no widget pai.
  late List<ColetaCardData> _coletasDisponiveis;
  final List<ColetaCardData> _coletasAceitas = [];

  // Dados mockados que serão a fonte inicial
  static final List<ColetaCardData> _coletasMock = [
    ColetaCardData(
      tempoColeta: 'Hoje, 13:10 - 15:10',
      distanciaKm: '2.5 km',
      nomeSolicitante: 'Aydom',
      endereco: 'R. Jardim Esperança, 123',
      referencia: 'Casa com portão verde',
      tipoMaterial: 'Plástico',
      pesoEstimado: '7kg',
      detalhesAdicionais: 'Garrafas PET e embalagens limpas.',
      observacoes: 'Favor trazer sacos resistentes.',
    ),
    ColetaCardData(
      tempoColeta: 'Hoje, 15:30 - 17:00',
      distanciaKm: '5.1 km',
      nomeSolicitante: 'Maria Silva',
      endereco: 'Av. Paulista, 1000',
      referencia: 'Apto 52, Bloco B',
      tipoMaterial: 'Papelão e Vidro',
      pesoEstimado: '12kg',
      detalhesAdicionais: 'Caixas de papelão desmontadas e garrafas de vidro.',
      observacoes: 'Cuidado com os cacos de vidro.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _coletasDisponiveis = List.from(_coletasMock);
  }

  // Função que move a coleta de 'disponível' para 'aceita'
  void _aceitarColeta(ColetaCardData coleta) {
    setState(() {
      _coletasDisponiveis.remove(coleta);
      _coletasAceitas.add(coleta);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Coleta de ${coleta.nomeSolicitante} aceita!')),
    );
  }

  // Função que move a coleta de 'aceita' de volta para 'disponível'
  void _cancelarColeta(ColetaCardData coleta) {
    setState(() {
      _coletasAceitas.remove(coleta);
      _coletasDisponiveis.add(coleta);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Coleta de ${coleta.nomeSolicitante} cancelada.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lista de páginas que a barra de navegação irá controlar
    final List<Widget> pages = [
      ColetasDisponiveisPage(
        coletas: _coletasDisponiveis,
        onAceitarColeta: _aceitarColeta,
      ),
      HistoricoColetasPage(
        coletas: _coletasAceitas,
        onCancelarColeta: _cancelarColeta,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Disponíveis'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Histórico'),
        ],
      ),
    );
  }
}