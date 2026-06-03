import 'dart:io';

import 'package:cleaning_service_app/core/networks/dio_provider.dart';
import 'package:cleaning_service_app/core/providers.dart';
import 'package:cleaning_service_app/core/storage/auth_local_data_source.dart';
import 'package:cleaning_service_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:cleaning_service_app/features/auth/data/models/login_request.dart';
import 'package:cleaning_service_app/features/auth/data/models/register_request.dart';
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
    : super(
        AuthState(
          isAuthenticated: false,
          isLoading: false,
          isInitialized: false,
        ),
      ) {
    checkAuth();
  }

  Future<void> checkAuth() async {
    final token = await local.readAccessToken();
    
    print("TOKEN FROM STORAGE: '$token'");
    final loggedIn = token != null && token.isNotEmpty;

    state = state.copyWith(isAuthenticated: loggedIn, isInitialized: true);
    print("AUTH STATE: ${state.isAuthenticated}");

  }

  Future<void> login(String phone, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await repository.login(
        LoginRequest(phone: phone, password: password),
      );
print("TOKEN:");
      print(response.accessToken);
      await local.saveAccessToken(response.accessToken);
      await local.saveAccessToken(response.refreshToken);


print("Saved Access token:${await local.readAccessToken()}");
      print("Saved Refresh token:${await local.readRefreshToken()}");
      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        isInitialized: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
  Future<void> register(
  RegisterRequest request
  ) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await repository.register(
        RegisterRequest(
          name: request.name,
          role: request.role,
          profile: request.profile,
          phone: request.phone,
          password: request.password,
        ),
      );

      await local.saveAccessToken(response.accessToken);

      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        isInitialized: true,
      );
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
        isInitialized: false,

      );
    } catch (e, st) {
      state = state.copyWith(isLoading: false, error: e.toString());
      print(st);
    }

  
  }
}
class UploadProfileController extends StateNotifier<AsyncValue<String>> {
  final AuthRepositoryImpl repository;

  UploadProfileController(this.repository) : super(const AsyncData(''));

  Future<String> uploadProfile(File request) async {
    try {
      state = const AsyncLoading();
      final response = await repository.uploadProfile(request);

state= AsyncData(response);
      return response;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
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
/// PROVIDER
final uploadProfileControllerProvider = StateNotifierProvider<UploadProfileController, AsyncValue<String>>(
  (ref) {
    return UploadProfileController(
      ref.read(authRepositoryProvider),
    );
  },
);
