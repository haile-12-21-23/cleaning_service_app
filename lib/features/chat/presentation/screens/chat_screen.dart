

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cleaning_service_app/features/chat/data/models/conversation_model.dart';
import 'package:cleaning_service_app/features/chat/presentation/providers/chat_controller.dart';
import 'package:cleaning_service_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:cleaning_service_app/features/chat/presentation/providers/chat_stream_provider.dart';
import 'package:cleaning_service_app/features/profile/data/models/user_model.dart';
import 'package:cleaning_service_app/features/profile/presentation/providers/profile_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final ConversationModel conversation;

  const ChatScreen({super.key, required this.conversation});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  ChatController? chatController;

  bool _historyLoaded = false;

  final Set<String> renderedMessageIds = {};

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(chatControllerProvider.notifier).connect(widget.conversation.id);
    });

    /// Listen for LIVE websocket messages
    ref.listenManual(chatMessagesProvider(widget.conversation.id), (
      previous,
      next,
    ) {
      if (chatController == null) return;

      for (final e in next) {
        if (renderedMessageIds.contains(e.id)) continue;

        renderedMessageIds.add(e.id);

        chatController!.addMessage(
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
    });
  }

  void _loadHistory(List messages) {
    if (_historyLoaded || chatController == null) return;

    final history = messages.reversed.toList();

    for (final e in history) {
      if (renderedMessageIds.contains(e.id)) continue;

      renderedMessageIds.add(e.id);

      chatController!.addMessage(
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

    _historyLoaded = true;
  }

  @override
  void dispose() {
    chatController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final currentUserAsync = ref.watch(myProfileProvider);

    final previousMessages = ref.watch(messageProvider(widget.conversation.id));

    return currentUserAsync.when(
      data: (currentUser) {
        /// Initialize controller ONCE
        chatController ??= ChatController(
          initialMessageList: [],
          scrollController: ScrollController(),
          currentUser: ChatUser(id: currentUser.id, name: currentUser.name),
          otherUsers: [
            ChatUser(
              id: currentUser.id == widget.conversation.client.id
                  ? widget.conversation.provider.id
                  : widget.conversation.client.id,
              name: currentUser.id == widget.conversation.client.id
                  ? widget.conversation.provider.name
                  : widget.conversation.client.name,
              profilePhoto: currentUser.id == widget.conversation.client.id
                  ? widget.conversation.provider.profile
                  : widget.conversation.client.profile,
            ),
          ],
        );

        return previousMessages.when(
          data: (messages) {
            /// Load initial history ONCE
            _loadHistory(messages);

            return _buildChatUI(context, currentUser, theme);
          },

          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),

          error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
        );
      },

      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),

      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
    );
  }

  Widget _buildChatUI(
    BuildContext context,
    UserModel currentUser,
    ThemeData theme,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 24,
              // backgroundColor: theme.colorScheme.surfaceContainerHighest,09362988758
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  imageUrl: currentUser.id == widget.conversation.client.id
                      ? widget.conversation.provider.profile
                      : widget.conversation.client.profile,
                  errorWidget: (_, _, _) => Text(
                    textAlign: TextAlign.center,
                    currentUser.id == widget.conversation.client.id
                        ? widget.conversation.provider.name[0].toUpperCase()
                        : widget.conversation.client.name[0].toUpperCase(),
                    style: TextStyle(fontSize: 28),
                  ),
                ),
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

        chatViewState: ChatViewState.hasMessages,

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
          enableOtherUserName: true,
          enableScrollToBottomButton: true,
        ),

        sendMessageConfig: SendMessageConfiguration(
          replyMessageColor: theme.colorScheme.onSurface,
          replyTitleColor: theme.colorScheme.onSurface,
          defaultSendButtonColor: theme.colorScheme.primary,
          allowRecordingVoice: false, // Disable voice recording
          

          textFieldConfig: TextFieldConfiguration(
            hintText: "Type a message...",
            textStyle: theme.textTheme.bodyMedium,
            // padding: EdgeInsets.all(6),
            // margin: EdgeInsets.all(8)
          ),
        ),

        chatBubbleConfig: ChatBubbleConfiguration(
          outgoingChatBubbleConfig: ChatBubble(
            color: theme.colorScheme.primary,
            onMessageRead: (messageId) {
              // Implement logic to mark message as read using message ID
            },
            textStyle: TextStyle(color: theme.colorScheme.onPrimary),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(0),
            ),
          ),

          inComingChatBubbleConfig: ChatBubble(
            color: theme.colorScheme.secondaryContainer,
onMessageRead: (messageId) {
              // Implement logic to mark message as read using message ID
            },
            receiptsWidgetConfig: ReceiptsWidgetConfig(
              receiptsBuilder: (status) {
                switch (status) {
                  case MessageStatus.pending:
                    return Icon(
                      Icons.access_time,
                      size: 16,
                      color: theme.colorScheme.onSecondaryContainer,
                    );
                  case MessageStatus.delivered:
                    return Icon(
                      Icons.check,
                      size: 16,
                      color: theme.colorScheme.onSecondaryContainer,
                    );
                  case MessageStatus.read:
                    return Icon(
                      Icons.done_all,
                      size: 16,
                      color: theme.colorScheme.primary,
                    );
                  default:
                    return SizedBox.shrink();
                }
              },
              lastSeenAgoBuilder: (message, formattedDate) {
                return Text(
                  message.createdAt.difference(DateTime.now()).inMinutes < 1
                      ? "Just now"
                      : formattedDate,
                  style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                );
              },
            ),
            textStyle: TextStyle(color: theme.colorScheme.onSecondaryContainer),

            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(10),
            ),
          ),
        ),

        profileCircleConfig: ProfileCircleConfiguration(
          profileImageUrl: currentUser.id == widget.conversation.client.id
              ? widget.conversation.provider.profile
              : widget.conversation.client.profile,
          networkImageErrorBuilder: (_, _, _) => Text(
            currentUser.id == widget.conversation.client.id
                ? widget.conversation.provider.name[0].toUpperCase()
                : widget.conversation.client.name[0].toUpperCase(),
            style: TextStyle(fontSize: 28),
          ),
          networkImageProgressIndicatorBuilder: (_, _, _) =>
              const CircularProgressIndicator(),
          defaultAvatarImage: currentUser.id == widget.conversation.client.id
              ? widget.conversation.provider.name[0].toUpperCase()
              : widget.conversation.client.name[0].toUpperCase(),

        ),

        chatBackgroundConfig: ChatBackgroundConfiguration(
          backgroundColor: theme.colorScheme.surface,
          messageTimeTextStyle: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        emojiPickerSheetConfig: Config(),
        reactionPopupConfig: const ReactionPopupConfiguration(
          backgroundColor: Colors.white,
          shadow: BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 4),
            color: Colors.black26,
          ),
        ),
        messageConfig: MessageConfiguration(
          emojiMessageConfig: const EmojiMessageConfiguration(
            maxOutSideBubbleEmojis: 1,
          ),
          customMessageBuilder: (message) {
            return Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Link preview for: ${message.createdAt}",
                style: TextStyle(color: Colors.white),
              ),
            );
          },
          messageReactionConfig: MessageReactionConfiguration(
            backgroundColor: theme.colorScheme.surface,
            borderColor: theme.colorScheme.outline,
            borderWidth: 2,
            reactionsBottomSheetConfig: ReactionsBottomSheetConfiguration(
              backgroundColor: theme.colorScheme.surface,
              reactedUserTextStyle: TextStyle(
                color: theme.colorScheme.onSurface,
              ),
              reactionWidgetDecoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
            ),
           
          ),
        ),
        repliedMessageConfig: RepliedMessageConfiguration(
          backgroundColor: theme.colorScheme.surfaceContainerLow,
          verticalBarColor: theme.colorScheme.primary,
          textStyle: TextStyle(color: theme.colorScheme.onSurface),
          replyTitleTextStyle: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.secondary,
          ),
          loadOldReplyMessage: (id) async => {
            // Implement logic to fetch old replied message with surrounding context using message ID
          },
          repliedMsgAutoScrollConfig: RepliedMsgAutoScrollConfig(
            enableHighlightRepliedMsg: true,
            highlightScale: 1.1,
            highlightColor: theme.colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
      )
      
    );
  }
}
