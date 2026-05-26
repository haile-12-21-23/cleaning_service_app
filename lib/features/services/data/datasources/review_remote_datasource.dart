import 'package:cleaning_service_app/core/constants/app_endpoints.dart';
import 'package:cleaning_service_app/core/errors/app_exception.dart';
import 'package:cleaning_service_app/features/services/data/models/review_model.dart';
import 'package:dio/dio.dart';

class ReviewRemoteDatasource {
  final Dio dio;
  ReviewRemoteDatasource(this.dio);

  Future<List<ReviewModel>> getClientReviews({int limit = 10}) async {
    try {
      final response = await dio.get(AppEndpoints.clientReviews);
      if (response.statusCode == 200) {
        final serviceData = response.data as List;
        return serviceData
            .map((service) => ReviewModel.fromJson(service))
            .toList();
      }
      // Backend custom error
      throw AppException(response.data["detail"] ?? "Failed to load service");
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<List<ReviewModel>> getProviderReviews({int limit = 10}) async {
    try {
      final response = await dio.get(AppEndpoints.providerReviews);
      if (response.statusCode == 200) {
        final serviceData = response.data as List;
        return serviceData
            .map((service) => ReviewModel.fromJson(service))
            .toList();
      }
      // Backend custom error
      throw AppException(response.data["detail"] ?? "Failed to load service");
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
