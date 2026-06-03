import 'package:cached_network_image/cached_network_image.dart';
import 'package:cleaning_service_app/core/utils/app_date_formatter.dart';
import 'package:cleaning_service_app/core/widgets/app_app_bar.dart';
import 'package:cleaning_service_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:cleaning_service_app/features/profile/data/models/user_model.dart';
import 'package:cleaning_service_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ConversationScreen> {
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final user = await ref.read(myProfileProvider);
      user.whenOrNull(
        data: (data) {
          currentUser = data;
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print("Current User: ${currentUser?.name}");
    print("Current User ID: ${currentUser?.id}");

    final conversationAsync = ref.watch(
      conversationProvider(currentUser?.id.trim() ?? ''),
    );
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
              return Card(
                elevation: 1,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: currentUser?.id == conversation.client.id
                            ? conversation.provider.profile
                            : conversation.client.profile,
                        errorWidget: (_, _, _) => Text(
                          currentUser?.id == conversation.client.id
                              ? conversation.provider.name[0].toUpperCase()
                              : conversation.client.name[0].toUpperCase(),
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    currentUser?.id == conversation.client.id
                        ? conversation.provider.name
                        : conversation.client.name,
                  ),
                  subtitle: Text(
                    currentUser?.id == conversation.client.id
                        ? conversation.provider.phone
                        : conversation.client.phone,
                  ),

                  onTap: () {
                    context.push('/chat', extra: conversation);
                  },
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppDateFormatter.relative(conversation.createdAt),
                        // conversation.createdAt.split("T").first
                      ),
                      Container(
                        // alignment: Alignment.center,
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary,
                        ),
                        child: Text(
                          '14',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
