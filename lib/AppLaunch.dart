import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:textpop/Localisation/Language/Chinese.dart';
import 'package:textpop/Localisation/Language/English.dart';
import 'package:textpop/Localisation/Language/Langauge.dart';
import 'package:textpop/Localisation/Mode/Dark.dart';
import 'package:textpop/Localisation/Mode/Light.dart';
import 'package:textpop/Localisation/Mode/Mode.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/Repository/MessageRepository.dart';
import 'package:textpop/Repository/UserDataRepository.dart';
import 'package:textpop/Services/WebServer/AccountInfo.dart';
import 'Models/UserInfoModel.dart';

class AppLaunch {
  static Future<AppDataModel> ReadAppDataModel() async {
    await UserDataRepository.CreateTableWhenNotExist();
    if (Platform.isAndroid){
      await MessageRepository.CreateTableWhenNotExist();
    }

    var record = await UserDataRepository.ReadAppTokenModeLanguage();

    String appToken = record["AppToken"] ?? "";
    Language selectedLanguage = AppLaunch.ReadLanguage(record["Language"]);

    Mode selectedMode = AppLaunch.ReadMode(record["Mode"]);
    UserInfoModel myUser = await AppLaunch.ReadUserInfo(appToken) ?? UserInfoModel("", "");

    return AppDataModel(appToken, myUser, selectedMode, selectedLanguage);
  }


  static Future<UserInfoModel?> ReadUserInfo(String? appToken) async{
    if (appToken == null || appToken.isEmpty){
      return null;
    }

    bool hasInternet = await InternetConnection().hasInternetAccess;
    if (hasInternet == false) {
      return null;
    }

    // getToken() will throw error when there is no connection to Internet causing grey screen
    // null check operator used on a null value
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    var response = await AccountInfo().UserLogin(appToken, fcmToken);
    if (response.statusCode == 417 || response.statusCode != 200){  
      return null;
    }
    return UserInfoModel(response.data["userId"], response.data["username"]);
  }


  static Language ReadLanguage(String data) {  
    switch(data){
      case "Chinese":
        return Chinese();
      
      case "English":
        return English();

      default:
        return Chinese();
    }
  }

  static Mode ReadMode(String data){   

    switch(data){
      case "Light":
        return Light();
      
      case "Dark":
        return Dark();

      default:
        return Light();
    }
  }
}