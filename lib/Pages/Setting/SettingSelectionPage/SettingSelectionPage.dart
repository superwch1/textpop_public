import 'package:flutter/material.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/Pages/Setting/SettingSelectionPage/SettingSelectionUI.dart';
import 'package:textpop/ViewModels/Setting/SettingSelectionViewModel.dart';

class SettingSelectionPage extends StatelessWidget {

  final AppDataModel AppData;

  const SettingSelectionPage(this.AppData);

  @override
  Widget build(BuildContext context) {
    return SettingSelectionUI(SettingSelectionViewModel(AppData));
  }
}