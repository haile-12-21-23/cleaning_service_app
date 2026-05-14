import 'package:cleaning_service_app/features/services/data/models/service_model.dart';

class BookingModel {
  final String id;
  final String status;
  final ServiceModel service;
  final String createdAt;

  BookingModel({
    required this.id,
    required this.status,
    required this.service,
    required this.createdAt,
  });
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    print("json:$json");
    return BookingModel(
      id: json['id'],
      status: json['status'],
      service: ServiceModel.fromJson(json['service']), //json['service'],
      createdAt: json["created_at"],
    );
  }
}
