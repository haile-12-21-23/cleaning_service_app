import 'package:cleaning_service_app/features/profile/data/models/user_model.dart';

class ServiceModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final UserModel provider;
  ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.provider,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      provider: UserModel.fromJson(json['provider'])
    );
  }
}
