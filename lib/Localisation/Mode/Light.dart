import 'dart:ui';
import 'package:textpop/Localisation/Mode/Mode.dart';


class Light implements Mode {
  @override
  Color AppBackground() => const Color.fromARGB(255, 246, 189, 96);
  @override
  Color BorderColor() => const Color.fromARGB(255, 247, 237, 226);
  @override
  Color BannerBackground() => const Color.fromARGB(255, 255, 226, 178);

  @override
  Color AccountPolicyFontColor() => const Color.fromARGB(255, 255, 255, 255);
  @override
  Color ChatBackground() => const Color.fromARGB(255, 247, 237, 226);
  @override
  Color MyMessageBackground() => const Color.fromARGB(255, 132, 165, 157);
  @override
  Color MyMessageFontColor() => const Color.fromARGB(255, 250, 255, 254);
  @override
  Color OtherMessageBackground() => const Color.fromARGB(255, 203, 220, 216);
  @override
  Color OtherMessageFontColor() => const Color.fromARGB(255, 82, 68, 68);
  @override
  Color ChatInputTextColor() => const Color.fromARGB(255, 82, 68, 68);
  @override
  Color ChatInputBackground() => const Color.fromARGB(255, 221, 216, 211);
  @override
  Color ChatUnseenCountTextColor() => const Color.fromARGB(255, 247, 237, 226);
  @override
  Color ChatMessageOptionBackground() => const Color.fromARGB(255, 255, 249, 243);
  @override
  Color ChatMessageOptionFocus() => const Color.fromARGB(255, 249, 189, 96);


  @override
  Color ButtonBackground() => const Color.fromARGB(255, 255, 226, 178);
  @override
  Color ButtonFocusBackground() => const Color.fromARGB(255, 247, 237, 226);
  @override
  Color ConversationButtonBackground() => const Color.fromARGB(255, 247, 237, 226);
  @override
  Color ConfirmButtonBackground() => const Color.fromARGB(255, 132, 165, 157);
  @override
  Color MiscAButtonBackground() => const Color.fromARGB(255, 132, 165, 157);
  @override
  Color MiscBButtonBackground() => const Color.fromARGB(255, 242, 132, 130);
  @override
  Color VideoChatButtonBackground() => const Color.fromARGB(100, 255, 255, 255);
  @override
  Color LeaveVideoChatButtonBackground() => const Color.fromARGB(255, 253, 59, 47);


  @override
  Color InputBackground() => const Color.fromARGB(255, 255, 226, 178);
  @override
  Color TextColor() => const Color.fromARGB(255, 82, 68, 68);
  
  @override
  Color PolicyBackground() => const Color.fromARGB(255, 251, 248, 246);
  @override
  Color PolicyBorderColor() => const Color.fromARGB(255, 172, 160, 155);

  @override
  String ArrowBackPath() => "assets/Images/Light/ArrowBack.png";
  @override
  String LoginCubePath() => "assets/Images/Light/Account/LoginCube.png";
  @override
  String FacebookLogoPath() => "assets/Images/Light/Account/FacebookLogo.png";
  @override
  String AppleLogoPath() => "assets/Images/Light/Account/AppleLogo.png";
  @override
  String GoogleLogoPath() => "assets/Images/Light/Account/GoogleLogo.png";
  @override
  String AvatarPath() => "assets/Images/Light/Account/Avatar.png";
  @override
  String RightArrowPath() => "assets/Images/Light/Account/RightArrow.png";
  @override
  String ImageIconPath() => "assets/Images/Light/Account/ImageIcon.png";
  @override
  String SettingPath() => "assets/Images/Light/Chat/Setting.png";
  @override
  String PencilPath() => "assets/Images/Light/Chat/Pencil.png";
  @override
  String BanPath() => "assets/Images/Light/Chat/Ban.png";
  @override
  String LeaveVideoChatPath() => "assets/Images/Light/Chat/LeaveVideoChat.png";
  @override
  String EnterVideoChatPath() => "assets/Images/Light/Chat/EnterVideoChat.png";
  @override
  String SwitchCameraPath() => "assets/Images/Light/Chat/SwitchCamera.png";
  @override
  String AudioTrackOffPath() => "assets/Images/Light/Chat/AudioTrackOff.png";
  @override
  String VideoTrackOffPath() => "assets/Images/Light/Chat/VideoTrackOff.png";
  @override
  String AudioTrackOnPath() => "assets/Images/Light/Chat/AudioTrackOn.png";
  @override
  String VideoTrackOnPath() => "assets/Images/Light/Chat/VideoTrackOn.png";
  @override
  String ModePath() => "assets/Images/Light/Setting/Mode.png";
  @override
  String LangaugePath() => "assets/Images/Light/Setting/Language.png";
  @override
  String AboutPath() => "assets/Images/Light/Setting/About.png";
  @override
  String DeletePath() => "assets/Images/Light/Setting/Delete.png";
  @override
  String LogoutPath() => "assets/Images/Light/Setting/Logout.png";
  @override
  String PrivacyPolicyPath() => "assets/Images/Light/Setting/PrivacyPolicy.png";
  @override
  String TermsAndConditionPath() => "assets/Images/Light/Setting/TermsAndConditions.png";
}