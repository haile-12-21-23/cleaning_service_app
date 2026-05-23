import 'package:cached_network_image/cached_network_image.dart';
import 'package:cleaning_service_app/features/booking/data/models/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        // context.push("/service/${booking.service.id}");
        context.push("/booking-details", extra: booking);
      },
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsetsGeometry.all(16),
          child: Row(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: booking.service.serviceImage,
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) {
                      return Icon(Icons.cleaning_services);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.service.title,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      booking.service.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ETB ${booking.service.price}",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(
                              booking.status,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            booking.status.toUpperCase(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: _statusColor(booking.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "accepted":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "canceled":
        return Colors.red;
      case "completed":
        return Colors.blue;
      default:
        return Colors.black;
    }
  }
}
