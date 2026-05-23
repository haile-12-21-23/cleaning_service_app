import 'package:cleaning_service_app/features/profile/data/models/user_model.dart';

class ReviewModel {
  final String id;
  final String bookingId;
  final String comment;
  final int rating;
  final String createdAt;
  final UserModel provider;
  final UserModel client;

  ReviewModel({
    required this.id,
    required this.bookingId,
    required this.comment,
    required this.rating,
    required this.createdAt,
    required this.provider,
    required this.client,
  });
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      bookingId: json['booking_id'],
      comment: json['comment'],
      rating: json['rating'],
      createdAt: json['created_at'],
      provider: UserModel.fromJson(json['provider']),
      client: UserModel.fromJson(json['client']),
    );
  }
}
