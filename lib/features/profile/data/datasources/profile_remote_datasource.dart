import 'package:cleaning_service_app/core/errors/app_excetion.dart';
import 'package:cleaning_service_app/features/profile/data/models/user_model.dart';
import 'package:dio/dio.dart';

class ProfileRemoteDatasource {
  final Dio dio;

  ProfileRemoteDatasource(this.dio);

  Future<UserModel> getMe() async {
    try {
      final response = await dio.get(("/users/me"));

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      }
      throw AppException(
        response.data["detail"] ?? "Failed to load user data.",
      );
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
