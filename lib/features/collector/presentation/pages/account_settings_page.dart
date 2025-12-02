import 'package:flutter/material.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conta'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Editar Perfil'),
            subtitle: const Text('Alterar nome, foto e informações'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to edit profile
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Alterar Endereço'),
            subtitle: const Text('Atualizar endereço de coleta'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to change address
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Telefone'),
            subtitle: const Text('Atualizar número de contato'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to change phone
            },
          ),
        ],
      ),
    );
  }
}
