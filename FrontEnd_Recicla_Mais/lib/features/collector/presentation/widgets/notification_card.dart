import 'package:flutter/material.dart';
import 'package:recicla_mais/features/collector/domain/models/notification_model.dart';
import 'package:intl/intl.dart';

/// Um widget que exibe um card para uma única notificação.
///
/// O card muda de aparência com base no status de leitura (`isRead`)
/// e exibe um ícone e cor específicos para cada [NotificationType].
class NotificationCard extends StatelessWidget {
  /// Os dados da notificação a serem exibidos.
  final NotificationModel notification;
  /// Callback acionado quando o card é tocado.
  ///
  /// Geralmente usado para marcar a notificação como lida.
  final VoidCallback? onTap;

  /// Cria uma instância de [NotificationCard].
  const NotificationCard({super.key, required this.notification, this.onTap});

  /// Retorna o ícone apropriado com base no tipo da notificação.
  IconData _getIconForType() {
    switch (notification.type) {
      case NotificationType.newCollection:
        return Icons.recycling;
      case NotificationType.statusUpdate:
        return Icons.update;
      case NotificationType.system:
        return Icons.info_outline;
    }
  }

  /// Retorna a cor do ícone com base no tipo da notificação.
  Color _getColorForType() {
    switch (notification.type) {
      case NotificationType.newCollection:
        return Colors.green;
      case NotificationType.statusUpdate:
        return Colors.blue;
      case NotificationType.system:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd/MM/yyyy');
    final now = DateTime.now();
    final isToday =
        notification.timestamp.year == now.year &&
        notification.timestamp.month == now.month &&
        notification.timestamp.day == now.day;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: notification.isRead ? Colors.white : Colors.blue[50],
      elevation: notification.isRead ? 1 : 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getColorForType().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_getIconForType(), color: _getColorForType(), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          isToday
                              ? timeFormat.format(notification.timestamp)
                              : dateFormat.format(notification.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
