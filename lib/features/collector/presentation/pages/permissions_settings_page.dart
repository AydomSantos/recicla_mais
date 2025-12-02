import 'package:flutter/material.dart';

class PermissionsSettingsPage extends StatefulWidget {
  const PermissionsSettingsPage({super.key});

  @override
  State<PermissionsSettingsPage> createState() =>
      _PermissionsSettingsPageState();
}

class _PermissionsSettingsPageState extends State<PermissionsSettingsPage> {
  bool _locationPermission = true;
  bool _notificationPermission = true;
  bool _cameraPermission = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permissões'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Geolocalização'),
            subtitle: const Text('Permitir acesso à localização'),
            value: _locationPermission,
            onChanged: (value) {
              setState(() => _locationPermission = value);
            },
          ),
          SwitchListTile(
            title: const Text('Notificações'),
            subtitle: const Text('Permitir envio de notificações'),
            value: _notificationPermission,
            onChanged: (value) {
              setState(() => _notificationPermission = value);
            },
          ),
          SwitchListTile(
            title: const Text('Câmera'),
            subtitle: const Text('Permitir acesso à câmera'),
            value: _cameraPermission,
            onChanged: (value) {
              setState(() => _cameraPermission = value);
            },
          ),
        ],
      ),
    );
  }
}
