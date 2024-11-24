import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/Models/ConversationModel.dart';
import 'package:textpop/Models/UserInfoModel.dart';
import 'package:textpop/Models/WebSocketModel.dart';
import 'package:textpop/Navigation/AccountNavigation.dart';
import 'package:textpop/Navigation/ChatNavigation.dart';
import 'package:textpop/Navigation/SettingNavigation.dart';
import 'package:textpop/Repository/MessageRepository.dart';
import 'package:textpop/Services/SignalR/BuildHubConnection.dart';
import 'package:textpop/Services/WebServer/ChatConversation.dart';
import 'package:signalr_core/signalr_core.dart';

class ChatSelectionViewModel extends ChangeNotifier {

  AppDataModel AppData;
  WebSocketModel WebSocket;

  var EnterForegroundCount = 0;
  List<ConversationModel> Conversations = List.empty(growable: true);

  ChatSelectionViewModel(this.AppData, this.WebSocket, List<dynamic>? converationsList);


  static Future<ChatSelectionViewModel?> CreateViewModel(AppDataModel appData) async {
    var response = await ChatConversation().ReadAllConversation(appData.AppToken);
    if (response.statusCode == 417 || response.statusCode != 200){
      return null;
    }

    var connection = await BuildHubConnection.BuildWebSocket(appData.AppToken);
    if (connection == null){
      return null;
    }
    var webSocket = WebSocketModel(connection);

    var viewModel = ChatSelectionViewModel(appData, webSocket, response.data);
    viewModel.UpdateConversation(response.data, false);
    viewModel.InitializeWebSocket(false);

    viewModel.WebSocket.InitializeFunctionList.add(() async{
      viewModel.InitializeWebSocket(true);
    });

    viewModel.WebSocket.TermianteFunctionList.add(() async{
      await viewModel.TerminateWebSocket();
    });

    viewModel.WebSocket.ReconnectFunctionList.add(() async{
      await viewModel.CounterCheckConversation();
    });

    if (Platform.isAndroid){
      //if another user delete the account, delete the corresponding record in database
      //notifications still be visible and user can choose to remove or not
      var unseenOtherUserIds = await MessageRepository.ReadUniqueUserId();
      for(var userId in unseenOtherUserIds){
        if (!viewModel.Conversations.any((x) => x.OtherUser.Id == userId)){
          await MessageRepository.DeleteUnseenMessage(userId);
        }
      }
    }
    
    return viewModel;
  }


  @override
  void dispose() {
    WebSocket.InitializeFunctionList.clear();
    WebSocket.TermianteFunctionList.clear();
    WebSocket.ReconnectFunctionList.clear();
    TerminateWebSocket(); //should be awaited
    super.dispose();
  }


  ///On ReceiveConversation and set-up ReconnectionFunctions 
  void InitializeWebSocket(bool counterCheckConversation) { 

    WebSocket.Connection.on("ReceiveConversation", (conversation) {
        UpdateConversation(conversation, true); 
      }
    );

    WebSocket.Connection.on("DeleteConversation", (conversation) {
        DeleteConversation(conversation);
      }
    );
    
    WebSocket.Connection.onreconnected((connectionId) async{
        for(var function in WebSocket.ReconnectFunctionList){
          await function();
        }
      }
    );

    if(counterCheckConversation == true){
      CounterCheckConversation();
    }
  }


  ///Off ReceiveConversation, DeleteConversation and stop the connection
  Future<void> TerminateWebSocket() async{
    WebSocket.Connection.off("ReceiveConversation");
    WebSocket.Connection.off("DeleteConversation");
    await WebSocket.Connection.stop();
  }


