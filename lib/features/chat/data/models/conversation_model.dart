import 'package:cleaning_service_app/features/profile/data/models/user_model.dart';

class ConversationModel {
  final String id;
  final UserModel client;
  final UserModel provider;
  final String createdAt;

  ConversationModel({
    required this.id,
    required this.client,
    required this.provider,
    required this.createdAt
  });
  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'],
      client: UserModel.fromJson(json['client']),
      provider: UserModel.fromJson(json['provider']),
      createdAt: json['created_at']
    );
  }
}
