import 'package:flutter/material.dart';

abstract class Mode {
  Color AppBackground();
  Color BorderColor();
  Color BannerBackground();

  Color AccountPolicyFontColor();
  Color ChatBackground();
  Color MyMessageBackground();
  Color MyMessageFontColor();
  Color OtherMessageBackground();
  Color OtherMessageFontColor();
  Color ChatInputTextColor();
  Color ChatInputBackground();
  Color ChatUnseenCountTextColor();
  Color ChatMessageOptionBackground();
  Color ChatMessageOptionFocus();

  Color ButtonBackground();
  Color ButtonFocusBackground();
  Color ConversationButtonBackground();
  Color ConfirmButtonBackground();
  Color MiscAButtonBackground();
  Color MiscBButtonBackground();
  Color VideoChatButtonBackground();
  Color LeaveVideoChatButtonBackground();

  Color InputBackground();
  Color TextColor();

  Color PolicyBackground();
  Color PolicyBorderColor();

  String ArrowBackPath();
  String LoginCubePath();
  String FacebookLogoPath();
  String AppleLogoPath();
  String GoogleLogoPath();
  String AvatarPath();
  String RightArrowPath();
  String ImageIconPath();
  String SettingPath();
  String PencilPath();
  String BanPath();
  String LeaveVideoChatPath();
  String EnterVideoChatPath();
  String SwitchCameraPath();
  String AudioTrackOffPath();
  String VideoTrackOffPath();
  String AudioTrackOnPath();
  String VideoTrackOnPath();
  String ModePath();
  String LangaugePath();
  String AboutPath();
  String DeletePath();
  String LogoutPath();
  String PrivacyPolicyPath();
  String TermsAndConditionPath();
}