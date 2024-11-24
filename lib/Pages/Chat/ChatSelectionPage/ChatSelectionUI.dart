import 'package:flutter/material.dart';
import 'package:textpop/Models/UserInfoModel.dart';
import 'package:textpop/Pages/Chat/ChatSelectionPage/Widget/ConversationWidget.dart';
import 'package:textpop/Pages/Chat/ChatSelectionPage/Widget/HeaderWidget.dart';
import 'package:textpop/ViewModels/Chat/ChatSelectionViewModel.dart';
import 'package:provider/provider.dart';

class ChatSelectionUI extends StatefulWidget {

  final ChatSelectionViewModel ViewModel;

  const ChatSelectionUI(this.ViewModel);
   
  @override
  State<StatefulWidget> createState() => ChatSelectionUIState();
}


class ChatSelectionUIState extends State<ChatSelectionUI> with WidgetsBindingObserver{

  //invoke the function when app is switched between foreground and background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    widget.ViewModel.SwitchBetweenForeAndBackground(state);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.14),
        child: HeaderWidget(
          UserInfoModel(widget.ViewModel.AppData.MyUser.Id, widget.ViewModel.AppData.MyUser.Username), 
          widget.ViewModel.AppData.SelectedMode,
          widget.ViewModel.EditUserInfo, 
          widget.ViewModel.OpenSetting
        )
      ),

      backgroundColor: widget.ViewModel.AppData.SelectedMode.AppBackground(),
      body: Stack(
        children: [
          ChangeNotifierProvider(
            create: (context) => widget.ViewModel,
            builder: (context, child) {
              return Consumer<ChatSelectionViewModel>(
                builder:(context, value, child) {
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: widget.ViewModel.Conversations.length,
                    itemBuilder:(context, index) {
                      return ConversationWidget(
                        widget.ViewModel.AppData.AppToken,
                        widget.ViewModel.AppData.MyUser,
                        widget.ViewModel.Conversations[index],
                        widget.ViewModel.EnterChatRoom,
                        widget.ViewModel.AppData.SelectedMode
                      );
                    },
                  );
                },
              );
            },
          ),

          Positioned(
            bottom: width * 0.07,  // Place it at the bottom of the screen
            right: width * 0.05,  // Place it towards the right side,
            child: RawMaterialButton(
              constraints: BoxConstraints(
                minHeight: height * 0.07,
                minWidth: height * 0.07,  
              ),
              shape: const CircleBorder(),
              fillColor: widget.ViewModel.AppData.SelectedMode.MiscBButtonBackground(),
              onPressed: () => widget.ViewModel.SearchUser(context),
              child: SizedBox(
                height: height * 0.037,
                width: height * 0.037,
                child: Image.asset(widget.ViewModel.AppData.SelectedMode.PencilPath()),
              ),
            )
          ),
        ],
      )
    );
  }
}