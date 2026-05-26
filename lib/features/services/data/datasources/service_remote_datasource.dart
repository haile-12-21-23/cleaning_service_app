import 'package:cleaning_service_app/core/constants/app_endpoints.dart';
import 'package:cleaning_service_app/core/errors/app_exception.dart';
import 'package:cleaning_service_app/features/services/data/models/create_service_request.dart';
import 'package:cleaning_service_app/features/services/data/models/service_model.dart';
import 'package:dio/dio.dart';

class ServiceRemoteDatasource {
  final Dio dio;

  ServiceRemoteDatasource(this.dio);

  Future<List<ServiceModel>> getServices({int limit = 10}) async {
    try {
      final response = await dio.get("${AppEndpoints.allService}?limit=$limit");
      if (response.statusCode == 200) {
        final serviceData = response.data as List;
        return serviceData
            .map((service) => ServiceModel.fromJson(service))
            .toList();
      }
      // Backend custom error
      throw AppException(response.data["detail"] ?? "Failed to load service");
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<ServiceModel> getServiceById(String id) async {
    try {
      final response = await dio.get("${AppEndpoints.singleService}/$id");
      if (response.statusCode == 200) {
        return ServiceModel.fromJson(response.data);
      }
      throw AppException(response.data["detail"] ?? "Failed to load service");
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

  Future<void> createService(CreateServiceRequest request) async {
    try {
      print("request:${request.toJson()}");
      final formData = FormData.fromMap({
        "title": request.title,
        "description": request.description,
        "price": request.price,

        "file": await MultipartFile.fromFile(
          request.serviceImage.path,
          filename: request.serviceImage.path.split('/').last,
        ),
      });
      print("formData:${formData.fields}");

      await dio.post(AppEndpoints.createService, data: formData);
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
    } catch (e, st) {
      print("stacktrace:$st");
      print("error:$e");
      throw AppException(e.toString());
    }
  }
}
