

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatview/chatview.dart';
import 'package:cleaning_service_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:cleaning_service_app/features/profile/data/models/user_model.dart';
import 'package:cleaning_service_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cleaning_service_app/features/chat/data/models/conversation_model.dart';
import 'package:cleaning_service_app/features/chat/presentation/providers/chat_controller.dart';
import 'package:cleaning_service_app/features/chat/presentation/providers/chat_stream_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final ConversationModel conversation;

  const ChatScreen({super.key, required this.conversation});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  ChatController? chatController;
  UserModel? currentUser;

  bool _initialized = false;

  void _loadInitialMessages(List messages) {
    if (_initialized) return;

    for (final e in messages.reversed) {
      chatController?.addMessage(
        Message(
          id: e.id,
          message: e.content,
          createdAt: e.createdAt,
          sentBy: e.senderId,
          messageType: MessageType.text,
          status: MessageStatus.read,
        ),
      );
    }

    _initialized = true;
  }

  @override
  void initState() {
    super.initState();

   

    Future.microtask(() {
      ref.read(chatControllerProvider.notifier).connect(widget.conversation.id);
     
    });
  }

  @override
  void dispose() {
    chatController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final liveMessages = ref.watch(
    //   chatMessagesProvider(widget.conversation.id),
    // );
    ref.listenManual(chatMessagesProvider(widget.conversation.id), (
      previous,
      next,
    ) {
      if (next.isEmpty) return;

      final latest = next.last;

      chatController?.addMessage(
        Message(
          id: latest.id,
          message: latest.content,
          createdAt: latest.createdAt,
          sentBy: latest.senderId,
          messageType: MessageType.text,
          status: MessageStatus.read,
        ),
      );
    });
    final previousMessages = ref.watch(messageProvider(widget.conversation.id));
    final currentUserAsync = ref.watch(myProfileProvider);
    return currentUserAsync.when(
      data: (messages) {
        chatController ??= ChatController(
          initialMessageList: [],
          scrollController: ScrollController(),
          currentUser: ChatUser(id: messages.id, name: messages.name),
          otherUsers: [
            ChatUser(
              id: messages.id == widget.conversation.client.id
                  ? widget.conversation.provider.id
                  : widget.conversation.client.id,

              name: messages.id == widget.conversation.client.id
                  ? widget.conversation.provider.name
                  : widget.conversation.client.name,

              profilePhoto: messages.id == widget.conversation.client.id
                  ? widget.conversation.provider.profile
                  : widget.conversation.client.profile,
            ),
          ],
        );

        // final messages = ref.watch(
        //   chatMessagesProvider(widget.conversation.id),
        // );
        previousMessages.when(
          data: (messages) {
            _loadInitialMessages(messages);

            for (final e in messages) {
              print(
                " Message ID: ${e.id}, Content: ${e.content}, Sender ID: ${e.senderId}, Created At: ${e.createdAt}",
              );

              chatController?.addMessage(
                Message(
                  id: e.id,
                  message: e.content,
                  createdAt: e.createdAt,
                  sentBy: e.senderId,
                  messageType: MessageType.text,
                  status: MessageStatus.read,
                ),
              );
                
              
            }
          },
          loading: () {},
          error: (_, _) {},
        );

        return _buildChatUI(context, messages, theme);
      },

      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),

      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
    );
  }

  Widget _buildChatUI(
    BuildContext context,
    UserModel currentUser,
    // List messages,
    ThemeData theme,
  ) {
  

   

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              child: CachedNetworkImage(
                imageUrl: currentUser.id == widget.conversation.client.id
                    ? widget.conversation.provider.profile
                    : widget.conversation.client.profile,
                errorWidget: (_, _, _) => const Icon(Icons.person),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentUser.id == widget.conversation.client.id
                      ? widget.conversation.provider.name
                      : widget.conversation.client.name,
                ),
                Text(
                  "Online",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      body: ChatView(
        chatController: chatController!,

        chatViewState: chatController!.initialMessageList.isEmpty
            ? ChatViewState.noData
            : ChatViewState.hasMessages,

        onSendTap: (message, replyMessage, messageType) {
          ref
              .read(chatControllerProvider.notifier)
              .sendMessage(
                senderId: currentUser.id == widget.conversation.client.id
                    ? widget.conversation.client.id
                    : widget.conversation.provider.id,
                receiverId: currentUser.id == widget.conversation.client.id
                    ? widget.conversation.provider.id
                    : widget.conversation.client.id,
                content: message,
              );
        },

        featureActiveConfig: const FeatureActiveConfig(
          enableSwipeToReply: true,
          enableReactionPopup: true,
          enableReplySnackBar: true,
          enablePagination: false,
          enableCurrentUserProfileAvatar: true,
          enableOtherUserProfileAvatar: true,
        ),

        sendMessageConfig: SendMessageConfiguration(
          textFieldBackgroundColor: theme.colorScheme.surfaceContainerHighest,

          defaultSendButtonColor: theme.colorScheme.primary,

          textFieldConfig: TextFieldConfiguration(
            hintText: "Type a message...",
            textStyle: theme.textTheme.bodyMedium,

            onMessageTyping: (status) {
              debugPrint("Typing: $status");
            },
          ),
        ),

        chatBubbleConfig: ChatBubbleConfiguration(
          outgoingChatBubbleConfig: ChatBubble(
            color: theme.colorScheme.primary,
            textStyle: TextStyle(color: theme.colorScheme.onPrimary),
            borderRadius: BorderRadius.circular(18),
          ),

          inComingChatBubbleConfig: ChatBubble(
            color: theme.colorScheme.secondaryContainer,
            textStyle: TextStyle(color: theme.colorScheme.onSecondaryContainer),
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        profileCircleConfig: ProfileCircleConfiguration(
          profileImageUrl: currentUser.id == widget.conversation.client.id
              ? widget.conversation.provider.profile
              : widget.conversation.client.profile,
        ),

        chatBackgroundConfig: ChatBackgroundConfiguration(
          backgroundColor: theme.colorScheme.surface,
        ),

        loadingWidget: const Center(child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
