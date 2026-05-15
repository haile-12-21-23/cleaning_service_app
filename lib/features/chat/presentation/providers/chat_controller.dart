import 'package:cleaning_service_app/features/chat/data/models/chat_message_model.dart';
import 'package:cleaning_service_app/features/chat/data/services/chat_socket_service.dart';
import 'package:cleaning_service_app/features/chat/presentation/providers/chat_socket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider =
    StateNotifierProvider<ChatControllerNotifier, List<ChatMessageModel>>((
      ref,
    ) {
      final socket = ref.watch(chatSocketProvider);
      return ChatControllerNotifier(socket);
    });

class ChatControllerNotifier extends StateNotifier<List<ChatMessageModel>> {
  final ChatSocketService socket;
  ChatControllerNotifier(this.socket) : super([]);

  void connect(String conversationId) {
    socket.connect(conversationId: conversationId);
    socket.messageStream.listen((data) {
      // final json=jsonDecode(data);
      final message = ChatMessageModel.fromJson(data);
      state = [...state, message];
    });
  }

  void sendMessage(String senderId, String content) {
    socket.sendMessage(senderId: senderId, content: content);
  }
}
