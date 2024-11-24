import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class CustomizeChatTheme extends ChatTheme {
  /// Creates a default chat theme. Use this constructor if you want to
  /// override only a couple of properties, otherwise create a new class
  /// which extends [ChatTheme].
  const CustomizeChatTheme({
    super.attachmentButtonIcon,
    super.attachmentButtonMargin,
    super.backgroundColor = neutral7,
    super.dateDividerMargin = const EdgeInsets.only(
      bottom: 32,
      top: 16,
    ),
    super.dateDividerTextStyle = const TextStyle(
      color: neutral2,
      fontSize: 12,
      fontWeight: FontWeight.w800,
      height: 1.333,
    ),
    super.deliveredIcon,
    super.documentIcon,
    super.emptyChatPlaceholderTextStyle = const TextStyle(
      color: neutral2,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
    super.errorColor = error,
    super.errorIcon,
    super.inputBackgroundColor = neutral0,
    super.inputBorderRadius = const BorderRadius.vertical(
      top: Radius.circular(20),
    ),
    super.inputContainerDecoration,
    super.inputMargin = EdgeInsets.zero,
    super.inputPadding = const EdgeInsets.fromLTRB(24, 20, 24, 20),
    super.inputTextColor = neutral7,
    super.inputTextCursorColor,
    super.inputTextDecoration = const InputDecoration(
      border: InputBorder.none,
      contentPadding: EdgeInsets.zero,
      isCollapsed: true,
    ),
    super.inputTextStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
    super.messageBorderRadius = 20,
    super.messageInsetsHorizontal = 20,
    super.messageInsetsVertical = 16,
    super.primaryColor = primary,
    super.receivedEmojiMessageTextStyle = const TextStyle(fontSize: 40),
    super.receivedMessageBodyBoldTextStyle,
    super.receivedMessageBodyCodeTextStyle,
    super.receivedMessageBodyLinkTextStyle,
    super.receivedMessageBodyTextStyle = const TextStyle(
      color: neutral0,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
    super.receivedMessageCaptionTextStyle = const TextStyle(
      color: neutral2,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.333,
    ),
    super.receivedMessageDocumentIconColor = primary,
    required super.receivedMessageLinkDescriptionTextStyle, 
    /* = const TextStyle(
      color: neutral0,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.428,
    ), */
    required super.receivedMessageLinkTitleTextStyle,
    /* = const TextStyle(
      color: neutral0,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      height: 1.375,
    ), */
    super.secondaryColor = secondary,
    super.seenIcon,
    super.sendButtonIcon,
    super.sendButtonMargin,
    super.sendingIcon,
    super.sentEmojiMessageTextStyle = const TextStyle(fontSize: 40),
    super.sentMessageBodyBoldTextStyle,
    super.sentMessageBodyCodeTextStyle,
    super.sentMessageBodyLinkTextStyle,
    super.sentMessageBodyTextStyle = const TextStyle(
      color: neutral7,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
    super.sentMessageCaptionTextStyle = const TextStyle(
      color: neutral7WithOpacity,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.333,
    ),
    super.sentMessageDocumentIconColor = neutral7,
    required super.sentMessageLinkDescriptionTextStyle,
    /* = const TextStyle(
      color: neutral7,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.428,
    ), */
    required super.sentMessageLinkTitleTextStyle,
    /* = const TextStyle(
      color: neutral7,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      height: 1.375,
    ), */
    super.statusIconPadding = const EdgeInsets.symmetric(horizontal: 4),
    super.systemMessageTheme = const SystemMessageTheme(
      margin: EdgeInsets.only(
        bottom: 24,
        top: 8,
        left: 8,
        right: 8,
      ),
      textStyle: TextStyle(
        color: neutral2,
        fontSize: 12,
        fontWeight: FontWeight.w800,
        height: 1.333,
      ),
    ),
    super.typingIndicatorTheme = const TypingIndicatorTheme(
      animatedCirclesColor: neutral1,
      animatedCircleSize: 5.0,
      bubbleBorder: BorderRadius.all(Radius.circular(27.0)),
      bubbleColor: neutral7,
      countAvatarColor: primary,
      countTextColor: secondary,
      multipleUserTextStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: neutral2,
      ),
    ),
    super.unreadHeaderTheme = const UnreadHeaderTheme(
      color: secondary,
      textStyle: TextStyle(
        color: neutral2,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.333,
      ),
    ),
    super.userAvatarImageBackgroundColor = Colors.transparent,
    super.userAvatarNameColors = colors,
    super.userAvatarTextStyle = const TextStyle(
      color: neutral7,
      fontSize: 12,
      fontWeight: FontWeight.w800,
      height: 1.333,
    ),
    super.userNameTextStyle = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w800,
      height: 1.333,
    ), required super.inputSurfaceTintColor, required super.inputElevation, required super.messageMaxWidth,
  });
}