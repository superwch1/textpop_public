import 'package:flutter/material.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/Models/UserInfoModel.dart';
import 'package:textpop/Models/WebSocketModel.dart';
import 'package:textpop/Navigation/ChatNavigation.dart';
import 'package:textpop/Pages/Chat/ChatRoomPage/ChatRoomUI.dart';
import 'package:textpop/Pages/Chat/ChatRoomPage/ChatRoomTempUI.dart';
import 'package:textpop/Services/UsefulWidget/ToastBar.dart';
import 'package:textpop/ViewModels/Chat/ChatRoomViewModel.dart';

class ChatRoomPage extends StatelessWidget{

  final AppDataModel AppData;
  final UserInfoModel OtherUser;
  final WebSocketModel WebSocket;
  final bool? NavigateToVideoCall;

  const ChatRoomPage(this.AppData, this.OtherUser, this.WebSocket, this.NavigateToVideoCall);


  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: ChatRoomViewModel.CreateViewModel(AppData, OtherUser, WebSocket), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data == null) {
          ToastBar.ShowMessage(AppData.SelectedLanguage.FailToConnectToServer());
          
          WidgetsBinding.instance.addPostFrameCallback((Duration callBack) {
            Navigator.pop(context);
          });
          return ChatRoomTempUI(OtherUser, AppData);
        }

        else if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          if (NavigateToVideoCall != null) {
            WidgetsBinding.instance.addPostFrameCallback((Duration callBack) {
              ChatNavigation.VideoChatPagePush(context, AppData, OtherUser, WebSocket);
            });
          }
          return ChatRoomUI(snapshot.data!); 
        }

        else { 
          return ChatRoomTempUI(OtherUser, AppData);
        }
      }
    );
  }
}
