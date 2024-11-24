import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as ChatUi;
import 'package:intl/intl.dart';
import 'package:textpop/Pages/Chat/ChatRoomPage/Widget/CustomizeChatTheme.dart';
import 'package:textpop/ViewModels/Chat/ChatRoomViewModel.dart';

class ChatWidget extends StatelessWidget {

  final ChatRoomViewModel ViewModel;
 
  const ChatWidget(this.ViewModel);
   
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40), 
          topRight: Radius.circular(40)
        ),

        child: Builder(
          builder:(chatWidgetContext) {
            return ChatUi.Chat(   
              messages: ViewModel.Messages,   
              imageHeaders: {"Authorization": "Bearer ${ViewModel.AppData.AppToken}"},

              user: User(id: ViewModel.AppData.MyUser.Id),

              onSendPressed: ViewModel.SendTextMessage,
              onAttachmentPressed: ViewModel.SendImageMessage,

              onEndReached: ViewModel.ReadHistoricalMessage,
              customDateHeaderText: ViewModel.DisplayTimeText,

              //open image in full screen after tapping
              disableImageGallery: true,     
              onMessageTap: (context, p1) {
                if (p1.type == MessageType.image){
                  ViewModel.ShowFullScreenImage(
                    context, 
                    (p1 as ImageMessage).uri, 
                    DateFormat('dd/MM/yyyy, hh:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(p1.createdAt!)),
                    imageHeader: {"Authorization": "Bearer ${ViewModel.AppData.AppToken}"} 
                  );
                }
              },


              l10n: ChatUi.ChatL10nZhTW(
                emptyChatPlaceholder: ViewModel.AppData.SelectedLanguage.ChatRoomPage_EmptyChat(),
                attachmentButtonAccessibilityLabel: ViewModel.AppData.SelectedLanguage.ChatRoomPage_SendMedia(),
                fileButtonAccessibilityLabel: ViewModel.AppData.SelectedLanguage.ChatRoomPage_Attachment(),
                inputPlaceholder: ViewModel.AppData.SelectedLanguage.ChatRoomPage_MessageInput(),
                sendButtonAccessibilityLabel: ViewModel.AppData.SelectedLanguage.ChatRoomPage_Send(),
                unreadMessagesLabel: ViewModel.AppData.SelectedLanguage.ChatRoomPage_UnseenMessage(),
              ),

              textMessageOptions: const ChatUi.TextMessageOptions(
                isTextSelectable: false
              ),

              onMessageLongPress:(context, p1) async => await ViewModel.SelectMessage(chatWidgetContext, context, p1),
          
              inputOptions: ChatUi.InputOptions(
                textEditingController: ViewModel.TextController,
                inputClearMode: ChatUi.InputClearMode.never
              ),


              theme: CustomizeChatTheme(
                attachmentButtonIcon: const Icon(Icons.image),
                backgroundColor: ViewModel.AppData.SelectedMode.ChatBackground(),

                inputBackgroundColor: ViewModel.AppData.SelectedMode.ChatInputBackground(),
                inputTextColor: ViewModel.AppData.SelectedMode.ChatInputTextColor(),
                inputMargin: const EdgeInsets.all(15),
                inputBorderRadius: const BorderRadius.all(Radius.circular(20)),
                inputPadding: const EdgeInsets.fromLTRB(18, 15, 18, 15),
                inputSurfaceTintColor: const Color(0xff1d1c21),
                inputElevation: 0,

                primaryColor: ViewModel.AppData.SelectedMode.MyMessageBackground(),
                sentMessageBodyTextStyle: TextStyle(
                  color: ViewModel.AppData.SelectedMode.MyMessageFontColor(),
                  fontSize: 16
                ),

                secondaryColor: ViewModel.AppData.SelectedMode.OtherMessageBackground(),
                receivedMessageBodyTextStyle: TextStyle(
                  color: ViewModel.AppData.SelectedMode.OtherMessageFontColor(),
                fontSize: 16,
                ), 

                receivedMessageLinkDescriptionTextStyle: TextStyle(
                  color: ViewModel.AppData.SelectedMode.OtherMessageFontColor(),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.428
                ), 

                receivedMessageLinkTitleTextStyle: TextStyle(
                  color: ViewModel.AppData.SelectedMode.OtherMessageFontColor(),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  height: 1.375,
                ),
                
                sentMessageLinkDescriptionTextStyle: TextStyle(
                  color: ViewModel.AppData.SelectedMode.MyMessageFontColor(),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.428
                ), 
                
                sentMessageLinkTitleTextStyle: TextStyle(
                  color: ViewModel.AppData.SelectedMode.MyMessageFontColor(),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  height: 1.375,
                ),
                messageMaxWidth: 440,
              ),
              onPreviewDataFetched: ViewModel.HandlePreviewDataFetched
            );
          },
        )
      )
    );
  }
}