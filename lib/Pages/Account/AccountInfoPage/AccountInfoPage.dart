import 'package:flutter/material.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/Pages/Account/AccountInfoPage/AccountInfoUI.dart';
import 'package:textpop/Services/WebServer/AccountInfo.dart';
import 'package:textpop/ViewModels/Account/AccountInfoViewModel.dart';

class AccountInfoPage extends StatelessWidget {

  final AppDataModel AppData;

  const AccountInfoPage(this.AppData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppData.SelectedMode.AppBackground(),
      
      body: AccountInfoUI(
        AccountInfoViewModel(
          AppData,
          TextEditingController(),
          AccountInfo().AvatarUrl(AppData.MyUser.Id),
        )
      )
    );
  }
}