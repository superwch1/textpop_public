import 'package:textpop/Localisation/Language/Langauge.dart';

class Chinese implements Language {
  @override
  String FailToConnectToServer() => "未能連接至伺服器";

  //AccountLogin
  @override
  String AccountLoginPage_WelcomeBanner() => "TextPop"; 
  @override
  String AccountLoginPage_LoginProvider(String provider) => "使用 $provider 繼續";
  @override
  String AccountLoginPage_LoggingIn() => "登入中";
  @override
  String AccountLoginPage_FailToLoginWithProvider(String provider) => "未能登入至 $provider 賬戶";
  @override
  String AccountLoginPage_AcceptPolicyText() => "註冊代表你同意 ";
  @override
  String AccountLoginPage_AndText() => " 及 ";

  //AccountInfo
  @override
  String AccountInfoPage_UpdateInfoBanner() => "笨笨樣 Upload";
  @override
  String AccountInfoPage_UsernameInput() => "輸入你的用戶名稱";
  @override
  String AccountInfoPage_ChoosePhoto() => "選擇頭像";
  @override
  String AccountInfoPage_UsernameLengthRequirement() => "名稱長度在4-10字之內";
  @override
  String AccountInfoPage_UsernameCharacterRequirement() => "只能由英文或數字或符號><@_.-組成";
  @override
  String AccountInfoPage_UserInfoUpdated() => "已更新資料";

  //ChatSelection
  @override
  String ChatSelectionPage_MessageDeleted() => "[訊息己刪除]";
  @override
  String ChatSelectionPage_ImageMessage() => "[相片]";

  //ChatRoom
  @override
  String ChatRoomPage_EmptyChat() => "未有收到訊息";
  @override
  String ChatRoomPage_SendMedia() => "傳送媒體";
  @override
  String ChatRoomPage_Attachment() => "檔案";
  @override
  String ChatRoomPage_MessageInput() => "輸入訊息";
  @override
  String ChatRoomPage_Send() => "傳送";
  @override
  String ChatRoomPage_UnseenMessage() => "未讀訊息";
  @override
  String ChatRoomViewMode_FailToSendMessage() => "未能傳送訊息";
  @override
  String ChatRoomViewMode_FailToCreateCall() => "未能展開視像對話";
  @override
  String ChatRoomPage_ChoosePhoto() => "選擇相片";
  @override
  String ChatRoomPage_CopyOption() => "複製";
  @override
  String ChatRoomPage_DownloadOption() => "下載";
  @override
  String ChatRoomPage_ShareOption() => "分享";
  @override
  String ChatRoomPage_DeleteOption() => "刪除";
  @override
  String ChatRoomPage_ReportOption() => "檢舉";
  @override
  String ChatRoomPage_MessageCopied() => "已複製訊息";
  @override
  String ChatRoomPage_MessageDeleted() => "已刪除訊息";
  @override
  String ChatRoomPage_SendingReport() => "檢舉傳送中 請你耐心等候";
  @override
  String ChatRoomPage_MessageReported() => "已檢舉訊息 不合當的用戶將會被移除";
  @override
  String ChatRoomPage_UserBlocked() => "已封鎖用戶";
  @override
  String ChatRoomPage_UserUnblocked() => "已解除封鎖";

  //ChatUser
  @override
  String ChatUserPage_AddConversationBanner() => "新訊息";
  @override
  String ChatUserPage_SearchUser() => "想同邊個傾計？";
  @override
  String ChatUserPage_UserNotFound() => "未能找到用戶";

  //VideoChat
  @override
  String VideoChatPage_ConnectionLost() => "與用戶失連線";

  //SettingSelection
  @override
  String SettingSelection_SettingBanner() => "設定";
  @override
  String SettingSelection_Mode(String mode) => "模式 - $mode";
  @override
  String SettingSelection_Language() => "語言 - 中文";
  @override
  String SettingSelection_About() => "關於";
  @override
  String SettingSelection_DeleteAccount() => "刪除賬戶";
  @override
  String SettingSelection_Logout() => "登出";
  @override
  String SettingSelection_AccountDeleted() => "已刪除賬戶";
  @override
  String SettingSelection_AccountLoggedOut() => "已登出賬戶";
  @override
  String SettingSelection_ModeChanged() => "已轉換模式";
  @override
  String SettingSelection_LanguageChanged() => "已轉換語言";

  //SettingAbout
  @override
  String SettingAbout_PrivacyPolicy() => "隱私權政策";
  @override
  String SettingAbout_TermsAndCondition() => "條款及細則";

  //Notification
  @override
  String Notification_Image() => "[圖片]";
  @override
  String Notification_Title() => "TextPop";
  @override
  String Notification_NumberOfMessages(int number) => "共收到$number個訊息";
  @override
  String Notification_NumberOfConversations(int number)=> "來自$number個對話";
  @override
  String Notification_NumberOfRemainingConversations(int number) => "其餘$number個對話";


  //Other
  @override
  String Other_ImageSaved() => "相片已儲存在裝置";

  @override
  String toString() {
    return "Chinese";
  }
}