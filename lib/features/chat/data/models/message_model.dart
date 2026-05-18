import 'package:cleaning_service_app/features/profile/data/models/user_model.dart';

class MessageModel {
  /*
  [
  {
    "id": "7dc9f03b-6164-4805-b7a6-9bc38e36ff7f",
    "conversation_id": "93a1d58c-c13c-4099-8ab7-cf89eab15fed",
    "sender_id": "4bd59b1a-cb7f-4b06-ab56-24108424dc4d",
    "content": "Hello Haile",
    "created_at": "2026-05-18T15:28:01.542585",
    "sender": {
      "id": "4bd59b1a-cb7f-4b06-ab56-24108424dc4d",
      "name": "Abebe",
      "phone": "0939817840",
      "role": "provider",
      "profile": "default.png",
      "created_at": "2026-05-07T15:59:34.708966"
    },
    "receiver": {
      "id": "5044ec5b-d439-4ad0-84a3-7f4a401fa62f",
      "name": "Haile",
      "phone": "09362988758",
      "role": "client",
      "profile": "default.png",
      "created_at": "2026-05-13T13:29:01.149487"
    }
  }
]
  */
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final DateTime createdAt;
  final UserModel sender;
  final UserModel receiver;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.createdAt,
    required this.sender,
    required this.receiver,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      sender: UserModel.fromJson(json['sender']),
      receiver: UserModel.fromJson(json['receiver']),
    );
  }
}
