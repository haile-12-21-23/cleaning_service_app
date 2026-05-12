import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onEdit;

  const ProfileAvatar({super.key, this.imageUrl, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.primary, width: 3),
            ),
            child: CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade200,
              child: CachedNetworkImage(
                imageUrl: imageUrl!,
                errorWidget: (context, url, error) {
                  return const Icon(Icons.person, size: 55, color: Colors.grey);
                },
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
