import 'package:cleaning_service_app/core/errors/app_excetion.dart';
import 'package:cleaning_service_app/features/booking/data/models/booking_model.dart';
import 'package:cleaning_service_app/features/booking/data/models/create_booking_request.dart';
import 'package:dio/dio.dart';

class BookingRemoteDatasource {
  final Dio dio;

  BookingRemoteDatasource(this.dio);

  Future<void> createBooking(CreateBookingRequest request) async {
    try {
      await dio.post('/bookings/createBooking', data: request.toJson());
    } on DioException catch (e) {
      // Backend response exists
      if (e.response != null) {
        final data = e.response?.data;

        if (data is Map<String, dynamic>) {
          throw AppException(
            data["detail"] ?? data["message"] ?? "Something went wrong",
          );
        }
      }

      // Network errors
      throw AppException("Unable to connect to server");
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<List<BookingModel>> getMyBookings({int limit = 10}) async {
    try {
      final response = await dio.get(
        "/bookings/getAllBooking?limit?=$limit",
      ); //path will change to bookings/me
      if (response.statusCode == 200) {
        final bookingData = response.data as List;

        return bookingData
            .map((booking) => BookingModel.fromJson(booking))
            .toList();
      }
      throw AppException(response.data["detail"] ?? "Failed to load booking.");
    } on DioException catch (e) {
      // Backend response exists
      if (e.response != null) {
        final data = e.response?.data;

        if (data is Map<String, dynamic>) {
          throw AppException(
            data["detail"] ?? data["message"] ?? "Something went wrong",
          );
        }
      }

      // Network errors
      throw AppException("Unable to connect to server");
    } catch (e, st) {
      print('St:$st');
      throw AppException(e.toString());
    }
  }
}
