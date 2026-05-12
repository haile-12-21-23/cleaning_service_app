class RegisterRequest {
  final String name;
  final String role;
  final String profile;
  final String phone;
  final String password;

  RegisterRequest({
    required this.phone,
    required this.password,
    required this.name,
    required this.role,
    required this.profile,
  });
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "role": role,
      "profile": profile,
      "phone": phone,
      "password": password,
    };
  }
}
