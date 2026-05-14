import 'package:cleaning_service_app/core/widgets/app_app_bar.dart';
import 'package:cleaning_service_app/features/booking/data/models/booking_model.dart';
import 'package:cleaning_service_app/features/profile/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookingDetailScreen extends ConsumerWidget {
  final BookingModel booking;

  const BookingDetailScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppAppBar(title: "Booking Details"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Status Card
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Booking Status",
                            style: theme.textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
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
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: _statusColor(booking.status),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Service Card
            _SectionCard(
              title: "Service",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.service.title,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 12),

                  Text(booking.service.description),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.attach_money),
                      const SizedBox(width: 6),
                      Text(
                        "${booking.service.price} ETB",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Client Card
            _UserCard(title: "Client", user: booking.client),

            // Provider Card
            _UserCard(title: "Provider", user: booking.provider),

            // Metadata Card
            _SectionCard(
              title: "Booking Information",
              child: Column(
                children: [
                  _InfoTitle(label: "Booking Id", value: booking.id),
                  _InfoTitle(
                    label: "Booked At",
                    value: booking.createdAt.split("T").first,
                  ),
                  _InfoTitle(label: "Service ID", value: booking.service.id),
                ],
              ),
            ),
          ],
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

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final String title;
  final UserModel user;
  const _UserCard({required this.title, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SectionCard(
      title: title,
      child: Row(
        children: [
          const CircleAvatar(radius: 28, child: Icon(Icons.person)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: theme.textTheme.titleSmall),
                const SizedBox(height: 6),
                Text(user.phone),
                const SizedBox(height: 6),

                Text(
                  user.role.toUpperCase(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTitle extends StatelessWidget {
  final String label;
  final String value;
  const _InfoTitle({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: theme.textTheme.bodyLarge),
          ),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}
