import 'package:cleaning_service_app/features/auth/presentation/screens/login_screen.dart';
import 'package:cleaning_service_app/features/profile/screens/profile_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: "/login",

    routes: [
      GoRoute(path: "/login", builder: (context, state) => LoginScreen()),
      GoRoute(path: "/profile", builder: (context, state) => ProfileScreen()),
    ],
  );
}
