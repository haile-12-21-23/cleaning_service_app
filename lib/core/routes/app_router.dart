import 'package:cleaning_service_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:cleaning_service_app/features/auth/presentation/screens/login_screen.dart';
import 'package:cleaning_service_app/features/auth/presentation/screens/register_screen.dart';
import 'package:cleaning_service_app/features/profile/screens/profile_screen.dart';
import 'package:cleaning_service_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: "/splash",

    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;

      final isAuthRoute =
          state.fullPath == "/login" || state.matchedLocation == "/register";

      // wait util auth check completes

      if (!authState.isInitialized) {
        return "/splash";
      }

      /// If NOT logged in
      if (!isLoggedIn && !isAuthRoute) {
        return "/login";
      }

      /// If logged in and trying to go login
      if (isLoggedIn && isAuthRoute) {
        return "/profile";
      }

      // / If logged in
      if (isLoggedIn) {
        return "/profile";
      }

      return null;
    },
    routes: [
      GoRoute(
        path: "/splash",
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(path: "/login", builder: (context, state) => const LoginScreen()),

      GoRoute(
        path: "/register",
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
        path: "/profile",
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
