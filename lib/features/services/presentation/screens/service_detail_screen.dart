import 'package:cached_network_image/cached_network_image.dart';
import 'package:cleaning_service_app/core/utils/app_date_formatter.dart';
import 'package:cleaning_service_app/core/widgets/app_app_bar.dart';
import 'package:cleaning_service_app/core/widgets/app_snackbar.dart';
import 'package:cleaning_service_app/features/booking/presentation/providers/booking_provider.dart';
import 'package:cleaning_service_app/features/services/presentation/providers/review_provider.dart';

import 'package:cleaning_service_app/features/services/presentation/providers/service_provider.dart';
import 'package:cleaning_service_app/features/services/presentation/widgets/review_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ServiceDetailScreen extends ConsumerStatefulWidget {
  final String serviceId;
  const ServiceDetailScreen({super.key, required this.serviceId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends ConsumerState<ServiceDetailScreen> {
  int selectedRating = 3;
  final TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
  
    final theme = Theme.of(context);
    final serviceAsync = ref.watch(serviceDetailsProvider(widget.serviceId));
    final reviewsAsync = ref.watch(reviewsProvider);

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

      body: Column(
        children: [
          /// 📜 SCROLLABLE CONTENT
          Expanded(
            child: SingleChildScrollView(
              child: serviceAsync.when(
                data: (service) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: service.serviceImage,
                              fit: BoxFit.cover,
                              errorWidget: (_, _, _) =>
                                  const Icon(Icons.cleaning_services, size: 80),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                        Text(
                          service.title,
                          style: theme.textTheme.headlineSmall,
                        ),

                        const SizedBox(height: 12),
                        Text(service.description),

                        const SizedBox(height: 20),
                        Text(
                          "ETB ${service.price}",
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),

                        const SizedBox(height: 30),
                        Divider(
                          height: 1,
                          color: theme.colorScheme.secondaryContainer,
                        ),

                        /// Provider Card
                        Card(
                          // elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Provider Information",
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor:
                                          theme.colorScheme.primaryContainer,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: CachedNetworkImage(
                                          imageUrl: service.provider.profile,
                                          fit: BoxFit.cover,
                                          errorWidget: (_, _, _) => Text(
                                            service.provider.name[0]
                                                .toUpperCase(),
                                            style: TextStyle(fontSize: 28),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          service.provider.name,
                                          style: theme.textTheme.bodyLarge,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '10 Services',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color:
                                                    theme.colorScheme.secondary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // const SizedBox(height: 20),
                        Divider(
                          height: 1,
                          color: theme.colorScheme.secondaryContainer,
                        ),

                        /// Reviews
                        Card(
                          // elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Reviews On Provider!",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Consumer(
                                  builder: (_, WidgetRef ref, _) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ReviewCard(
                                          rating: selectedRating,
                                          maxRating: 5,
                                          size: 24,
                                          onRatingChanged: (newRating) {
                                            setState(() {
                                              selectedRating = newRating;
                                            });
                                            // Handle rating change
                                            print("New Rating: $newRating");
                                            print(
                                              "Old Rating: $selectedRating",
                                            );
                                          },
                                          reviewController: reviewController,
                                          onSubmitReview: () {
                                            // Handle review submission
                                            print(
                                              "Submitted Review: ${reviewController.text} with rating $selectedRating",
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 12),

                                reviewsAsync.when(
                                  data: (reviews) {
                                    return Column(
                                      children: reviews.map((review) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 16,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor: theme
                                                        .colorScheme
                                                        .primaryContainer,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            30,
                                                          ),
                                                      child: CachedNetworkImage(
                                                        imageUrl: review
                                                            .client
                                                            .profile,
                                                        fit: BoxFit.cover,
                                                        errorWidget:
                                                            (_, _, _) => Text(
                                                              review
                                                                  .client
                                                                  .name[0]
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                fontSize: 28,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(review.client.name),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 16),
                                              Row(
                                                children: [
                                                  Row(
                                                    children: List.generate(
                                                      5,
                                                      (index) => Icon(
                                                        index < review.rating
                                                            ? Icons.star
                                                            : Icons.star_border,
                                                        size: 16,
                                                        color: theme
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    AppDateFormatter.shortDate(
                                                      review.createdAt,
                                                    ),

                                                    // review.createdAt
                                                    //     .split("T")
                                                    //     .first,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Text(review.comment),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                  error: (e, _) => Text(e.toString()),
                                  loading: () =>
                                      const CircularProgressIndicator(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                error: (error, _) => Center(child: Text(error.toString())),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),

          /// 🔘 FIXED BOTTOM ACTIONS (NO SCROLL)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // booking logic
                      },
                      child: const Text("Book Service"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showCustomSnackBar(
                          message: 'Chat feature coming soon!',
                          isSuccess: true,
                        );
                      },
                      child: const Text("Chat with Provider"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
