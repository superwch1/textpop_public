import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:textpop/Localisation/Language/Langauge.dart';
import 'package:textpop/Localisation/Mode/Mode.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/Pages/Setting/SettingAboutPage/SettingAboutPage.dart';
import 'package:textpop/Pages/Setting/SettingPolicyPage/SettingPolicyPage.dart';
import 'package:textpop/Pages/Setting/SettingSelectionPage/SettingSelectionPage.dart';

class SettingNavigation {
  
  static void SettingSelectionPagePush(BuildContext context, AppDataModel appData) { 
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => SettingSelectionPage(appData)
      ),
    );
  }

  static void SettingAboutPagePush(BuildContext context, AppDataModel appData) { 
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => SettingAboutPage(appData)
      ),
    );
  }

  static void SettingPolicyPagePush(BuildContext context, Language selectedLanguage, 
    Mode selectedMode, String title, 
    Future<Response<dynamic>> Function(String selectedLanguage) readPolicy) { 
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => SettingPolicyPage(selectedLanguage, selectedMode, title, readPolicy)
      ),
    );
  }
}