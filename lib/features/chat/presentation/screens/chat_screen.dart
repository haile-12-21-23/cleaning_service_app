import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatview/chatview.dart';

import 'package:cleaning_service_app/features/chat/data/models/conversation_model.dart';
import 'package:cleaning_service_app/features/chat/presentation/providers/chat_controller.dart';
import 'package:cleaning_service_app/features/chat/presentation/providers/chat_stream_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final ConversationModel conversation;
  const ChatScreen({super.key, required this.conversation});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
   
}
class _ChatScreenState extends ConsumerState<ChatScreen> {
  late ChatController chatController;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(chatControllerProvider.notifier).connect(widget.conversation.id);
    });
    chatController = ChatController(
      initialMessageList: [],
      scrollController: ScrollController(),
      otherUsers: [],
      currentUser: ChatUser(
        id: widget.conversation.client.id,
        name: widget.conversation.client.name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final messages = ref.watch(chatMessagesProvider(widget.conversation.id));
    // chatController.updateMessage(messageId: messageId, newMessage: newMessage);

    chatController.loadMoreData(
      direction: ChatPaginationDirection.previous,
      messages,
    );
   
      
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              child: CachedNetworkImage(
                imageUrl: widget.conversation.provider.profile,
                errorWidget: (context, url, error) {
                  return Icon(Icons.person);
                },
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.conversation.provider.name),
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
        chatController: chatController,
        chatViewState: ChatViewState.hasMessages,

        onSendTap: (message, replyMessage, messageType) {
          ref
              .read(chatControllerProvider.notifier)
              .sendMessage(widget.conversation.client.id, message);
        },
        featureActiveConfig: const FeatureActiveConfig(
          enableSwipeToReply: true,
          enableReplySnackBar: true,
          enablePagination: true,
          enableReactionPopup: true,
          enableCurrentUserProfileAvatar: true,
          enableOtherUserProfileAvatar: true,
        ),

        sendMessageConfig: SendMessageConfiguration(
          textFieldBackgroundColor: theme.colorScheme.surface.withValues(
            alpha: 0.9,
          ),
          textFieldConfig: TextFieldConfiguration(
            hintText: "Type your message...",
            textStyle: theme.textTheme.bodyMedium,
          ),
        ),

        chatBubbleConfig: ChatBubbleConfiguration(
          outgoingChatBubbleConfig: ChatBubble(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
            textStyle: theme.textTheme.bodyMedium,
          ),
          inComingChatBubbleConfig: ChatBubble(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(16),
            textStyle: theme.textTheme.bodyMedium,
          ),
        ),

        swipeToReplyConfig: SwipeToReplyConfiguration(
          replyIconColor: theme.colorScheme.primary,
        ),
        repliedMessageConfig: RepliedMessageConfiguration(
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          verticalBarColor: theme.colorScheme.primary,
          repliedMsgAutoScrollConfig: const RepliedMsgAutoScrollConfig(
            enableHighlightRepliedMsg: true,
            highlightColor: Colors.grey,
          ),
          textStyle: TextStyle(color: theme.colorScheme.surface),
          replyTitleTextStyle: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),

          loadOldReplyMessage: (id) async => {},
        ),
        typeIndicatorConfig: TypeIndicatorConfiguration(
          flashingCircleBrightColor: theme.colorScheme.primary,
          flashingCircleDarkColor: theme.colorScheme.secondary,
        ),

        messageConfig: MessageConfiguration(
          messageReactionConfig: MessageReactionConfiguration(
            backgroundColor: theme.colorScheme.surface,
            borderColor: theme.colorScheme.outline,
            reactedUserCountTextStyle: TextStyle(
              color: theme.colorScheme.onSurface,
            ),
          ),
          imageMessageConfig: ImageMessageConfiguration(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          ),
        ),
        replyPopupConfig: ReplyPopupConfiguration(
          backgroundColor: theme.colorScheme.surface,
          buttonTextStyle: TextStyle(color: theme.colorScheme.primary),
        ),
        chatBackgroundConfig: ChatBackgroundConfiguration(
          backgroundColor: theme.colorScheme.surface,
        ),
        scrollToBottomButtonConfig: ScrollToBottomButtonConfig(
          backgroundColor: theme.colorScheme.primary,
        ),
        loadingWidget: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

}
