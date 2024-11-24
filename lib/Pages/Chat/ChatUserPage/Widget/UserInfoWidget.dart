import 'package:flutter/material.dart';
import 'package:textpop/Localisation/Mode/Mode.dart';
import 'package:textpop/Models/UserInfoModel.dart';
import 'package:textpop/Services/WebServer/ConnectionOption.dart';

class UserInfoWidget extends StatelessWidget{

  final Mode SelectedMode;
  final UserInfoModel OtherUser;
  final void Function (
    BuildContext context, UserInfoModel OtherUser) EnterConversation;

  const UserInfoWidget(this.SelectedMode, this.OtherUser, this.EnterConversation);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Center(
      child: SizedBox(
        height: height * 0.09,
        width: width * 0.9,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
              color: Colors.transparent,
            ),
          ),                 
          onPressed: () => EnterConversation(context, OtherUser),

          child: Row(
            children: [
              Align(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(height * 0.06),
                  child: Image.network(
                    ConnectionOption().AvatarUrl(OtherUser.Id), 
                    height: height * 0.06,
                    errorBuilder:(context, error, stackTrace) => 
                      Container(
                        height: height * 0.06,
                        width: height * 0.06,
                        color: SelectedMode.ButtonBackground(),
                      ),
                  ),
                )
              ),

              SizedBox( width: width * 0.04,),

              SizedBox(
                width: width * 0.55,
                child: Text(
                  OtherUser.Username,
                  style: TextStyle(color: SelectedMode.TextColor(), fontWeight: FontWeight.bold,
                  fontSize: 24
                  ), 
                ),
              ),
            ]
          ), 
        ),
      )
    );
  }

}