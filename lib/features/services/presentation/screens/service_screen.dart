import 'package:cleaning_service_app/core/widgets/app_app_bar.dart';
import 'package:cleaning_service_app/features/services/presentation/providers/service_provider.dart';
import 'package:cleaning_service_app/features/services/presentation/widgets/service_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ServiceScreen extends ConsumerStatefulWidget {
  const ServiceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends ConsumerState<ServiceScreen> {
  @override
  Widget build(BuildContext context) {
    final serviceAsync = ref.watch(servicesProvider);
    return Scaffold(
      appBar: AppAppBar(title: "Services"),
      body: serviceAsync.when(
        data: (services) {
          if (services.isEmpty) {
            return Center(child: Text("No services found."));
          }
          return ListView.separated(
            itemBuilder: (context, index) {
              return ServiceCard(service: services[index]);
            },
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemCount: services.length,
          );
        },
        error: (error, st) {
          return Center(child: Text(error.toString()));
        },
        loading: () {
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push("/create-service");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
