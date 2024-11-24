import 'package:dio/dio.dart';

class ConnectionOption {
  // static const String ServerDomain = "http://192.168.50.111:5000/";
  static const String ServerDomain = "https://textpop.superwch1.com/";
  static const String TurnServerDomain = "turn.superwch1.com:3478";

  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 10)
    )
  );

  String FacebookLoginUrl = "${ServerDomain}Account/LoginWithFacebookToken";
  String GoogleLoginUrl = "${ServerDomain}Account/LoginWithGoogleToken";
  String AppleLoginUrl = "${ServerDomain}Account/LoginWithAppleToken";

  String UpdateUserInfoUrl = "${ServerDomain}Account/UpdateUserInfo";
  String UpdateUserInfoWithoutImageUrl = "${ServerDomain}Account/UpdateUserInfoWithoutImage";

  String UserLoginUrl = "${ServerDomain}Account/UserLogin";
  String AvatarUrl(String userId) => "${ServerDomain}Account/ReadUserAvatar?userId=$userId";

  String SearchUserUrl = "${ServerDomain}Account/SearchUser";


  String ReadMessageBeforeEarliestMessageUrl = "${ServerDomain}Chat/ReadMessageBeforeEarliestMessage";
  String ReadLatestMessageUrl = "${ServerDomain}Chat/ReadLatestMessage";
  String ReadMessageAfterInitialMessageUrl = "${ServerDomain}Chat/ReadMessageAfterInitialMessage";
  String ReadImageFromMessageUrl(String id) => "${ServerDomain}Chat/ReadImageFromMessage?id=$id";
  String ReadAllConversationUrl = "${ServerDomain}Chat/ReadAllConversation";
  String ReadUnseenConversationUrl = "${ServerDomain}Chat/ReadUnseenConversation";
  String DeleteMessageUrl = "${ServerDomain}Chat/DeleteMessage";

  String SendTextMessageUrl = "${ServerDomain}Chat/CreateTextMessage";
  String SendImageMessageUrl = "${ServerDomain}Chat/CreateImageMessage";
  String ReportMessageUrl = "${ServerDomain}Chat/ReportMessage";
  String CreateVideoCallUrl = "${ServerDomain}Chat/CreateVideoCall";
  String BlockOrUnblockUserUrl = "${ServerDomain}Account/BlockOrUnblockUser";

  String DeleteAllImageUrl = "${ServerDomain}Chat/DeleteAllImage";
  String DeleteAllMessageUrl = "${ServerDomain}Chat/DeleteAllMessage";
  String DeleteUserUrl = "${ServerDomain}Account/DeleteUser";
  String UserLogoutUrl = "${ServerDomain}Account/UserLogout";

  String PrivacyPolicyUrl = "${ServerDomain}Policy/PrivacyPolicy";
  String TermsAndConditionsUrl = "${ServerDomain}Policy/TermsAndConditions";

  String ChatHubUrl() => "${ServerDomain}ChatHub";
}