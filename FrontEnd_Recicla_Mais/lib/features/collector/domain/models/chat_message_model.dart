
/// Representa o modelo de dados para uma única mensagem de chat.
library;

/// Esta classe define a estrutura de uma mensagem de chat, que é usada
/// para a comunicação entre o coletor e o usuário que solicitou a coleta.
class ChatMessage {
  /// O identificador único da mensagem.
  final String id;

  /// O conteúdo textual da mensagem.
  final String text;

  /// Indica se a mensagem foi enviada pelo coletor (`true`) ou pelo usuário (`false`).
  final bool isFromCollector;

  /// A data e hora em que a mensagem foi enviada.
  final DateTime timestamp;

  /// Indica se a mensagem foi lida pelo destinatário. O padrão é `false`.
  final bool isRead;

  /// Cria uma instância de [ChatMessage].
  ChatMessage({
    required this.id,
    required this.text,
    required this.isFromCollector,
    required this.timestamp,
    this.isRead = false,
  });

  /// Cria uma cópia desta instância de [ChatMessage], mas com os campos
  /// fornecidos substituídos pelos novos valores.
  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isFromCollector,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isFromCollector: isFromCollector ?? this.isFromCollector,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}
