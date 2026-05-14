// Chat Remote Datasource Provider

import 'package:cleaning_service_app/core/networks/dio_provider.dart';
import 'package:cleaning_service_app/features/chat/data/datasource/chat_remote_datasource.dart';
import 'package:cleaning_service_app/features/chat/data/models/conversation_model.dart';
import 'package:cleaning_service_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRomeDatasourceProvider = Provider<ChatRemoteDatasource>((ref) {
  return ChatRemoteDatasource(ref.read(dioProvider));
});

// Chat Repository Provider

final chatRepositoryProvider = Provider<ChatRepositoryImpl>((ref) {
  return ChatRepositoryImpl(ref.read(chatRomeDatasourceProvider));
});

// Conversation Provider

final conversationProvider =
    FutureProvider.family<List<ConversationModel>, String>((ref, userId) {
      return ref.read(chatRepositoryProvider).getConversations(userId);
    });
