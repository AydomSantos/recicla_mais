import 'package:flutter/material.dart';
import 'package:recicla_mais/features/collector/domain/models/chat_message_model.dart';
import 'package:recicla_mais/features/collector/presentation/widgets/message_bubble.dart';

/// Uma página que exibe a interface de chat para uma conversa específica.
///
/// Recebe o nome e o ID do usuário com quem o coletor está conversando
/// para exibir no `AppBar` e para futuras lógicas de backend.
class ChatPage extends StatefulWidget {
  /// O nome do usuário para ser exibido no `AppBar`.
  final String userName;
  /// O identificador único do usuário.
  final String userId;

  const ChatPage({super.key, required this.userName, required this.userId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

/// Gerencia o estado da página de chat, incluindo a lista de mensagens,
/// os controladores de texto e de rolagem.
class _ChatPageState extends State<ChatPage> {
  /// Controlador para o campo de entrada de texto da mensagem.
  final TextEditingController _messageController = TextEditingController();
  /// Controlador para a `ListView` que exibe as mensagens, permitindo rolar a tela.
  final ScrollController _scrollController = ScrollController();
  /// A lista de mensagens exibidas na tela.
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Carrega as mensagens iniciais do chat.
  ///
  /// Atualmente, utiliza dados mockados para fins de demonstração.
  /// Em uma aplicação real, aqui seria feita a chamada para buscar o histórico
  /// de mensagens de um serviço de backend ou banco de dados.
  void _loadMessages() {
    final now = DateTime.now();
    _messages.addAll([
      ChatMessage(
        id: '1',
        text: 'Olá! Gostaria de confirmar o horário da coleta.',
        isFromCollector: false,
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
      ChatMessage(
        id: '2',
        text:
            'Olá! Posso coletar hoje à tarde, por volta das 15h. Está bom para você?',
        isFromCollector: true,
        timestamp: now.subtract(const Duration(hours: 1, minutes: 50)),
      ),
      ChatMessage(
        id: '3',
        text: 'Perfeito! Estarei em casa nesse horário.',
        isFromCollector: false,
        timestamp: now.subtract(const Duration(hours: 1, minutes: 45)),
      ),
      ChatMessage(
        id: '4',
        text: 'Ótimo! Até logo.',
        isFromCollector: true,
        timestamp: now.subtract(const Duration(hours: 1, minutes: 40)),
      ),
    ]);

    // Scroll to bottom after loading messages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  /// Envia uma nova mensagem.
  ///
  /// Adiciona a mensagem à lista local, limpa o campo de texto e rola
  /// a lista para o final para exibir a nova mensagem.
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: _messageController.text.trim(),
          isFromCollector: true,
          timestamp: DateTime.now(),
        ),
      );
      _messageController.clear();
    });

    // Scroll to bottom after sending
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3493F2),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.grey[700]),
            ),
            const SizedBox(width: 12),
            Text(widget.userName),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma mensagem ainda',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return MessageBubble(message: _messages[index]);
                    },
                  ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Digite uma mensagem...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF3493F2),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
