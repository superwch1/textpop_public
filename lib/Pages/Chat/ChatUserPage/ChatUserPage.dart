import 'package:flutter/material.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/Models/WebSocketModel.dart';
import 'package:textpop/Pages/Chat/ChatUserPage/ChatUserUI.dart';
import 'package:textpop/ViewModels/Chat/ChatUserViewModel.dart';

class ChatUserPage extends StatelessWidget{

  final AppDataModel AppData;

  final WebSocketModel WebSocket;

  final Function(String OtherUserId) ResetUnseenMessageCount;

  const ChatUserPage(this.AppData, this.WebSocket, this.ResetUnseenMessageCount);

  @override
  Widget build(BuildContext context) {
    return ChatUserUI(
      ChatUserViewModel(AppData, WebSocket, ResetUnseenMessageCount, TextEditingController()),
    );
  }
}