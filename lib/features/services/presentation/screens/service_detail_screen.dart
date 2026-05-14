import 'package:cleaning_service_app/core/widgets/app_app_bar.dart';
import 'package:cleaning_service_app/core/widgets/app_snackbar.dart';
import 'package:cleaning_service_app/features/booking/data/models/create_booking_request.dart';
import 'package:cleaning_service_app/features/booking/presentation/providers/booking_provider.dart';

import 'package:cleaning_service_app/features/services/presentation/providers/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ServiceDetailScreen extends ConsumerWidget {
  final String serviceId;
  const ServiceDetailScreen({super.key, required this.serviceId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final serviceAsync = ref.watch(serviceDetailsProvider(serviceId));

    ref.listen(createBookingProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          showCustomSnackBar(
            message: 'Booking created successfully.',
            isSuccess: true,
          );
          context.pop();
        },
        error: (e, _) {
          showCustomSnackBar(message: e.toString(), isSuccess: false);
        },
      );
    });

    return Scaffold(
      appBar: AppAppBar(title: "Service Details"),
      body: serviceAsync.when(
        data: (service) {
          return Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: theme.colorScheme.primaryContainer,
                  ),
                  child: Icon(Icons.cleaning_services, size: 80),
                ),
                const SizedBox(height: 24),
                Text(service.title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 12),
                Text(service.description),
                const SizedBox(height: 20),
                Text(
                  "ETB ${service.price}",
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(createBookingProvider.notifier)
                          .createBooking(
                            CreateBookingRequest(
                              serviceId: serviceId,
                              providerId: service.provider.id, 
                            ),
                          );
                    },
                    child: Text("Book Service"),
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, st) {
          return Center(child: Text(error.toString()));
        },
        loading: () {
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
