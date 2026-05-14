import 'package:cleaning_service_app/core/errors/app_excetion.dart';
import 'package:cleaning_service_app/features/chat/data/models/conversation_model.dart';
import 'package:dio/dio.dart';

class ChatRemoteDatasource {
  final Dio dio;
  ChatRemoteDatasource(this.dio);

  Future<List<ConversationModel>> getConversations(String userId) async {
    try {
      final response = await dio.get('/conversation/my/$userId');
      print("chatData:${response.data}");

      if (response.statusCode == 200) {
        final chatData = response.data as List;
        return chatData.map((chat) {
          return ConversationModel.fromJson(chat);
        }).toList();
      }
      throw AppException(
        response.data["detail"] ?? "Failed to load conversations",
      );
    } on DioException catch (e) {
      // Backend response exists
      if (e.response != null) {
        final data = e.response?.data;

        if (data is Map<String, dynamic>) {
          throw AppException(
            data["detail"] ?? data["message"] ?? "Something went wrong",
          );
        }
      }

      // Network errors
      throw AppException("Unable to connect to server");
    } catch (e, st) {
      print("St:$st");
      throw AppException(e.toString());
    }
  }
}
