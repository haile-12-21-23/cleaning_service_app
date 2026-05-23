// Remote data source provider

import 'package:cleaning_service_app/core/networks/dio_provider.dart';
import 'package:cleaning_service_app/features/services/data/datasources/review_remote_datasource.dart';
import 'package:cleaning_service_app/features/services/data/models/review_model.dart';
import 'package:cleaning_service_app/features/services/data/repositories/review_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reviewRemoteDataSourceProvider = Provider<ReviewRemoteDatasource>((ref) {
  return ReviewRemoteDatasource(ref.read(dioProvider));
});

// Review Repository provider

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository(ref.read(reviewRemoteDataSourceProvider));
});
//Fetch all reviews
final reviewsProvider = FutureProvider<List<ReviewModel>>((ref) async {
  return ref.read(reviewRepositoryProvider).getClientReviews();
});

// Fetch review detail

final reviewDetailsProvider = FutureProvider<List<ReviewModel>>((ref) async {
  return await ref.read(reviewRepositoryProvider).getClientReviews();
});
