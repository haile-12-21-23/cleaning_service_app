
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage storage;

  AuthLocalDataSource(this.storage);
  final accessToken = "access_token";
  final refreshToken = "refresh_token";

  Future<void> saveAccessToken(String token) async {
    await storage.write(key: accessToken, value: token);
  }

  Future<void> saveRefreshToken(String token) async {
    await storage.write(key: refreshToken, value: token);
  }

  Future<String?> readAccessToken() async {
    return await storage.read(key: accessToken);
  }

  Future<String?> readRefreshToken() async {
    return await storage.read(key: refreshToken);
  }

  Future<void> clearToken() async {
    await storage.delete(key: accessToken);
    await storage.delete(key: refreshToken);
  }
}
