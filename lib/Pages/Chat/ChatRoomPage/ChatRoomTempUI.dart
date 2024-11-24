import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/Models/UserInfoModel.dart';
import 'package:textpop/Services/WebServer/AccountInfo.dart';

class ChatRoomTempUI extends StatelessWidget{

  final UserInfoModel OtherUser;
  final AppDataModel AppData;

  const ChatRoomTempUI(this.OtherUser, this.AppData);
  
  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppData.SelectedMode.AppBackground(),
                    
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
                AppData.SelectedMode.ArrowBackPath(),
                height: 25,
              )
            ),
            RawMaterialButton(
              constraints: const BoxConstraints(), //set the min width and height to 0
              shape: const CircleBorder(),
              
              onPressed: null,

              child: ClipOval(
                child: Image.network(                  
                  AccountInfo().AvatarUrl(OtherUser.Id),
                  height: height * 0.06,
                  width: height * 0.06,
                  
                  errorBuilder: (context, child, loadingProgress) => Container(
                    height: height * 0.06,
                    width: height * 0.06,
                    color: AppData.SelectedMode.ButtonBackground(),
                  )
                ),
              ),
            ),
            SizedBox(width: width * 0.025),
            Text(
              OtherUser.Username,
              style: TextStyle(color: AppData.SelectedMode.TextColor()),
            ),
          ]
        ),
        actions: [
          Builder(builder: (context) {
            if (OtherUser.Id != AppData.MyUser.Id) {
              return Row(
                children: [
                  RawMaterialButton(
                    constraints: const BoxConstraints(), //set the min width and height to 0
                    highlightColor: Colors.transparent,
                    onPressed: null,
                    child: Image.asset(
                      AppData.SelectedMode.BanPath(),
                      width: 30,
                      height: 30,
                    )
                  ),
                  RawMaterialButton(
                    constraints: const BoxConstraints(), //set the min width and height to 0
                    highlightColor: Colors.transparent,
                    onPressed: null,
                    child: Image.asset(
                      AppData.SelectedMode.EnterVideoChatPath(),
                      width: 30,
                      height: 30,
                    )
                  ),
                  SizedBox(width: width * 0.1)
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
        backgroundColor: AppData.SelectedMode.AppBackground(),
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0.0 //remove the shadow for scrolling
      ),

      body: SafeArea(
        top: false,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40), 
          topRight: Radius.circular(40)),

          child: Chat(
            messages: List.empty(),
            user: const User(id: ""),

            onSendPressed: (PartialText text) => {},
            onAttachmentPressed: () {},

            disableImageGallery: true,     

            l10n: const ChatL10nZhTW(
              emptyChatPlaceholder: ""
            ),

              theme: DefaultChatTheme(
                attachmentButtonIcon: const Icon(Icons.image),
                backgroundColor: AppData.SelectedMode.ChatBackground(),

                inputBackgroundColor: AppData.SelectedMode.ChatInputBackground(),
                inputTextColor: AppData.SelectedMode.TextColor(),
                inputMargin: const EdgeInsets.all(15),
                inputBorderRadius: const BorderRadius.all(Radius.circular(20)),
                inputPadding: const EdgeInsets.fromLTRB(18, 15, 18, 15),

                primaryColor: AppData.SelectedMode.MyMessageBackground(),
                sentMessageBodyTextStyle: TextStyle(
                  color: AppData.SelectedMode.MyMessageFontColor(),
                  fontSize: 16
                ),

                secondaryColor: AppData.SelectedMode.OtherMessageBackground(),
                receivedMessageBodyTextStyle: TextStyle(
                  color: AppData.SelectedMode.OtherMessageFontColor(),
                fontSize: 16
                ),             
            ) 
          )
        )
      )
    );
  }
}