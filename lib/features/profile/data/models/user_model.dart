class UserModel {
  final String id;
  final String name;
  final String phone;
  final String role;
  final String profile;
  final String createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.profile,
    required this.createdAt,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      role: json['role'],
      profile: json['profile'],
      createdAt: json['created_at'],
    );
  }
}
