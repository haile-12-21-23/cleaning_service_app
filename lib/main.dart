import 'package:cleaning_service_app/core/routes/app_router.dart';
import 'package:cleaning_service_app/core/theme/app_theme.dart';
import 'package:cleaning_service_app/features/auth/presentation/providers/auth_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  await container.read(authControllerProvider.notifier).checkAuth();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {


 

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
      scaffoldMessengerKey: rootScaffoldMessengerKey,

      // home: authState.isAuthenticated ? ProfileScreen() : LoginScreen(),
    );
  }
}
