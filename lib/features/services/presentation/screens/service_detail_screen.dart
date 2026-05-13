import 'package:cleaning_service_app/features/services/presentation/providers/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServiceDetailScreen extends ConsumerWidget {
  final String serviceId;
  ServiceDetailScreen({super.key, required this.serviceId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final serviceAsync = ref.watch(serviceDetailsProvider(serviceId));

    return Scaffold(
      appBar: AppBar(title: Text("Service Details")),
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
                    onPressed: () {},
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
