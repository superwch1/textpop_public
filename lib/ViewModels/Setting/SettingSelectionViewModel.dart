import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:textpop/Localisation/Language/Chinese.dart';
import 'package:textpop/Localisation/Language/English.dart';
import 'package:textpop/Localisation/Mode/Dark.dart';
import 'package:textpop/Localisation/Mode/Light.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/Navigation/AccountNavigation.dart';
import 'package:textpop/Navigation/ChatNavigation.dart';
import 'package:textpop/Navigation/SettingNavigation.dart';
import 'package:textpop/Repository/MessageRepository.dart';
import 'package:textpop/Repository/UserDataRepository.dart';
import 'package:textpop/Services/UsefulWidget/ToastBar.dart';
import 'package:textpop/Services/WebServer/SettingSelection.dart';

class SettingSelectionViewModel {
  AppDataModel AppData;

  SettingSelectionViewModel(this.AppData);

  ///Logout and delete appToken in database
  Future<void> Logout(BuildContext context) async{

    String? fcmToken = await FirebaseMessaging.instance.getToken();
    var response = await SettingSelection().UserLogout(AppData.AppToken, fcmToken!);

    if (response.statusCode == 417 || response.statusCode != 200){
      ToastBar.ShowMessage(AppData.SelectedLanguage.FailToConnectToServer());
      return;
    }

    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.cancelAll();
    await UserDataRepository.DeleteAppToken();
    if (Platform.isAndroid){
      await MessageRepository.DeleteAllUnseenMessage();
    }
    
    ToastBar.ShowMessage(AppData.SelectedLanguage.SettingSelection_AccountLoggedOut());

    if (context.mounted){
      Navigator.of(context).popUntil((route) => route.isFirst);
      AccountNavigation.AccountLoginPagePushReplacement(context, AppData.SelectedLanguage, AppData.SelectedMode);
    }
  }


  ///Delete account and messages then logout
  Future<void> DeleteAccount(BuildContext context) async{
    var responseFromDeleteMessage = await SettingSelection().DeleteAllMessage(AppData.AppToken);
    if (responseFromDeleteMessage .statusCode == 417 || responseFromDeleteMessage .statusCode != 200){
      ToastBar.ShowMessage(AppData.SelectedLanguage.FailToConnectToServer());
      return;
    }

    var responseFromDeleteUser = await SettingSelection().DeleteUser(AppData.AppToken);
    if (responseFromDeleteUser.statusCode == 417 || responseFromDeleteUser.statusCode != 200){
      ToastBar.ShowMessage(AppData.SelectedLanguage.FailToConnectToServer());
      return;
    }

    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.cancelAll();
    await UserDataRepository.DeleteAppToken();
    if (Platform.isAndroid){
      await MessageRepository.DeleteAllUnseenMessage();
    }

    ToastBar.ShowMessage(AppData.SelectedLanguage.SettingSelection_AccountDeleted());

    if (context.mounted){
      Navigator.of(context).popUntil((route) => route.isFirst);
      AccountNavigation.AccountLoginPagePushReplacement(context, AppData.SelectedLanguage, AppData.SelectedMode);
    }
  }


  ///Switch language and PushReplacement to ChatSelectionPage
  Future<void> SwitchLangauge(BuildContext context) async{
    
    String selectedLanguage = "Chinese";
    switch(AppData.SelectedLanguage){
      case Chinese():
        selectedLanguage = "English";
        AppData.SelectedLanguage = English();
        break;
      
      case English():
        selectedLanguage = "Chinese";
        AppData.SelectedLanguage = Chinese();
        break;
    }

    ToastBar.ShowMessage(AppData.SelectedLanguage.SettingSelection_LanguageChanged());
    await UserDataRepository.UpdateLanguage(selectedLanguage);

    if (context.mounted){
      Navigator.of(context).popUntil((route) => route.isFirst);
      ChatNavigation.ChatSelectionPagePushReplacement(context, AppData, null, null);
    }
  }


  Future<void> SwitchMode(BuildContext context) async{
    String selectedMode = "Light";
    switch(AppData.SelectedMode){
      case Light():
        selectedMode = "Dark";
        AppData.SelectedMode = Dark();
        break;
      
      case Dark():
        selectedMode = "Light";
        AppData.SelectedMode = Light();
        break;
    }

    ToastBar.ShowMessage(AppData.SelectedLanguage.SettingSelection_ModeChanged());
    await UserDataRepository.UpdateMode(selectedMode);

    if (context.mounted){
      Navigator.of(context).popUntil((route) => route.isFirst);
      ChatNavigation.ChatSelectionPagePushReplacement(context, AppData, null, null);
    }
  }


  void EnterAbout(BuildContext context){
    SettingNavigation.SettingAboutPagePush(context, AppData);
  }


  String ReadModeInString() {
    switch(AppData.SelectedMode){
      case Light():
        switch(AppData.SelectedLanguage){
        case Chinese():
          return "淺色";
        
        case English():
          return "Light";
      }
      case Dark():
        switch(AppData.SelectedLanguage){
          case Chinese():
            return "深色";
          
          case English():
            return "Dark";
        }
    }
    return "Light";
  }
}