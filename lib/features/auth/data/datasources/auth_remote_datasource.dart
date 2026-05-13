import 'package:cleaning_service_app/core/errors/app_excetion.dart';
import 'package:cleaning_service_app/features/auth/data/models/login_request.dart';
import 'package:cleaning_service_app/features/auth/data/models/register_request.dart';
import 'package:cleaning_service_app/features/auth/data/models/token_response.dart';

import 'package:dio/dio.dart';

class AuthRemoteDatasource {
  final Dio dio;
  AuthRemoteDatasource(this.dio);

  Future<TokenResponse> login(LoginRequest request) async {
    try {
      final response = await dio.post('/auth/login', data: request.toJson());
      print("Data:");
      print(response.data);

      // Success
      if (response.statusCode == 200) {
        return TokenResponse.fromJson(response.data);
      }

      // Backend custom error
      throw AppException(response.data["detail"] ?? "Login failed");
    } on DioException catch (e) {
      // Backend response exists
      if (e.response != null) {
        final data = e.response?.data;

        if (data is Map<String, dynamic>) {
          throw AppException(
            data["detail"] ?? data["message"] ?? "Something went wrong",
          );
        }
      }

      // Network errors
      throw AppException("Unable to connect to server");
    } catch (e) {
      throw AppException(e.toString());
    }
  }
  Future<TokenResponse> register(RegisterRequest request) async {
    try {
      
      final response = await dio.post('auth/register', data: request.toJson());
      if (response.statusCode == 201) {
    return TokenResponse.fromJson(response.data);

      }
      throw AppException(response.data["detail"] ?? "Login failed");
    } on DioException catch (e) {
      // Backend response exists
      if (e.response != null) {
        final data = e.response?.data;

        if (data is Map<String, dynamic>) {
          throw AppException(
            data["detail"] ?? data["message"] ?? "Something went wrong",
          );
        }
      }

      // Network errors
      throw AppException("Unable to connect to server");
    } catch (e) {
      throw AppException(e.toString());
    }

  }
}
