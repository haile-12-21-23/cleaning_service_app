import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
//   return AuthLocalDataSource(ref.read(secureStorageProvider));
// });
