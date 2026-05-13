class ServiceModel {
  final String id;
  final String title;
  final String description;
  final double price;
  //Will add provider as user later
  ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
    );
  }
}
