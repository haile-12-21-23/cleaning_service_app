
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage storage;

  AuthLocalDataSource(this.storage);

  Future<void> saveToken(String token) async {
    await storage.write(key: "token", value: token);
  }

  Future<String?> readToken() async {
    return await storage.read(key: "token");
  }

  Future<void> clearToken() async {
    await storage.delete(key: "token");
    print("token cleared:${await readToken()}");
  }
}
