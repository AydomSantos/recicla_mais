import 'package:flutter/material.dart';

class UserNotificationsPage extends StatelessWidget {
  const UserNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        backgroundColor: const Color(0xFF3493F2),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationItem(
            title: 'Solicitação Aceita',
            message: 'O coletor Johnson aceitou sua solicitação de coleta.',
            time: 'Há 5 min',
            icon: Icons.check_circle,
            iconColor: Colors.green,
            isUnread: true,
          ),
          const Divider(),
          _buildNotificationItem(
            title: 'Coleta Agendada',
            message: 'Sua coleta foi agendada para amanhã às 14:00.',
            time: 'Há 2 horas',
            icon: Icons.schedule,
            iconColor: Colors.orange,
            isUnread: false,
          ),
          const Divider(),
          _buildNotificationItem(
            title: 'Dica de Reciclagem',
            message:
                'Separe o vidro do restante do lixo para evitar acidentes.',
            time: 'Há 1 dia',
            icon: Icons.lightbulb,
            iconColor: Colors.blue,
            isUnread: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String message,
    required String time,
    required IconData icon,
    required Color iconColor,
    required bool isUnread,
  }) {
    return Container(
      color: isUnread ? Colors.blue.withOpacity(0.05) : Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.1),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isUnread ? Colors.black : Colors.grey[700],
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          if (isUnread)
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
            ),
        ],
      ),
    );
  }
}
