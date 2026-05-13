import 'package:cleaning_service_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:cleaning_service_app/features/auth/data/models/login_request.dart';
import 'package:cleaning_service_app/features/auth/data/models/register_request.dart';
import 'package:cleaning_service_app/features/auth/data/models/token_response.dart';

class AuthRepositoryImpl {
  final AuthRemoteDatasource remote;

  AuthRepositoryImpl(this.remote);

  Future<TokenResponse> login(LoginRequest request) async {
    final response = await remote.login(request);
    print("Response in Repo:$response");
    return response;

  }
  Future<TokenResponse> register(RegisterRequest request) {
    return remote.register(request);
  }
}
