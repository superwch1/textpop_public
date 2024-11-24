import 'package:flutter/material.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/Models/UserInfoModel.dart';
import 'package:textpop/Navigation/ChatNavigation.dart';
import 'package:textpop/Pages/Chat/ChatSelectionPage/ChatSelectionTempUI.dart';
import 'package:textpop/Pages/Chat/ChatSelectionPage/ChatSelectionUI.dart';
import 'package:textpop/Services/UsefulWidget/ToastBar.dart';
import 'package:textpop/ViewModels/Chat/ChatSelectionViewModel.dart';
import 'package:textpop/pages/Account/AccountLoginPage/AccountLoginPage.dart';

class ChatSelectionPage extends StatelessWidget{

  final AppDataModel AppData;

  final String? OtherUserId; //not null then navigate to chat room
  final bool? NavigateToVideoCall; //not null then navigate to video chat

  const ChatSelectionPage(this.AppData, this.OtherUserId, this.NavigateToVideoCall);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ChatSelectionViewModel.CreateViewModel(AppData), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data == null) {
          ToastBar.ShowMessage(AppData.SelectedLanguage.FailToConnectToServer());
          return AccountLoginPage(AppData.SelectedLanguage, AppData.SelectedMode);
        }

        else if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          
          //push to chat room page if navigated from notification
          if (OtherUserId != null) {
            WidgetsBinding.instance.addPostFrameCallback((Duration callBack) {
              var conversation = snapshot.data!.Conversations.where((x) => x.OtherUser.Id == OtherUserId).firstOrNull;

              if(conversation != null){
                ChatNavigation.ChatRoomPagePush(context, AppData, 
                  UserInfoModel(OtherUserId!, conversation.OtherUser.Username), 
                  snapshot.data!.WebSocket, 
                  (OtherUserId) => snapshot.data!.ResetUnseenMessageCount(OtherUserId), 
                  NavigateToVideoCall);
              }
            });
          }
          return ChatSelectionUI(snapshot.data!); 
        }

        else { 
          return ChatSelectionTempUI(AppData.MyUser, AppData.SelectedMode);
        }
      }
    );
  }
}
