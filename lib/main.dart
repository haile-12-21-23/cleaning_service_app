import 'package:cleaning_service_app/core/routes/app_router.dart';
import 'package:cleaning_service_app/core/theme/app_theme.dart';
import 'package:cleaning_service_app/features/auth/presentation/providers/auth_controller.dart';

import 'package:cleaning_service_app/features/auth/presentation/screens/login_screen.dart';
import 'package:cleaning_service_app/features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}


class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {


  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(authControllerProvider.notifier).checkAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      // home: authState.isAuthenticated ? ProfileScreen() : LoginScreen(),
    );
  }
}
