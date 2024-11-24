import 'package:flutter/material.dart';
import 'package:textpop/Pages/Chat/ChatRoomPage/Widget/ChatWidget.dart';
import 'package:textpop/Services/WebServer/AccountInfo.dart';
import 'package:textpop/ViewModels/Chat/ChatRoomViewModel.dart';
import 'package:provider/provider.dart';

class ChatRoomUI extends StatelessWidget{
  
  final ChatRoomViewModel ViewModel;

  const ChatRoomUI(this.ViewModel);
  
  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ViewModel.AppData.SelectedMode.AppBackground(),
                    
      appBar: AppBar(
        //change in height need to also adjust value in ChatWidgetViewModel
        toolbarHeight: height * 0.08,
        title: Row(
          children: [
            RawMaterialButton(
              constraints: const BoxConstraints(), //set the min width and height to 0
              onPressed: () => Navigator.pop(context),
              highlightColor: Colors.transparent,
              child: Image.asset(
                ViewModel.AppData.SelectedMode.ArrowBackPath(),
                height: 25,
              )
            ),
            RawMaterialButton(
              constraints: const BoxConstraints(), //set the min width and height to 0
              shape: const CircleBorder(),
              
              onPressed: () => ViewModel.ShowFullScreenImage(
                context, 
                AccountInfo().AvatarUrl(ViewModel.OtherUser.Id), 
                ViewModel.OtherUser.Username
              ),

              child: ClipOval(
                child: Image.network(                  
                  AccountInfo().AvatarUrl(ViewModel.OtherUser.Id),
                  height: height * 0.06,
                  width: height * 0.06,
                  
                  errorBuilder: (context, child, loadingProgress) => Container(
                    height: height * 0.06,
                    width: height * 0.06,
                    color: ViewModel.AppData.SelectedMode.ButtonBackground(),
                  )
                ),
              ),
            ),
            SizedBox(width: width * 0.025),
            Text(
              ViewModel.OtherUser.Username,
              style: TextStyle(color: ViewModel.AppData.SelectedMode.TextColor()),
            ),
          ]
        ),
        actions: [
          Builder(builder: (context) {
            if (ViewModel.OtherUser.Id != ViewModel.AppData.MyUser.Id) {
              return Row(
                children: [
                  RawMaterialButton(
                    constraints: const BoxConstraints(), //set the min width and height to 0
                    highlightColor: Colors.transparent,
                    onPressed: () async => await ViewModel.BlockOrUnblockUser(),
                    child: Image.asset(
                      ViewModel.AppData.SelectedMode.BanPath(),
                      width: 30,
                      height: 30,
                    )
                  ),
                  RawMaterialButton(
                    constraints: const BoxConstraints(), //set the min width and height to 0
                    highlightColor: Colors.transparent,
                    onPressed: () => ViewModel.EnterVideoChat(context),
                    child: Image.asset(
                      ViewModel.AppData.SelectedMode.EnterVideoChatPath(),
                      width: 30,
                      height: 30,
                    )
                  ),
                  SizedBox(width: width * 0.1),
                ],
              );
            }
            else {
              return SizedBox(
                width: width * 0.1
              );
            }
          })
        ],
        backgroundColor: ViewModel.AppData.SelectedMode.AppBackground(),
        automaticallyImplyLeading: false, // hide backward button
        scrolledUnderElevation: 0.0 // remove the shadow for scrolling
      ),

      body: ChangeNotifierProvider(
        create: (context) => ViewModel,
        child: Consumer<ChatRoomViewModel>(
          builder: (context, viewModel, child) {
            return ChatWidget(viewModel);
          },
        )
      )
    );
  }
}