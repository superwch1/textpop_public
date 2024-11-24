import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:textpop/Localisation/Language/Langauge.dart';
import 'package:textpop/Localisation/Mode/Mode.dart';
import 'package:textpop/Pages/Setting/SettingPolicyPage/SettingPolicyUI.dart';
import 'package:textpop/Services/UsefulWidget/ToastBar.dart';
import 'package:textpop/ViewModels/Setting/SettingPolicyViewModel.dart';

class SettingPolicyPage extends StatelessWidget {

  final Language SelectedLanguage;
  final Mode SelectedMode;
  final String Title;
  final Future<Response<dynamic>> Function(String selectedLanguage) ReadPolicy;

  const SettingPolicyPage(this.SelectedLanguage, this.SelectedMode, this.Title, this.ReadPolicy);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ReadPolicy(SelectedLanguage.toString()), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.statusCode != 200) {
          ToastBar.ShowMessage(SelectedLanguage.FailToConnectToServer());
          
          WidgetsBinding.instance.addPostFrameCallback((Duration callBack) {
            Navigator.pop(context);
          });
          return SettingPolicyUI(SettingPolicyViewModel(SelectedMode, Title, ""));
        }

        else if (snapshot.connectionState == ConnectionState.done && snapshot.data!.statusCode == 200){
          return SettingPolicyUI(SettingPolicyViewModel(SelectedMode, Title, snapshot.data.toString())); 
        }

        else { 
          return SettingPolicyUI(SettingPolicyViewModel(SelectedMode, Title, ""));
        }
      }
    );
  }
}