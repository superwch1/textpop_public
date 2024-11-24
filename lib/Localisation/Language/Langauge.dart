abstract class Language {
  String FailToConnectToServer();

  //AccountLogin
  String AccountLoginPage_WelcomeBanner();
  String AccountLoginPage_LoginProvider(String provider);
  String AccountLoginPage_LoggingIn();
  String AccountLoginPage_FailToLoginWithProvider(String provider);
  String AccountLoginPage_AcceptPolicyText();
  String AccountLoginPage_AndText();

  //AccountInfo
  String AccountInfoPage_UpdateInfoBanner();
  String AccountInfoPage_UsernameInput();
  String AccountInfoPage_ChoosePhoto();
  String AccountInfoPage_UsernameLengthRequirement();
  String AccountInfoPage_UsernameCharacterRequirement();
  String AccountInfoPage_UserInfoUpdated();

  //ChatSelection
  String ChatSelectionPage_MessageDeleted();
  String ChatSelectionPage_ImageMessage();

  //ChatRoom
  String ChatRoomPage_EmptyChat();
  String ChatRoomPage_SendMedia();
  String ChatRoomPage_Attachment();
  String ChatRoomPage_MessageInput();
  String ChatRoomPage_Send();
  String ChatRoomPage_UnseenMessage();
  String ChatRoomViewMode_FailToSendMessage();
  String ChatRoomViewMode_FailToCreateCall();
  String ChatRoomPage_ChoosePhoto();
  String ChatRoomPage_CopyOption();
  String ChatRoomPage_DownloadOption();
  String ChatRoomPage_ShareOption();
  String ChatRoomPage_DeleteOption();
  String ChatRoomPage_ReportOption();
  String ChatRoomPage_MessageCopied();
  String ChatRoomPage_MessageDeleted();
  String ChatRoomPage_SendingReport();
  String ChatRoomPage_MessageReported();
  String ChatRoomPage_UserBlocked();
  String ChatRoomPage_UserUnblocked();

  //ChatUser
  String ChatUserPage_AddConversationBanner();
  String ChatUserPage_SearchUser();
  String ChatUserPage_UserNotFound();

  //VideoChat
  String VideoChatPage_ConnectionLost();

  //SettingSelection
  String SettingSelection_SettingBanner();
  String SettingSelection_Mode(String mode);
  String SettingSelection_Language();
  String SettingSelection_About();
  String SettingSelection_DeleteAccount();
  String SettingSelection_Logout();
  String SettingSelection_AccountDeleted();
  String SettingSelection_AccountLoggedOut();
  String SettingSelection_ModeChanged();
  String SettingSelection_LanguageChanged();

  //SettingAbout
  String SettingAbout_PrivacyPolicy();
  String SettingAbout_TermsAndCondition();

  //Notification
  String Notification_Image();
  String Notification_Title();
  String Notification_NumberOfMessages(int number);
  String Notification_NumberOfConversations(int number);
  String Notification_NumberOfRemainingConversations(int number);

  //Other
  String Other_ImageSaved();
}