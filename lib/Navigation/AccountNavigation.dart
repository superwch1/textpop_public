import 'package:flutter/material.dart';
import 'package:textpop/Localisation/Language/Langauge.dart';
import 'package:textpop/Localisation/Mode/Mode.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/Pages/Account/AccountInfoPage/AccountInfoPage.dart';
import 'package:textpop/Pages/Account/AccountLoginPage/AccountLoginPage.dart';

class AccountNavigation {
  
  static void AccountInfoPagePush(BuildContext context, AppDataModel appData){
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => AccountInfoPage(appData),
      ),
    );
  }


  static void AccountLoginPagePushReplacement(BuildContext context, Language selectedLanguage, Mode selectedMode) { 
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => AccountLoginPage(selectedLanguage, selectedMode)
      ),
    );
  }
}