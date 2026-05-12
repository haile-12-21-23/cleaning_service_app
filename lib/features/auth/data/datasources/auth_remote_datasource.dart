import 'package:cleaning_service_app/features/auth/data/models/login_request.dart';
import 'package:cleaning_service_app/features/auth/data/models/register_request.dart';
import 'package:cleaning_service_app/features/auth/data/models/token_response.dart';

import 'package:dio/dio.dart';

class AuthRemoteDatasource {
  final Dio dio;
  AuthRemoteDatasource(this.dio);

  Future<TokenResponse> login(LoginRequest request) async {
    final response = await dio.post('auth/login', data: request.toJson());
    return TokenResponse.fromJson(response.data);
  }
  Future<TokenResponse> register(RegisterRequest request) async {
    final response = await dio.post('auth/register', data: request.toJson());
    return TokenResponse.fromJson(response.data);
  }
}
