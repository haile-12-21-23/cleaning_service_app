import 'package:cleaning_service_app/features/chat/data/datasource/chat_remote_datasource.dart';
import 'package:cleaning_service_app/features/chat/data/models/conversation_model.dart';
import 'package:cleaning_service_app/features/chat/data/models/message_model.dart';

class ChatRepositoryImpl {
  final ChatRemoteDatasource remote;

  ChatRepositoryImpl(this.remote);

  Future<List<ConversationModel>> getConversations(String userId) async {
    return await remote.getConversations(userId);
  }
  Future<List<MessageModel>> getMessages(String userId) async {
    return await remote.getMessages(userId);
  }
}
