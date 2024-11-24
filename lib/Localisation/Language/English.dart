import 'package:textpop/Localisation/Language/Langauge.dart';

class English implements Language {
  @override
  String FailToConnectToServer() => "Fail to connect to server";

  //AccountLogin
  @override
  String AccountLoginPage_WelcomeBanner() => "TextPop"; 
  @override
  String AccountLoginPage_LoginProvider(String provider) => "Continue with $provider";
  @override
  String AccountLoginPage_LoggingIn() => "Logging in";
  @override
  String AccountLoginPage_FailToLoginWithProvider(String provider) => "Cannot login with $provider";

  //AccountInfo
  @override
  String AccountInfoPage_UpdateInfoBanner() => "Upload Avatar";
  @override
  String AccountInfoPage_UsernameInput() => "Enter username";
  @override
  String AccountInfoPage_ChoosePhoto() => "Choose avatar";
  @override
  String AccountInfoPage_UsernameLengthRequirement() => "Length must be within 4-10 letters";
  @override
  String AccountInfoPage_UsernameCharacterRequirement() => "Char must be composed with letters or symbols ><@_.-";
  @override
  String AccountInfoPage_UserInfoUpdated() => "Info Updated";

  //ChatSelection
  @override
  String ChatSelectionPage_MessageDeleted() => "[Message Deleted]";
  @override
  String ChatSelectionPage_ImageMessage() => "[Image]";

  //ChatRoom
  @override
  String ChatRoomPage_EmptyChat() => "Empty chat";
  @override
  String ChatRoomPage_SendMedia() => "Send Media";
  @override
  String ChatRoomPage_Attachment() => "File";
  @override
  String ChatRoomPage_MessageInput() => "Enter message";
  @override
  String ChatRoomPage_Send() => "Send";
  @override
  String ChatRoomPage_UnseenMessage() => "Unseen message";
  @override
  String ChatRoomViewMode_FailToSendMessage() => "Fail to send message";
  @override
  String ChatRoomViewMode_FailToCreateCall() => "Fail to create video call";
  @override
  String ChatRoomPage_ChoosePhoto() => "Choose Photo";
  @override
  String ChatRoomPage_CopyOption() => "Copy";
  @override
  String ChatRoomPage_DownloadOption() => "Save";
  @override
  String ChatRoomPage_ShareOption() => "Share";
  @override
  String ChatRoomPage_DeleteOption() => "Delete";
  @override
  String ChatRoomPage_ReportOption() => "Report";
  @override
  String ChatRoomPage_MessageCopied() => "Message Copied";
  @override
  String ChatRoomPage_MessageDeleted() => "Message Deleted";
  @override
  String ChatRoomPage_SendingReport() => "Sending report, please wait for a moment.";
  @override
  String ChatRoomPage_MessageReported() => "Message Reported, abusive user will be removed.";
  @override
  String ChatRoomPage_UserBlocked() => "User Blocked";
  @override
  String ChatRoomPage_UserUnblocked() => "User Unblocked";

  //ChatUser
  @override
  String ChatUserPage_AddConversationBanner() => "New Chat";
  @override
  String ChatUserPage_SearchUser() => "Search User";
  @override
  String ChatUserPage_UserNotFound() => "User Not Found";

  //VideoChat
  @override
  String VideoChatPage_ConnectionLost() => "Connection Lost";

  //SettingSelection
  @override
  String SettingSelection_SettingBanner() => "Setting";
  @override
  String SettingSelection_Mode(String mode) => "Mode - $mode";
  @override
  String SettingSelection_Language() => "Language - English";
  @override
  String SettingSelection_About() => "About";
  @override
  String SettingSelection_DeleteAccount() => "Delete Account";
  @override
  String SettingSelection_Logout() => "Log out";
  @override
  String SettingSelection_AccountDeleted() => "Account Deleted";
  @override
  String SettingSelection_AccountLoggedOut() => "Logged Out";
  @override
  String SettingSelection_ModeChanged() => "Mode Changed";
  @override
  String SettingSelection_LanguageChanged() => "Language Changed";

  //Notification
  @override
  String Notification_Image() => "[Image]";
  @override
  String Notification_Title() => "TextPop";
  @override
  String Notification_NumberOfMessages(int number) => "$number messages";
  @override
  String Notification_NumberOfConversations(int number)=> "$number conversations";
  @override
  String Notification_NumberOfRemainingConversations(int number) => "Other $number conversations";
  @override
  String AccountLoginPage_AcceptPolicyText() => "By register, you agree to our ";
  @override
  String AccountLoginPage_AndText() => " and ";


  //SettingAbout
  @override
  String SettingAbout_PrivacyPolicy() => "Privacy Policy";
  @override
  String SettingAbout_TermsAndCondition() => "Terms And Conditions";

  //Other
  @override
  String Other_ImageSaved() => "Image Saved";

  @override
  String toString() {
    return "English";
  }
}