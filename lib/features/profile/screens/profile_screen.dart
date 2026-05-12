import 'package:cleaning_service_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:cleaning_service_app/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    ref.listen<AuthState>(authControllerProvider, (prev, next) {
      print("next:${next.loggedOut}");
      if (next.loggedOut) {
        context.go('/login');
        print("Routing");
      }
    });
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Profile Screen"),

            ElevatedButton(
              onPressed: authState.isLoading
                  ? null
                  : () async {
                      print("Logged out......");
                      await ref.read(authControllerProvider.notifier).logout();
              },
              child: authState.isLoading
                  ? CircularProgressIndicator()
                  : Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
