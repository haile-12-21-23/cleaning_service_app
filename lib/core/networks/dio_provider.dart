import 'package:cleaning_service_app/core/errors/app_excetion.dart';
import 'package:cleaning_service_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: "http://127.0.0.1:8000/",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
      // Status Checking
      validateStatus: (status) {
        return status != null && status < 500;
      }
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await ref.read(authLocalDataSourceProvider).readToken();
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        handler.next(options);
      },
      onError: (e, handler) {
        String message = "Something went wrong.";

        final data = e.response?.data;

        print('Error:${e.response}');

        if (data != null) {
          if (data is Map<String, dynamic>) {
            message = data["detail"] ?? data["message"] ?? message;
          }
          print("Message:$message");
        }

        handler.reject(
          DioException(
            requestOptions: e.requestOptions,
            error: AppException(message),
            response: e.response,
            type: e.type,
          ),
        );
      }
    ),
  );
  return dio;
});
