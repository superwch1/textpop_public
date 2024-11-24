import 'package:flutter/material.dart';
import 'package:textpop/Localisation/Mode/Mode.dart';
import 'package:textpop/Models/ConversationModel.dart';
import 'package:textpop/Models/UserInfoModel.dart';
import 'package:textpop/Services/WebServer/ConnectionOption.dart';

class ConversationWidget extends StatelessWidget{

  final String AppToken;
  final UserInfoModel MyUser;
  final ConversationModel Conversation;
  final Mode SelectedMode;

  final void Function (
    BuildContext context, UserInfoModel OtherUser, int LastMessageId) EnterConversation;
  
  const ConversationWidget(this.AppToken, this.MyUser, this.Conversation, this.EnterConversation, this. SelectedMode);

  @override
  Widget build(BuildContext context) {
    
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Center(
      child: Container( 
        margin: EdgeInsets.only(bottom: height * 0.02),
        height: height * 0.15,
        width: width * 0.9,
        child: OutlinedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
            backgroundColor: MaterialStateProperty.all(SelectedMode.ConversationButtonBackground()),
            side: MaterialStateProperty.all(const BorderSide(width: 0, color: Colors.transparent))
          ),                  
          onPressed: () => EnterConversation(context, Conversation.OtherUser, Conversation.Id),

          child: Row(
            children: [
              Align(
                alignment: const Alignment(0, -0.5),
                child: ClipOval(
                  child: Image.network(
                    height: height * 0.06,
                    width: height * 0.06,
                    ConnectionOption().AvatarUrl(Conversation.OtherUser.Id), 
                    errorBuilder: (context, child, loadingProgress) => Container(
                      height: height * 0.06,
                      width: height * 0.06,
                      color: SelectedMode.ButtonBackground(),
                    )
                  ),
                ),
              ),

              SizedBox( width: width * 0.04,),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * 0.55,
                    child: Text(
                      Conversation.OtherUser.Username,
                      style: TextStyle(color: SelectedMode.TextColor(), fontWeight: FontWeight.bold,
                      fontSize: 28
                      ), 
                    ),
                  ),

                  SizedBox( 
                    height: height * 0.01
                  ),

                  SizedBox(
                    width: width * 0.55,
                    child: Text(
                      Conversation.LatestMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: SelectedMode.TextColor(),
                        fontSize: 20,
                        fontStyle: Conversation.Italic == true ? FontStyle.italic : FontStyle.normal
                      ),
                    ),
                  )
                ],
              ),
              
              Align(
                alignment: const Alignment(0, 0.5),
                child: Builder(
                  builder:(context) {
                    if (Conversation.UnseenMessageCount > 0){
                      return Container(
                        height: width * 0.075,
                        width: width * 0.075,
                        decoration: BoxDecoration(
                          color: SelectedMode.MiscBButtonBackground(),
                          shape: BoxShape.circle
                        ),
                        child: Center(
                          child: Text(
                            Conversation.UnseenMessageCount.toString(),
                            style: TextStyle(color: SelectedMode.ChatUnseenCountTextColor()),
                          )
                        ),
                      );
                    }
                    else {
                      return Container();
                    }
                  },
                )
              )
            ]
          ), 
        ),
      )
    );
  }
}