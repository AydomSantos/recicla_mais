import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _coletasNotifications = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Notificações de Coleta'),
            subtitle: const Text('Receber alertas de novas coletas'),
            value: _coletasNotifications,
            onChanged: (value) {
              setState(() => _coletasNotifications = value);
            },
          ),
          SwitchListTile(
            title: const Text('Som'),
            subtitle: const Text('Reproduzir som nas notificações'),
            value: _soundEnabled,
            onChanged: (value) {
              setState(() => _soundEnabled = value);
            },
          ),
          SwitchListTile(
            title: const Text('Vibração'),
            subtitle: const Text('Vibrar ao receber notificações'),
            value: _vibrationEnabled,
            onChanged: (value) {
              setState(() => _vibrationEnabled = value);
            },
          ),
        ],
      ),
    );
  }
}
