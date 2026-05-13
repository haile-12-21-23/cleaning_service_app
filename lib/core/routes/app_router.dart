import 'package:cleaning_service_app/core/navigation/main_navigation_screen.dart';
import 'package:cleaning_service_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:cleaning_service_app/features/auth/presentation/screens/login_screen.dart';
import 'package:cleaning_service_app/features/auth/presentation/screens/register_screen.dart';
import 'package:cleaning_service_app/features/booking/presentation/booking_screen.dart';
import 'package:cleaning_service_app/features/chat/presentation/chat_screen.dart';
import 'package:cleaning_service_app/features/profile/screens/profile_screen.dart';
import 'package:cleaning_service_app/features/services/presentation/screens/service_screen.dart';
import 'package:cleaning_service_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: "/splash",

    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;

      final isAuthRoute =
          state.matchedLocation == "/login" ||
          state.matchedLocation == "/register";

      final isSplash = state.matchedLocation == "/splash";

      print("route: ${state.matchedLocation}");
      print("loggedIn: $isLoggedIn");
      print("initialized: ${authState.isInitialized}");

      /// Wait until auth check finishes
      if (!authState.isInitialized) {
        return isSplash ? null : "/splash";
      }

      /// User NOT logged in
      if (!isLoggedIn) {
        /// Allow auth pages
        if (isAuthRoute) {
          return null;
        }

        /// Redirect protected pages
        return "/login";
      }

      /// User logged in
      if (isLoggedIn) {
        /// Prevent going back to auth pages
        if (isAuthRoute || isSplash) {
          return "/profile";
        }
      }

      return null;
    },

    routes: [
      GoRoute(
        path: "/splash",
        builder: (_, _) => const SplashScreen(),
      ),

      GoRoute(path: "/login", builder: (_, _) => const LoginScreen()),

      GoRoute(
        path: "/register",
        builder: (_, _) => const RegisterScreen()),

      // GoRoute(
      //   path: "/profile",
      //   builder: (_, _) => const ProfileScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationScreen(navigationShell: navigationShell);
        },
        branches: [
          // Services
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/services', builder: (_, _) => ServiceScreen()),
            ],
          ),

          // Booking
          StatefulShellBranch(
            routes: [
              GoRoute(path: "/booking", builder: (_, _) => BookingScreen()),
            ],
          ),
          // Chat
          StatefulShellBranch(
            routes: [GoRoute(path: "/chat", builder: (_, _) => ChatScreen())],
          ),
          // Profile
          StatefulShellBranch(
            routes: [
              GoRoute(path: "/profile", builder: (_, _) => ProfileScreen()),
            ],
          )
        ],
      ),
    ],
    
  );
});
