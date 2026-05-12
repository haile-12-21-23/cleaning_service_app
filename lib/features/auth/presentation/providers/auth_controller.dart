import 'package:cleaning_service_app/core/networks/dio_provider.dart';
import 'package:cleaning_service_app/core/providers.dart';
import 'package:cleaning_service_app/core/storage/auth_local_data_source.dart';
import 'package:cleaning_service_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:cleaning_service_app/features/auth/data/models/login_request.dart';
import 'package:cleaning_service_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:cleaning_service_app/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// LOCAL DATASOURCE
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource(ref.read(secureStorageProvider));
});

/// REMOTE DATASOURCE
final authRemoteDataSourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource(ref.read(dioProvider));
});

/// REPOSITORY
final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  return AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider));
});

/// CONTROLLER
class AuthController extends StateNotifier<AuthState> {
  final AuthRepositoryImpl repository;
  final AuthLocalDataSource local;

  AuthController(this.repository, this.local)
    : super(AuthState(isAuthenticated: false, isLoading: false));

  Future<void> checkAuth() async {
    final token = await local.readToken();

    state = state.copyWith(isAuthenticated: token != null);
  }

  Future<void> login(String phone, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await repository.login(
        LoginRequest(phone: phone, password: password),
      );

      await local.saveToken(response.accessToken);

      state = state.copyWith(isAuthenticated: true, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    
    state = state.copyWith(isLoading: true, error: null);
    try {
      await local.clearToken();

      state = state.copyWith(
        isAuthenticated: false,
        loggedOut: true,
        isLoading: false,
      );
    } catch (e, st) {
      state = state.copyWith(isLoading: false, error: e.toString());
      print(st);
    }

  
  }
}

/// PROVIDER
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(
      ref.read(authRepositoryProvider),
      ref.read(authLocalDataSourceProvider),
    );
  },
);
