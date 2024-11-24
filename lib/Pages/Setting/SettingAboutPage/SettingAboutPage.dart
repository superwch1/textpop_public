import 'package:flutter/material.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/Pages/Setting/SettingAboutPage/SettingAboutUI.dart';
import 'package:textpop/ViewModels/Setting/SettingAboutViewModel.dart';

class SettingAboutPage extends StatelessWidget {

  final AppDataModel AppData;

  const SettingAboutPage(this.AppData);

  @override
  Widget build(BuildContext context) {
    return SettingAboutUI(SettingAboutViewModel(AppData));
  }
}