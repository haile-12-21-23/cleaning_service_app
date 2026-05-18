import 'package:cleaning_service_app/features/chat/data/models/chat_message_model.dart';
import 'package:cleaning_service_app/features/chat/presentation/providers/chat_messages_notifier.dart';
import 'package:cleaning_service_app/features/chat/presentation/providers/chat_socket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatMessagesProvider =
    StateNotifierProvider.family<
      ChatMessagesNotifier,
      List<ChatMessageModel>,
      String
    >((
      ref,
      conversationId,
    ) {
      final socket = ref.watch(chatSocketProvider);

      socket.connect(conversationId: conversationId);
      return ChatMessagesNotifier(socket, conversationId);
    });
