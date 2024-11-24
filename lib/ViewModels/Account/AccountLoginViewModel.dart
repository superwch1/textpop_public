import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:textpop/Localisation/Language/Langauge.dart';
import 'package:textpop/Localisation/Mode/Mode.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/Models/UserInfoModel.dart';
import 'package:textpop/Navigation/AccountNavigation.dart';
import 'package:textpop/Navigation/ChatNavigation.dart';
import 'package:textpop/Navigation/SettingNavigation.dart';
import 'package:textpop/Repository/UserDataRepository.dart';
import 'package:textpop/Services/LoginProvider/AppleProvider.dart';
import 'package:textpop/Services/LoginProvider/GoogleProvider.dart';
import 'package:textpop/Services/UsefulWidget/ToastBar.dart';
import 'package:textpop/Services/WebServer/AccountLogin.dart';
import 'package:textpop/Services/WebServer/SettingPolicy.dart';


class AccountLoginViewModel {

  Language SelectedLanguage;
  Mode SelectedMode;
  bool WaitingResponseFromServer = false;

  AccountLoginViewModel(this.SelectedLanguage, this.SelectedMode);

  ///Login with the Apple Account
  Future<void> LoginWithApple(BuildContext context) async {
    WaitingResponseFromServer = true;

    String? appleToken = await AppleProvider().ReadIdToken();
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    if (appleToken == null || fcmToken == null){
      WaitingResponseFromServer = false;
      ToastBar.ShowMessage(SelectedLanguage.AccountLoginPage_FailToLoginWithProvider("Apple"));
      return;    
    }

    ToastBar.ShowMessage(SelectedLanguage.AccountLoginPage_LoggingIn());

    Response<dynamic> response = await AccountLogin().LoginWithAppleToken(appleToken, fcmToken);
    if (response.statusCode == 417 || !(response.statusCode == 201 || response.statusCode == 202)){
      WaitingResponseFromServer = false;
      ToastBar.ShowMessage(SelectedLanguage.FailToConnectToServer());
      return;    
    }

    var MyUser = UserInfoModel(response.data["userId"], response.data["username"]);
    await UserDataRepository.UpdateAppToken(response.data["appToken"]);

    if(context.mounted){
      RedirectToNewPage(response, MyUser, context);
    }
  }


  ///Login with the Google Account
  Future<void> LoginWithGoogle(BuildContext context) async {
    WaitingResponseFromServer = true;

    String? googleToken = await GoogleProvider().ReadIdToken();
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    if (googleToken == null || fcmToken == null){
      WaitingResponseFromServer = false;
      ToastBar.ShowMessage(SelectedLanguage.AccountLoginPage_FailToLoginWithProvider("Google"));
      return;    
    }

    ToastBar.ShowMessage(SelectedLanguage.AccountLoginPage_LoggingIn());

    Response<dynamic> response = await AccountLogin().LoginWithGoogleToken(googleToken, fcmToken);
    if (response.statusCode == 417 || !(response.statusCode == 201 || response.statusCode == 202)){
      WaitingResponseFromServer = false;
      ToastBar.ShowMessage(SelectedLanguage.FailToConnectToServer());
      return;    
    }

    var MyUser = UserInfoModel(response.data["userId"], response.data["username"]);
    await UserDataRepository.UpdateAppToken(response.data["appToken"]);

    if(context.mounted){
      RedirectToNewPage(response, MyUser, context);
    }
  }



  ///Push to AccountInfoPage (status code 201) and pushReplacement to ChatSelectionPage (status code 202)
  void RedirectToNewPage(Response<dynamic> response, UserInfoModel MyUser, BuildContext context) {
  
    if (response.statusCode == 201){ //user created
      AccountNavigation.AccountInfoPagePush(context, AppDataModel(response.data["appToken"], MyUser, SelectedMode, SelectedLanguage));
      return;
    }

    else if (response.statusCode == 202) { //user found    
      Navigator.of(context).popUntil((route) => route.isFirst);
      ChatNavigation.ChatSelectionPagePushReplacement(context, AppDataModel(response.data["appToken"], MyUser, SelectedMode, SelectedLanguage), null, null);
      return;
    }
    WaitingResponseFromServer = false;
  }


  ///Read Private Policy
  void ReadPrivacyPolicy(BuildContext context) async{
    var title = SelectedLanguage.SettingAbout_PrivacyPolicy();
    var readPolicy = SettingPolicy().ReadPrivacyPolicy;

    SettingNavigation.SettingPolicyPagePush(context, SelectedLanguage, SelectedMode, title, readPolicy);
  }


  ///Read Terms and Condition
  void ReadTermsAndCondition(BuildContext context) async{
    var title = SelectedLanguage.SettingAbout_TermsAndCondition();
    var readPolicy = SettingPolicy().ReadTermsAndConditions;

    SettingNavigation.SettingPolicyPagePush(context, SelectedLanguage, SelectedMode, title, readPolicy);
  }
}



  ///Login with the Facebook account
  /*
  Future<void> LoginWithFacebook(BuildContext context) async {
    WaitingResponseFromServer = true;

    String? facebookToken = await FacebookProvider().ReadIdToken();
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    if (facebookToken == null || fcmToken == null){
      WaitingResponseFromServer = false;
      ToastBar.ShowMessage(SelectedLanguage.AccountLoginViewModel_FailToLoginWithProvider("Facebook"));
      return;    
    }

    ToastBar.ShowMessage(SelectedLanguage.AccountLoginPage_LoggingIn());

    Response<dynamic> response = await AccountLogin().LoginWithFacebookToken(facebookToken, fcmToken);
    if (response.statusCode == 417 || !(response.statusCode == 201 || response.statusCode == 202)){
      WaitingResponseFromServer = false;
      ToastBar.ShowMessage(SelectedLanguage.FailToConnectToServer());
      return;    
    }

    var MyUser = UserInfo(response.data["userId"], response.data["username"]);
    await UserDataRepository.UpdateAppToken(response.data["appToken"]);

    if(context.mounted){
      RedirectToNewPage(response, MyUser, context);
    }
  }
  */
