import 'package:cleaning_service_app/features/chat/data/models/chat_message_model.dart';
import 'package:cleaning_service_app/features/chat/data/services/chat_socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessagesNotifier extends StateNotifier<List<ChatMessageModel>> {
  final ChatSocketService socket;
  final String conversationId;

  ChatMessagesNotifier(this.socket, this.conversationId) : super([]) {
    _init();
  }
  void _init() {
    socket.connect(conversationId: conversationId);
    socket.messageStream.listen((data) {
      final msg = ChatMessageModel(
        id: data['id'],
        content: data['content'],
        createdAt: DateTime.parse(data['created_at']),
        senderId: data['sender_id'],
      );
      state = [...state, msg];
    });
  }

  void addLocalMessage(ChatMessageModel message) {
    state = [...state, message];
  }
}
