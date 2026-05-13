import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavigationScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainNavigationScreen({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            );
          }
          // unselected label style
          return TextStyle(fontWeight: FontWeight.w500, fontSize: 14);
        }),
        height: 48,
        labelPadding: EdgeInsets.zero,
        maintainBottomViewPadding: true,
        surfaceTintColor: theme.colorScheme.secondary,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.cleaning_services),
            selectedIcon: Icon(
              Icons.cleaning_services,
              color: theme.colorScheme.primary,
            ),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: 'Booking',
          ),
          NavigationDestination(icon: Icon(Icons.chat), label: 'Chats'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
