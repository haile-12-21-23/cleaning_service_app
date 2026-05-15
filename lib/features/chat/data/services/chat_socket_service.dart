import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class ChatSocketService {
  WebSocketChannel? _channel;

  final _messageController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  bool get isConnected => _channel != null;

  void connect({
    required String conversationId,
    String? token, // will add token when backend support it.
  }) {
    final url = "ws://127.0.0.1:8000/ws/chat/$conversationId";
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel!.stream.listen(
      (event) {
        final data = jsonDecode(event);
        _messageController.add(data);
      },
      onError: (error) {
        _messageController.addError(error);
      },
      onDone: () {
        disconnect();
      },
    );
  }

  void sendMessage({required String senderId, required String content}) {
    if (_channel == null) {
      return;
    }
    final payload = jsonEncode({"sender_id": senderId, "content": content});
    _channel!.sink.add(payload);
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    _messageController.close();
    disconnect();
  }
}
