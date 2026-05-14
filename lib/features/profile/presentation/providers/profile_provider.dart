// Remote Data source provider

import 'package:cleaning_service_app/core/networks/dio_provider.dart';
import 'package:cleaning_service_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:cleaning_service_app/features/profile/data/models/user_model.dart';
import 'package:cleaning_service_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRemoteDatasourceProvider = Provider<ProfileRemoteDatasource>((
  ref,
) {
  return ProfileRemoteDatasource(ref.read(dioProvider));
});

// Repository Provider

final profileRepositoryProvider = Provider<ProfileRepositoryImpl>((ref) {
  return ProfileRepositoryImpl(ref.read(profileRemoteDatasourceProvider));
});

// Get me provider

final myProfileProvider = FutureProvider<UserModel>((ref) async {
  return ref.read(profileRepositoryProvider).getMe();
});
