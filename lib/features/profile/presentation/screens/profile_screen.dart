import 'package:cleaning_service_app/core/widgets/app_app_bar.dart';
import 'package:cleaning_service_app/features/auth/presentation/providers/auth_controller.dart';

import 'package:cleaning_service_app/features/auth/presentation/widgets/profile_avatar.dart';
import 'package:cleaning_service_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final theme = Theme.of(context);
    final profileAsync = ref.watch(myProfileProvider);
   
    return Scaffold(
      appBar: AppAppBar(title: "Profile"),
      body: profileAsync.when(
        data: (profile) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ProfileAvatar(imageUrl: profile.profile, onEdit: () {}),
                const SizedBox(height: 16),
                Text(profile.name, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    profile.role.toUpperCase(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Info Card
                Card(
                  elevation: 2,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text(
                          "Phone",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        subtitle: Text(
                          profile.phone,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: Text(
                          "Member Since",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        subtitle: Text(
                          profile.createdAt.split("T").first,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Actions
                Card(
                  elevation: 2,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.bookmark),
                        title: Text(
                          'My Bookings',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          context.go("/bookings");
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text(
                          "Settings",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: will define Setting screen
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.help),
                        title: Text(
                          "Help Center",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: will define it later.
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Logout TODO: will move it setting screen
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await ref.read(authControllerProvider.notifier).logout();
                      context.go("/login");
                    },
                    icon: Icon(Icons.logout),
                    label: Text("Logout"),
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, _) {
          return Center(
            child: Column(
              children: [
                Text(error.toString()),

                ElevatedButton(
                  onPressed: () async {
                    await ref.read(authControllerProvider.notifier).logout();
                    context.go("/login");
                    print("Logout......");
                  },
                  child: Text('data'),
                ),
              ],
            ),
          );
        },
        loading: () {
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
