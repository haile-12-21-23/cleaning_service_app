import 'dart:io';

class CreateServiceRequest {
  final String title;
  final String description;
  final double price;
  final File serviceImage;

  CreateServiceRequest({
    required this.title,
    required this.description,
    required this.price,
    required this.serviceImage,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "price": price,
      "service_image": serviceImage,
    };
  }
}
