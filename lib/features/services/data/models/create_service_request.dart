class CreateServiceRequest {
  final String title;
  final String description;
  final double price;

  CreateServiceRequest({
    required this.title,
    required this.description,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {"title": title, "description": description, "price": price};
  }
}
