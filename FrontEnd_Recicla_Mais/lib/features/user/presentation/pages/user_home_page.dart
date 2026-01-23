import 'package:flutter/material.dart';
import 'package:recicla_mais/features/collector/presentation/widgets/collection_card.dart';
import 'create_collection_page.dart';
import 'user_history_page.dart';
import 'user_collection_details_page.dart';
import 'user_notifications_page.dart';
import 'user_settings_page.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _selectedIndex = 0;
  final List<CollectionCardData> _activeRequests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey[300],
            backgroundImage: const AssetImage(
              'assets/imagens/logo.png',
            ), // Placeholder
          ),
        ),
        title: const Text(
          'Solicitações Aberta',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserNotificationsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Home Tab
          _activeRequests.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete_outline,
                        size: 100,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ops, nada por aqui',
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
                  itemCount: _activeRequests.length,
                  itemBuilder: (context, index) {
                    final request = _activeRequests[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserCollectionDetailsPage(data: request),
                            ),
                          );

                          if (result == 'cancelled') {
                            setState(() {
                              _activeRequests.removeAt(index);
                            });
                          }
                        },
                        child: CollectionDetailsCard(
                          data: request,
                          onDeleteTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Excluir Solicitação'),
                                content: const Text(
                                  'Tem certeza que deseja excluir esta solicitação?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Não'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        _activeRequests.removeAt(index);
                                      });
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Solicitação excluída com sucesso.',
                                          ),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('Sim, excluir'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
          // History Tab
          const UserHistoryPage(),
          // Info Tab (Placeholder)
          const Center(child: Text('Info')),
          // Settings Tab
          const UserSettingsPage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateCollectionPage(),
            ),
          );

          if (result != null && result is CollectionCardData) {
            setState(() {
              _activeRequests.add(result);
            });
          }
        },
        backgroundColor: Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.black, size: 32),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        indicatorColor: Colors.lightBlue[100],
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '',
          ),
          NavigationDestination(icon: Icon(Icons.history), label: ''),
          NavigationDestination(icon: Icon(Icons.info_outline), label: ''),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: ''),
        ],
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      ),
    );
  }
}