  ///Call functions when app switch the state between foreground and background
  Future<void> SwitchBetweenForeAndBackground(AppLifecycleState state) async{

    if (state == AppLifecycleState.resumed){ //app is visible and responsible to user input
      EnterForegroundCount++;

      //prevent initalized websocket twice and terminated more than once
      //first: entering foreground, second: within the 5 seconds reconnection period
      if (WebSocket.Connection.state == HubConnectionState.disconnected){
        var connection = await BuildHubConnection.BuildWebSocket(AppData.AppToken);

        if (connection != null && connection.state == HubConnectionState.connected){
          WebSocket.Connection = connection;
          for(var function in WebSocket.InitializeFunctionList){
            await function();
          }
        }
      }  

      //reason for not using the lifecycle state as condition in while loop
      //if the user switch from foreground to background to foreground within 5 seconds
      //while loop stack up until establish connection to server
      var count = EnterForegroundCount;

      //since the disconnected connection, it cannot use ordinary reconnect policy
      //scenario: user enter chat room (background to foreground) and cannot connect to server
      //build websocket every 5 seconds until establish successful connection
      while(WebSocket.Connection.state == HubConnectionState.disconnected 
            && count == EnterForegroundCount){
          
        await Future.delayed(const Duration(seconds: 5), () async{
          if (WebSocket.Connection.state == HubConnectionState.disconnected){
            var connection = await BuildHubConnection.BuildWebSocket(AppData.AppToken);

            if (connection != null && connection.state == HubConnectionState.connected){
              WebSocket.Connection = connection;
              for(var function in WebSocket.InitializeFunctionList){
                await function();
              }
            }
          }      
        });
      }
    }


    else if (state == AppLifecycleState.inactive){ //app in background   
      //it can not placed inside the EnterBackgroundFunctions
      //the functions in ChatRoom need to be executed before terminate web socket
      if (WebSocket.Connection.state != HubConnectionState.disconnected){
        for(var function in WebSocket.TermianteFunctionList){
          await function();
        }
      }
    }
  }


  ///Counter check the conversations after reconnected to siganlr
  Future<void> CounterCheckConversation() async{
    var response = await ChatConversation().ReadAllConversation(AppData.AppToken);
    if (response.statusCode == 417 || response.statusCode != 200) {
      return;
    }

    Conversations.clear();
    UpdateConversation(response.data, true);
  }


  ///Update with list of conversation and sort with latest conversation in the beginning
  void UpdateConversation(List<dynamic>? converationsList, bool rebuildScreen) {
    if (converationsList == null){
      return;
    }
    for(var conversation in converationsList){

      if(Conversations.any((x) => x.OtherUser.Id == conversation["otherUserId"])){
        int index = Conversations.indexWhere((x) => x.OtherUser.Id== conversation["otherUserId"]);
        int count = Conversations[index].UnseenMessageCount + 1;
        Conversations[index] = ConversationModel(
          conversation["id"], UserInfoModel(conversation["otherUserId"], conversation["otherUserUsername"]), 
          conversation["messageType"] == "Text" ? conversation["latestMessage"] : AppData.SelectedLanguage.ChatSelectionPage_ImageMessage(), 
          conversation["messageType"] == "Text" ? false : true, count);
      }
      else{
        Conversations.add(ConversationModel(
          conversation["id"], UserInfoModel(conversation["otherUserId"], conversation["otherUserUsername"]), 
          conversation["messageType"] == "Text" ? conversation["latestMessage"] : AppData.SelectedLanguage.ChatSelectionPage_ImageMessage(), 
          conversation["messageType"] == "Text" ? false : true, conversation["unseenMessageCount"]));
      }
    }
    Conversations.sort((x, y) => y.Id.compareTo(x.Id)); 

    if (rebuildScreen == true){
      notifyListeners();
    }
  }


  ///Delete the message in conversation
  void DeleteConversation(List<dynamic>? converationsList) {
    if (converationsList == null){
      return;
    }

    bool rebuildScreen = false;
    for(var conversation in converationsList){

      if(Conversations.any((x) => x.Id == conversation["id"])){
        int index = Conversations.indexWhere((x) => x.Id == conversation["id"]);
        Conversations[index].Italic = true;
        Conversations[index].LatestMessage = AppData.SelectedLanguage.ChatSelectionPage_MessageDeleted();

        rebuildScreen = true;
      }
    }
    
    if (rebuildScreen == true){
      notifyListeners();
    }
  }


  //reset the unseen meesage count after leaving chat room
  void ResetUnseenMessageCount(String OtherUserId){
    int index = Conversations.indexWhere((x) => x.OtherUser.Id == OtherUserId);
    Conversations[index].UnseenMessageCount = 0;
    notifyListeners();
  }


  ///Push to ChatRoomPage
  void EnterChatRoom(BuildContext context, UserInfoModel OtherUser, int lastMessageId){
    ChatNavigation.ChatRoomPagePush(context, AppData, OtherUser, WebSocket, ResetUnseenMessageCount, null);
  }


  ///Push to AccountInfoPage
  void EditUserInfo(BuildContext context){
    AccountNavigation.AccountInfoPagePush(context, AppData);
  }


  //Push to SearchUserPage
  void SearchUser(BuildContext context){
    ChatNavigation.ChatUserPagePush(context, AppData, WebSocket, ResetUnseenMessageCount);
  }


  //Push to SettingSelectionPage
  void OpenSetting(BuildContext context){
    SettingNavigation.SettingSelectionPagePush(context, AppData);
  }
}