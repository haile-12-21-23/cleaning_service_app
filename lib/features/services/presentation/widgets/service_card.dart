import 'package:cleaning_service_app/features/services/data/models/service_model.dart';
import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
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
              child: Icon(Icons.cleaning_services),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(
                    service.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "ETB ${service.price}",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
