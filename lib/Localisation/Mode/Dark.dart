import 'package:flutter/material.dart';
import 'package:textpop/Localisation/Mode/Mode.dart';

class Dark implements Mode {
  @override
  Color AppBackground() => const Color.fromARGB(255, 45, 39, 39);
  @override
  Color BorderColor() => const Color.fromARGB(255, 240, 239, 214);
  @override
  Color BannerBackground() => const Color.fromARGB(255, 98, 106, 120);


  @override
  Color AccountPolicyFontColor() => const Color.fromARGB(255, 240, 235, 141);
  @override
  Color ChatBackground() => const Color.fromARGB(255, 57, 62, 70);
  @override
  Color MyMessageBackground() => const Color.fromARGB(255, 240, 235, 141);
  @override
  Color MyMessageFontColor() => const Color.fromARGB(255, 45, 39, 39);
  @override
  Color OtherMessageBackground() => const Color.fromARGB(255, 240, 239, 216);
  @override
  Color OtherMessageFontColor() => const Color.fromARGB(255, 45, 39, 39);
  @override
  Color ChatInputTextColor() => const Color.fromARGB(255, 45, 39, 39);
  @override
  Color ChatInputBackground() => const Color.fromARGB(255, 240, 239, 216);
  @override
  Color ChatUnseenCountTextColor() => const Color.fromARGB(255, 45, 39, 39);
  @override
  Color ChatMessageOptionBackground() => const Color.fromARGB(255, 255, 249, 243);
  @override
  Color ChatMessageOptionFocus() => const Color.fromARGB(255, 240, 235, 141);


  @override
  Color ButtonBackground() => const Color.fromARGB(255, 57, 62, 70);
  @override
  Color ButtonFocusBackground() => const Color.fromARGB(255, 240, 235, 141);
  @override
  Color ConversationButtonBackground() => const Color.fromARGB(255, 57, 62, 70);
  @override
  Color ConfirmButtonBackground() => const Color.fromARGB(255, 45, 39, 39);
  @override
  Color MiscAButtonBackground() => const Color.fromARGB(255, 98, 106, 120);
  @override
  Color MiscBButtonBackground() => const Color.fromARGB(255, 240, 235, 141);
  @override
  Color VideoChatButtonBackground() => const Color.fromARGB(100, 255, 255, 255);
  @override
  Color LeaveVideoChatButtonBackground() => const Color.fromARGB(255, 253, 59, 47);


  @override
  Color InputBackground() => const Color.fromARGB(255, 98, 106, 120);
  @override
  Color TextColor() => const Color.fromARGB(255, 255, 255, 255);

  @override
  Color PolicyBackground() => const Color.fromARGB(255, 57, 62, 70);
  @override
  Color PolicyBorderColor() => const Color.fromARGB(255, 255, 255, 255);

  @override
  String ArrowBackPath() => "assets/Images/Dark/ArrowBack.png";
  @override
  String LoginCubePath() => "assets/Images/Dark/Account/LoginCube.png";
  @override
  String FacebookLogoPath() => "assets/Images/Dark/Account/FacebookLogo.png";
  @override
  String AppleLogoPath() => "assets/Images/Dark/Account/AppleLogo.png";
  @override
  String GoogleLogoPath() => "assets/Images/Dark/Account/GoogleLogo.png";
  @override
  String AvatarPath() => "assets/Images/Dark/Account/Avatar.png";
  @override
  String RightArrowPath() => "assets/Images/Dark/Account/RightArrow.png";
  @override
  String ImageIconPath() => "assets/Images/Dark/Account/ImageIcon.png";
  @override
  String SettingPath() => "assets/Images/Dark/Chat/Setting.png";
  @override
  String PencilPath() => "assets/Images/Dark/Chat/Pencil.png";
  @override
  String BanPath() => "assets/Images/Dark/Chat/Ban.png";
  @override
  String LeaveVideoChatPath() => "assets/Images/Dark/Chat/LeaveVideoChat.png";
  @override
  String EnterVideoChatPath() => "assets/Images/Dark/Chat/EnterVideoChat.png";
  @override
  String SwitchCameraPath() => "assets/Images/Dark/Chat/SwitchCamera.png";
  @override
  String AudioTrackOffPath() => "assets/Images/Dark/Chat/AudioTrackOff.png";
  @override
  String VideoTrackOffPath() => "assets/Images/Dark/Chat/VideoTrackOff.png";
  @override
  String AudioTrackOnPath() => "assets/Images/Dark/Chat/AudioTrackOff.png";
  @override
  String VideoTrackOnPath() => "assets/Images/Dark/Chat/VideoTrackOff.png";
  @override
  String ModePath() => "assets/Images/Dark/Setting/Mode.png";
  @override
  String LangaugePath() => "assets/Images/Dark/Setting/Language.png";
  @override
  String AboutPath() => "assets/Images/Dark/Setting/About.png";
  @override
  String DeletePath() => "assets/Images/Dark/Setting/Delete.png";
  @override
  String LogoutPath() => "assets/Images/Dark/Setting/Logout.png";
  @override
  String PrivacyPolicyPath() => "assets/Images/Dark/Setting/PrivacyPolicy.png";
  @override
  String TermsAndConditionPath() => "assets/Images/Dark/Setting/TermsAndConditions.png";
}