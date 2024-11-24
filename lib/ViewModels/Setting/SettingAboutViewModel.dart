import 'package:flutter/material.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/Navigation/SettingNavigation.dart';
import 'package:textpop/Services/WebServer/SettingPolicy.dart';

class SettingAboutViewModel {
  AppDataModel AppData;

  SettingAboutViewModel(this.AppData);

  ///Read Private Policy
  void ReadPrivacyPolicy(BuildContext context) async{
    var title = AppData.SelectedLanguage.SettingAbout_PrivacyPolicy();
    var readPolicy = SettingPolicy().ReadPrivacyPolicy;

    SettingNavigation.SettingPolicyPagePush(context, AppData.SelectedLanguage, AppData.SelectedMode, title, readPolicy);
  }


  ///Read Terms and Condition
  void ReadTermsAndCondition(BuildContext context) async{
    var title = AppData.SelectedLanguage.SettingAbout_TermsAndCondition();
    var readPolicy = SettingPolicy().ReadTermsAndConditions;

    SettingNavigation.SettingPolicyPagePush(context, AppData.SelectedLanguage, AppData.SelectedMode, title, readPolicy);
  }
}