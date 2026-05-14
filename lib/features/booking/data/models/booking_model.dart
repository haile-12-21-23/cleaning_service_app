import 'package:cleaning_service_app/features/profile/data/models/user_model.dart';
import 'package:cleaning_service_app/features/services/data/models/service_model.dart';

class BookingModel {
  final String id;
  final String status;
  final ServiceModel service;
  final UserModel client;
  final UserModel provider;
  final String createdAt;

  BookingModel({
    required this.id,
    required this.status,
    required this.service,
    required this.client,
    required this.provider,

    required this.createdAt,
  });
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    print("json:$json");
    return BookingModel(
      id: json['id'],
      status: json['status'],
      service: ServiceModel.fromJson(json['service']), //json['service'],
      client: UserModel.fromJson(json['client']),
      provider: UserModel.fromJson(json['provider']),
      createdAt: json["created_at"],
    );
  }
}
