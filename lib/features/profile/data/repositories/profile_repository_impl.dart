import 'package:cleaning_service_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:cleaning_service_app/features/profile/data/models/user_model.dart';

class ProfileRepositoryImpl {
  final ProfileRemoteDatasource remote;

  ProfileRepositoryImpl(this.remote);
  Future<UserModel> getMe() async {
    return await remote.getMe();
  }
}
