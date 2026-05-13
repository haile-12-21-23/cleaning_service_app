import 'package:cleaning_service_app/core/networks/dio_provider.dart';
import 'package:cleaning_service_app/features/services/data/datasources/service_remote_datasource.dart';
import 'package:cleaning_service_app/features/services/data/models/service_model.dart';
import 'package:cleaning_service_app/features/services/data/repositories/service_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Remote data source provider

final serviceRemoteDataSourceProvider = Provider<ServiceRemoteDatasource>((
  ref,
) {
  return ServiceRemoteDatasource(ref.read(dioProvider));
});

// Service Repository provider

final serviceRepositoryProvider = Provider<ServiceRepositoryImpl>((ref) {
  return ServiceRepositoryImpl(ref.read(serviceRemoteDataSourceProvider));
});

final servicesProvider = FutureProvider<List<ServiceModel>>((ref) async {
  return ref.read(serviceRepositoryProvider).getServices();
});
