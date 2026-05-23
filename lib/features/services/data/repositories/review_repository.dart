import 'package:cleaning_service_app/features/services/data/datasources/review_remote_datasource.dart';
import 'package:cleaning_service_app/features/services/data/models/review_model.dart';

class ReviewRepository {
  final ReviewRemoteDatasource remote;
  ReviewRepository(this.remote);

  Future<List<ReviewModel>> getClientReviews({int limit = 10}) async {
    return await remote.getClientReviews(limit: limit);
  }
}
