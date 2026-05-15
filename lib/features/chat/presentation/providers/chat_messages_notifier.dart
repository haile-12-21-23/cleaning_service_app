import 'package:chatview/chatview.dart';
import 'package:cleaning_service_app/features/chat/data/services/chat_socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessagesNotifier extends StateNotifier<List<Message>> {
  final ChatSocketService socket;
  final String conversationId;

  ChatMessagesNotifier(this.socket, this.conversationId) : super([]) {
    _init();
  }
  void _init() {
    socket.connect(conversationId: conversationId);
    socket.messageStream.listen((data) {
      final msg = Message(
        id: data['id'],
        message: data['content'],
        createdAt: data['created_at'],
        sentBy: data['sender_id'],
      );
      state = [...state, msg];
    });
  }

  void addLocalMessage(Message message) {
    state = [...state, message];
  }
}
