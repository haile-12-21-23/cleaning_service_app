import 'package:flutter/material.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),

      child: AppBar(title: Text(title, style: theme.textTheme.headlineMedium)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Defined size
}
