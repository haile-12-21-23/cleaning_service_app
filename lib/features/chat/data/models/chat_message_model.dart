import 'package:chatview/chatview.dart';

Message chatViewMessageFromJson(
  Map<String, dynamic> json,
  String currentUserId,
) {
  return Message(
    id: json['id'],
    message: json['content'],
    createdAt: json['created_at'],
    sentBy: json['sender_id'],
  );
}

class ChatMessageModel {
  final String id;
  final String senderId;
  final String content;
  final DateTime createdAt;

  ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      senderId: json['sender_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
