import 'package:cleaning_service_app/core/networks/dio_provider.dart';
import 'package:cleaning_service_app/features/services/data/datasources/service_remote_datasource.dart';
import 'package:cleaning_service_app/features/services/data/models/create_service_request.dart';
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
//Fetch all services
final servicesProvider = FutureProvider<List<ServiceModel>>((ref) async {
  return ref.read(serviceRepositoryProvider).getServices();
});

// Fetch service detail

final serviceDetailsProvider = FutureProvider.family<ServiceModel, String>((
  ref,
  id,
) {
  return ref.read(serviceRepositoryProvider).getSingleService(id);
});

//Create Service

class CreateServiceController extends StateNotifier<AsyncValue<void>> {
  final ServiceRepositoryImpl repository;
  CreateServiceController(this.repository) : super(const AsyncData(null));

  Future<void> createService(CreateServiceRequest request) async {
    try {
      state = AsyncLoading();
      await repository.createService(request);
      state = AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

// Create Service provider

final createServiceProvider =
    StateNotifierProvider<CreateServiceController, AsyncValue<void>>((ref) {
      return CreateServiceController(ref.read(serviceRepositoryProvider));
    });
