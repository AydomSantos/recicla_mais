/// Define os tipos de notificação que podem ser recebidas.
enum NotificationType { newCollection, statusUpdate, system }

/// Representa o modelo de dados para uma única notificação.

/// Esta classe define a estrutura de uma notificação que é exibida ao usuário,
/// informando sobre eventos importantes como novas coletas ou atualizações de status.
class NotificationModel {
  /// O identificador único da notificação.
  final String id;

  /// O título da notificação.
  final String title;

  /// A mensagem de corpo da notificação.
  final String message;

  /// O tipo da notificação, que pode ser usado para exibir ícones ou lógicas diferentes.
  final NotificationType type;

  /// A data e hora em que a notificação foi gerada.
  final DateTime timestamp;

  /// Indica se a notificação já foi lida pelo usuário. O padrão é `false`.
  final bool isRead;

  /// Cria uma instância de [NotificationModel].
  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });

  /// Cria uma cópia desta instância de [NotificationModel], mas com os campos
  /// fornecidos substituídos pelos novos valores.
  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}
