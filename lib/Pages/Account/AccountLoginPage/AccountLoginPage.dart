import 'dart:io';

import 'package:flutter/material.dart';
import 'package:textpop/Localisation/Language/Langauge.dart';
import 'package:textpop/Localisation/Mode/Mode.dart';
import 'package:textpop/Pages/Account/AccountLoginPage/AccountLoginAndroidUI.dart';
import 'package:textpop/Pages/Account/AccountLoginPage/AccountLoginIOSUI.dart';
import 'package:textpop/ViewModels/Account/AccountLoginViewModel.dart';

class AccountLoginPage extends StatelessWidget {

  final Language SelectedLanguage;
  final Mode SelectedMode;

  const AccountLoginPage(this.SelectedLanguage, this.SelectedMode);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid){
      return Scaffold(
        backgroundColor: SelectedMode.AppBackground(),
        body: AccountLoginAndroidUI(
          AccountLoginViewModel(SelectedLanguage, SelectedMode),
        )
      );
    }
    else{
      return Scaffold(
        backgroundColor: SelectedMode.AppBackground(),
        body: AccountLoginIOSUI(
          AccountLoginViewModel(SelectedLanguage, SelectedMode),
        )
      );
    }   
  }
}