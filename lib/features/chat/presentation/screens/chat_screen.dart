import 'package:cleaning_service_app/core/widgets/app_app_bar.dart';
import 'package:cleaning_service_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:cleaning_service_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  String userId = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final user = ref.read(myProfileProvider);
      user.whenOrNull(
        data: (data) {
          userId = data.id;
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final conversationAsync = ref.watch(conversationProvider(userId.trim()));
    return Scaffold(
      appBar: AppAppBar(title: "Chats"),
      body: conversationAsync.when(
        data: (conversations) {
          if (conversations.isEmpty) {
            return Center(child: Text("No Conversations."));
          }
          return ListView.separated(
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text(conversation.provider.name),
                subtitle: Text(conversation.provider.phone),

                onTap: () {
                  context.push('/chat', extra: conversation);
                },
              );
            },
            separatorBuilder: (_, _) => SizedBox(height: 12),
            itemCount: conversations.length,
          );
        },
        error: (error, _) {
          return Center(child: Text(error.toString()));
        },
        loading: () {
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
