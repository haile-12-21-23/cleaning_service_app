import 'package:cleaning_service_app/features/services/data/datasources/service_remote_datasource.dart';
import 'package:cleaning_service_app/features/services/data/models/create_service_request.dart';
import 'package:cleaning_service_app/features/services/data/models/service_model.dart';

class ServiceRepositoryImpl {
  final ServiceRemoteDatasource remote;

  ServiceRepositoryImpl(this.remote);

  Future<List<ServiceModel>> getServices({int limit = 10}) async {
    return await remote.getServices(limit: limit);

  }

  Future<ServiceModel> getSingleService(String id) async {
    return await remote.getServiceById(id);
  }

  Future<void> createService(CreateServiceRequest request) async {
    return await remote.createService(request);
  }
}
