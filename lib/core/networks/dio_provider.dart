import 'package:cleaning_service_app/core/constants/app_endpoints.dart';
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
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(

      /// REQUEST
      onRequest: (options, handler) async {
        final token = await ref
            .read(authLocalDataSourceProvider)
            .readAccessToken();

        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }

        handler.next(options);
      },

      /// ERROR
      onError: (e, handler) async {
        /// CHECK IF TOKEN EXPIRED
        ///
        if (e.response?.statusCode == 401) {
          // print(object)
          try {
            final local = ref.read(authLocalDataSourceProvider);

            final refreshToken = await local.readRefreshToken();

            if (refreshToken == null) {
              return handler.next(e);
            }

            /// CALL REFRESH API
            final refreshResponse = await dio.post(
              AppEndpoints.refresh,
              data: {"refresh_token": refreshToken},
            );

            /// SUCCESS
            if (refreshResponse.statusCode == 200) {
              final newAccessToken = refreshResponse.data["access_token"];

              /// SAVE NEW TOKEN
              await local.saveAccessToken(newAccessToken);

              /// RETRY ORIGINAL REQUEST
              final requestOptions = e.requestOptions;

              requestOptions.headers["Authorization"] =
                  "Bearer $newAccessToken";

              final clonedResponse = await dio.fetch(requestOptions);

              return handler.resolve(clonedResponse);
            }
          } catch (refreshError) {
            /// OPTIONAL: LOGOUT USER
            // await ref.read(authControllerProvider.notifier).logout();

            return handler.next(e);
          }
        }

        /// NORMAL ERROR HANDLING
        String message = "Something went wrong.";

        final data = e.response?.data;

        if (data != null && data is Map<String, dynamic>) {
          message = data["detail"] ?? data["message"] ?? message;
        }

        handler.reject(
          DioException(
            requestOptions: e.requestOptions,
            error: Exception(message),
            response: e.response,
            type: e.type,
          ),
        );
      },
    ),
  );

  return dio;
});
