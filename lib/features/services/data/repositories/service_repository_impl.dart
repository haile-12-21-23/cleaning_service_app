import 'package:cleaning_service_app/features/services/data/datasources/service_remote_datasource.dart';
import 'package:cleaning_service_app/features/services/data/models/service_model.dart';

class ServiceRepositoryImpl {
  final ServiceRemoteDatasource remote;

  ServiceRepositoryImpl(this.remote);

  Future<List<ServiceModel>> getServices({int limit = 10}) async {
    return await remote.getServices(limit: limit);
  }
}
