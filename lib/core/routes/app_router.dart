import 'package:cleaning_service_app/core/navigation/main_navigation_screen.dart';
import 'package:cleaning_service_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:cleaning_service_app/features/auth/presentation/screens/login_screen.dart';
import 'package:cleaning_service_app/features/auth/presentation/screens/register_screen.dart';
import 'package:cleaning_service_app/features/booking/data/models/booking_model.dart';
import 'package:cleaning_service_app/features/booking/presentation/screens/booking_detail_screen.dart';
import 'package:cleaning_service_app/features/booking/presentation/screens/booking_screen.dart';
import 'package:cleaning_service_app/features/chat/data/models/conversation_model.dart';
import 'package:cleaning_service_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:cleaning_service_app/features/chat/presentation/screens/conversation_screen.dart';
import 'package:cleaning_service_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:cleaning_service_app/features/services/presentation/screens/create_service_screen.dart';
import 'package:cleaning_service_app/features/services/presentation/screens/service_detail_screen.dart';
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

      GoRoute(
        path: '/service/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ServiceDetailScreen(serviceId: id);
        },
      ),
      GoRoute(
        path: "/create-service",
        builder: (context, state) {
          return const CreateServiceScreen();
        },
      ),
      GoRoute(
        path: "/booking-details",
        builder: (context, state) {
          final BookingModel booking = state.extra as BookingModel;
          return BookingDetailScreen(booking: booking);
        },
      ),
      GoRoute(
        path: "/chat",
        builder: (context, state) {
          final conversation = state.extra as ConversationModel;
          // final String currentUserId = state.extra as String;
          return ChatScreen(conversation: conversation);
        },
      ),
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
              GoRoute(path: "/bookings", builder: (_, _) => BookingScreen()),
            ],
          ),
          // Chat
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/conversation",
                builder: (_, _) => ConversationScreen(),
              ),
            ],
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
