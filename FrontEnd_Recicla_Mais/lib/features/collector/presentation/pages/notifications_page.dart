import 'package:flutter/material.dart';
import 'package:recicla_mais/features/collector/domain/models/notification_model.dart';
import 'package:recicla_mais/features/collector/presentation/widgets/notification_card.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    final now = DateTime.now();
    _notifications = [
      NotificationModel(
        id: '1',
        title: 'Nova Solicitação de Coleta',
        message: 'Maria Silva solicitou coleta de Plástico - 5kg',
        type: NotificationType.newCollection,
        timestamp: now.subtract(const Duration(minutes: 15)),
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        title: 'Coleta Finalizada',
        message: 'Você finalizou a coleta de João Santos',
        type: NotificationType.statusUpdate,
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationModel(
        id: '3',
        title: 'Nova Solicitação de Coleta',
        message: 'Pedro Oliveira solicitou coleta de Papel - 3kg',
        type: NotificationType.newCollection,
        timestamp: now.subtract(const Duration(hours: 4)),
        isRead: true,
      ),
      NotificationModel(
        id: '4',
        title: 'Atualização do Sistema',
        message: 'Nova versão disponível com melhorias de desempenho',
        type: NotificationType.system,
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationModel(
        id: '5',
        title: 'Coleta Aceita',
        message: 'Você aceitou a coleta de Ana Costa',
        type: NotificationType.statusUpdate,
        timestamp: now.subtract(const Duration(days: 1, hours: 3)),
        isRead: true,
      ),
      NotificationModel(
        id: '6',
        title: 'Nova Solicitação de Coleta',
        message: 'Carlos Mendes solicitou coleta de Metal - 10kg',
        type: NotificationType.newCollection,
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ];
  }

  void _markAsRead(NotificationModel notification) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == notification.id);
      if (index != -1) {
        _notifications[index] = notification.copyWith(isRead: true);
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Notificações'),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Marcar todas como lidas',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Nenhuma notificação',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return NotificationCard(
                  notification: notification,
                  onTap: () {
                    if (!notification.isRead) {
                      _markAsRead(notification);
                    }
                  },
                );
              },
            ),
    );
  }
}
