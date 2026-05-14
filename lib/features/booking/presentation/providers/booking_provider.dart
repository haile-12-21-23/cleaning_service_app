import 'package:cleaning_service_app/core/networks/dio_provider.dart';
import 'package:cleaning_service_app/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:cleaning_service_app/features/booking/data/models/booking_model.dart';
import 'package:cleaning_service_app/features/booking/data/models/create_booking_request.dart';
import 'package:cleaning_service_app/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Booking Remote Datasource provider

final bookingRemoteDatasourceProvider = Provider<BookingRemoteDatasource>((
  ref,
) {
  return BookingRemoteDatasource(ref.read(dioProvider));
});

// Booking Repository Provider

final bookingRepositoryProvider = Provider<BookingRepositoryImpl>((ref) {
  return BookingRepositoryImpl(ref.read(bookingRemoteDatasourceProvider));
});

// My Booking Provider

final myBookingsProvider = FutureProvider<List<BookingModel>>((ref) async {
  return ref.read(bookingRepositoryProvider).getMyBookings(limit: 10);
}); // Will add limit parameter

class CreateBookingController extends StateNotifier<AsyncValue<void>> {
  final BookingRepositoryImpl repository;

  CreateBookingController(this.repository) : super(const AsyncData(null));

  Future<void> createBooking(CreateBookingRequest request) async {
    try {
      state = AsyncLoading();
      await repository.createBooking(request);
      state = AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

// Create Booking Provider

final createBookingProvider =
    StateNotifierProvider<CreateBookingController, AsyncValue<void>>((ref) {
      return CreateBookingController(ref.read(bookingRepositoryProvider));
    });
