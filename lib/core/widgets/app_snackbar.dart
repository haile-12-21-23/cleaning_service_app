import 'package:cleaning_service_app/main.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar({required String message, required bool isSuccess}) {
  final icon = isSuccess ? Icons.check_circle : Icons.close;

  final messenger = rootScaffoldMessengerKey.currentState;
  if (messenger == null) return;

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 12),
            Icon(icon, color: Colors.white),
          ],
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      ),
    );
}
