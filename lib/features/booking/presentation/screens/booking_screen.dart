import 'package:cleaning_service_app/core/widgets/app_app_bar.dart';
import 'package:cleaning_service_app/features/booking/presentation/providers/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookingScreen extends ConsumerWidget {
  const BookingScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(myBookingsProvider);
    return Scaffold(
      appBar: AppAppBar(title: "Booking"),

      body: bookingAsync.when(
        data: (bookings) {
          if (bookings.isEmpty) {
            return const Center(child: Text('No booking yet.'));
          }
          return ListView.separated(
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return ListTile(
                title: Text(booking.service.title),
                subtitle: Text(booking.service.description),
                trailing: Text(booking.status),
              );
            },
            separatorBuilder: (context, _) => const SizedBox(height: 8),
            itemCount: bookings.length,
          );
        },
        error: (error, _) {
          return Center(child: Text(error.toString()));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
