import 'package:flutter/material.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/Models/UserInfoModel.dart';
import 'package:textpop/Models/WebSocketModel.dart';
import 'package:textpop/Navigation/ChatNavigation.dart';
import 'package:textpop/Services/UsefulWidget/ToastBar.dart';
import 'package:textpop/Services/WebServer/ChatUser.dart';

class ChatUserViewModel extends ChangeNotifier {
  
  AppDataModel AppData;

  WebSocketModel WebSocket;

  Function(String OtherUserId) ResetUnseenMessageCount;

  TextEditingController UsernameController;

  List<UserInfoModel> UsersFromSearchResult = List.empty(growable: true);

  ChatUserViewModel(
    this.AppData, this.WebSocket, this.ResetUnseenMessageCount, this.UsernameController);


  ///Search user containing the keywords
  Future<void> SearchUser(String username) async{

    if (username.isEmpty){
      return;
    }

    var response = await ChatUser().SearchUser(AppData.AppToken, username);
    if (response.statusCode == 417 || response.statusCode != 200){
      ToastBar.ShowMessage(AppData.SelectedLanguage.FailToConnectToServer());
      return;
    }

    List<dynamic>? userInfoList = response.data;
    if(userInfoList == null || userInfoList.isEmpty){
      ToastBar.ShowMessage(AppData.SelectedLanguage.ChatUserPage_UserNotFound());
      return;
    }

    UsersFromSearchResult.clear();
    for(var userInfo in userInfoList){
      UsersFromSearchResult.add(UserInfoModel(userInfo["id"], userInfo["username"]));
    }

    notifyListeners();
  } 


  ///Push to ChatRoomPage
  void EnterConversation(BuildContext context, UserInfoModel OtherUser){
    ChatNavigation.ChatRoomPagePushReplacement(context, AppData, OtherUser, WebSocket, ResetUnseenMessageCount, null);
  }
}