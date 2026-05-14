import 'package:cleaning_service_app/features/chat/data/datasource/chat_remote_datasource.dart';
import 'package:cleaning_service_app/features/chat/data/models/conversation_model.dart';

class ChatRepositoryImpl {
  final ChatRemoteDatasource remote;

  ChatRepositoryImpl(this.remote);

  Future<List<ConversationModel>> getConversations(String userId) async {
    return await remote.getConversations(userId);
  }
}
