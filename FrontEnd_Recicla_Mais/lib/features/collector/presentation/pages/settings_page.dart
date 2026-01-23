import 'package:flutter/material.dart';
import 'package:recicla_mais/features/auth/presentation/pages/login_page.dart';
import 'package:recicla_mais/features/collector/presentation/pages/account_settings_page.dart';
import 'package:recicla_mais/features/collector/presentation/pages/notification_settings_page.dart';
import 'package:recicla_mais/features/collector/presentation/pages/accessibility_settings_page.dart';
import 'package:recicla_mais/features/collector/presentation/pages/permissions_settings_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Configurações',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          // Profile Section
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[400],
                  child: const Icon(
                    Icons.person,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Johnson Silvério Ferreira',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00BCD4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Coletor',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Settings Options
          _buildSettingItem(
            context,
            icon: Icons.person_outline,
            title: 'Conta',
            subtitle: 'Editar perfil, alterar endereço',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountSettingsPage(),
                ),
              );
            },
          ),
          _buildSettingItem(
            context,
            icon: Icons.notifications_outlined,
            title: 'Notificações',
            subtitle: 'Preferências de coleta, sons',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationSettingsPage(),
                ),
              );
            },
          ),
          _buildSettingItem(
            context,
            icon: Icons.accessibility_new,
            title: 'Acessibilidade',
            subtitle: 'Tamanho da fonte, contraste, animações',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccessibilitySettingsPage(),
                ),
              );
            },
          ),
          _buildSettingItem(
            context,
            icon: Icons.lock_outline,
            title: 'Permissões',
            subtitle: 'Permissão de geolocalização, notificações',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PermissionsSettingsPage(),
                ),
              );
            },
          ),
          _buildSettingItem(
            context,
            icon: Icons.palette_outlined,
            title: 'Aparência',
            subtitle: 'Escolha entre tema Claro ou Escuro',
            onTap: () {
              _showThemeDialog(context);
            },
          ),
          _buildSettingItem(
            context,
            icon: Icons.info_outline,
            title: 'Default',
            subtitle: 'Lorem ipsum ipsum',
            onTap: () {
              // Navigate to default settings
            },
          ),
          const Divider(),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.logout, color: Colors.red, size: 28),
            ),
            title: const Text(
              'Sair',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 28),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escolher Tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Claro'),
              onTap: () {
                Navigator.pop(context);
                // Apply light theme
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Escuro'),
              onTap: () {
                Navigator.pop(context);
                // Apply dark theme
              },
            ),
          ],
        ),
      ),
    );
  }
}
