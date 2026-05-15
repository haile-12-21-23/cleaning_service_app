import 'package:cleaning_service_app/features/chat/data/services/chat_socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatSocketProvider = Provider<ChatSocketService>((ref) {
  final service = ChatSocketService();

  ref.onDispose(() {
    service.dispose();
  });
  return service;
});
