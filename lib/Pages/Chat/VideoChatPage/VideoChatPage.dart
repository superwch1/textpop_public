import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/Models/UserInfoModel.dart';
import 'package:textpop/Models/WebSocketModel.dart';
import 'package:textpop/Pages/Chat/VideoChatPage/VideoChatUI.dart';
import 'package:textpop/Services/UsefulWidget/ToastBar.dart';
import 'package:textpop/ViewModels/Chat/VideoChatViewModel.dart';

class VideoChatPage extends StatelessWidget{

  final AppDataModel AppData;
  final UserInfoModel OtherUser;
  final WebSocketModel WebSocket;

  const VideoChatPage(this.AppData, this.OtherUser, this.WebSocket);


  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: VideoChatViewModel.CreateViewModel(AppData, OtherUser, WebSocket), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data == null) {
          ToastBar.ShowMessage(AppData.SelectedLanguage.FailToConnectToServer());
          //return to previous page if it cannot build view model
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop();
          });
          return const Scaffold(backgroundColor: Colors.black);
        }

        else if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          return ChangeNotifierProvider(
            create: (context) => snapshot.data,
            child: Consumer<VideoChatViewModel>(
              builder:(context, viewModel, child) {
                return VideoChatUI(viewModel);
              }
            )
          );
        }

        else { 
          return const Scaffold(backgroundColor: Colors.black);
        }
      }
    );

  }
}
