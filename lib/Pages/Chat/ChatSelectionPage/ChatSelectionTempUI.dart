import 'package:flutter/material.dart';
import 'package:textpop/Localisation/Mode/Mode.dart';
import 'package:textpop/Models/UserInfoModel.dart';
import 'package:textpop/Pages/Chat/ChatSelectionPage/Widget/HeaderWidget.dart';

class ChatSelectionTempUI extends StatelessWidget{
  final UserInfoModel MyUser;
  final Mode SelectedMode;

  const ChatSelectionTempUI(this.MyUser, this.SelectedMode);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.14),
        child: HeaderWidget(UserInfoModel(MyUser.Id, MyUser.Username), SelectedMode, (BuildContext context){}, (BuildContext context){})
      ),

      backgroundColor: SelectedMode.AppBackground(),
      body: const Text(""),

      floatingActionButton: RawMaterialButton(
        constraints: BoxConstraints(
          minHeight: height * 0.07,
          minWidth: height * 0.07,  
        ),
        shape: const CircleBorder(),
        fillColor: SelectedMode.MiscBButtonBackground(),
        onPressed: () {},
        child: SizedBox(
          height: height * 0.037,
          width: height * 0.037,
          child: Image.asset(SelectedMode.PencilPath()),
        ),
      )
    );
  }
}