import 'package:chatview/chatview.dart';
import 'package:cleaning_service_app/features/chat/presentation/providers/chat_messages_notifier.dart';
import 'package:cleaning_service_app/features/chat/presentation/providers/chat_socket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatMessagesProvider =
    StateNotifierProvider.family<ChatMessagesNotifier, List<Message>, String>((
      ref,
      conversationId,
    ) {
      final socket = ref.watch(chatSocketProvider);

      socket.connect(conversationId: conversationId);
      return ChatMessagesNotifier(socket, conversationId);
    });
