import 'package:cleaning_service_app/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:cleaning_service_app/features/booking/data/models/booking_model.dart';
import 'package:cleaning_service_app/features/booking/data/models/create_booking_request.dart';

class BookingRepositoryImpl {
  BookingRemoteDatasource remote;

  BookingRepositoryImpl(this.remote);

  Future<void> createBooking(CreateBookingRequest request) async {
    return await remote.createBooking(request);
  }

  Future<List<BookingModel>> getMyBookings({int limit = 10}) async {
    return await remote.getMyBookings(limit: limit);
  }
}
