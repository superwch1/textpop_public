import 'package:flutter/material.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/Models/UserInfoModel.dart';
import 'package:textpop/Models/WebSocketModel.dart';
import 'package:textpop/Navigation/AccountNavigation.dart';
import 'package:textpop/Pages/Chat/ChatRoomPage/ChatRoomPage.dart';
import 'package:textpop/Pages/Chat/ChatSelectionPage/ChatSelectionPage.dart';
import 'package:textpop/Pages/Chat/ChatUserPage/ChatUserPage.dart';
import 'package:textpop/Pages/Chat/VideoChatPage/VideoChatPage.dart';
import 'package:textpop/Services/UsefulWidget/ToastBar.dart';
import 'package:textpop/ViewModels/Chat/ChatSelectionViewModel.dart';

class ChatNavigation {
  
  static void ChatSelectionPagePushReplacement(BuildContext context, AppDataModel appData,
    String? otherUserId, bool? navigateToVideoCall){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ChatSelectionPage(appData, otherUserId, navigateToVideoCall),
      ),
    );
  }


  static void ChatRoomPagePush(BuildContext context, AppDataModel appData, UserInfoModel OtherUser, 
  WebSocketModel webSocket, Function(String OtherUserId) resetUnseenMessageCount, bool? navigateToVideoCall) { 
    
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ChatRoomPage(appData, OtherUser, webSocket, navigateToVideoCall)
      ),
    ).then((value) => resetUnseenMessageCount(OtherUser.Id));
    //resetUnseenCount() inside then() and not place into function of EnterConversation
    //prevent showing widgets rebuild while loading into conversation
  }


  static void ChatRoomPagePushReplacement(BuildContext context, AppDataModel appData, UserInfoModel otherUser, 
    WebSocketModel webSocket, Function(String OtherUserId) resetUnseenMessageCount, bool? navigateToVideoCall) { 
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ChatRoomPage(appData, otherUser, webSocket, navigateToVideoCall)
      ),
    ).then((value) => resetUnseenMessageCount(otherUser.Id));
    //resetUnseenCount() inside then() and not place into function of EnterConversation
    //prevent showing widgets rebuild while loading into conversation   
  }


  static void ChatUserPagePush(BuildContext context, AppDataModel appData,
    WebSocketModel webSocket, Function(String OtherUserId) resetUnseenMessageCount) { 
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ChatUserPage(appData, webSocket, resetUnseenMessageCount)
      ),
    );
  }

  static void ChatRoomPageFromNotification(BuildContext context, AppDataModel appData, ChatSelectionViewModel? viewModel, 
    String otherUserId, bool? navigateToVideoCall) async{
    Navigator.of(context).popUntil((route) => route.isFirst);
    if(viewModel != null){
      ChatNavigation.ChatSelectionPagePushReplacement(context, appData, otherUserId, navigateToVideoCall);
    }
    else {
      ToastBar.ShowMessage(appData.SelectedLanguage.FailToConnectToServer());
      return AccountNavigation.AccountLoginPagePushReplacement(context, appData.SelectedLanguage, appData.SelectedMode);
    }
  }

  static void VideoChatPagePush(BuildContext context, AppDataModel appData,
    UserInfoModel otherUser, WebSocketModel webSocket) { 
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => VideoChatPage(appData, otherUser, webSocket)
      ),
    );
  }
}