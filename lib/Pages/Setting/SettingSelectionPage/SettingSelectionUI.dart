import 'package:flutter/material.dart';
import 'package:textpop/Pages/Setting/SettingSelectionPage/Widget/OptionWidget.dart';
import 'package:textpop/ViewModels/Setting/SettingSelectionViewModel.dart';

class SettingSelectionUI extends StatelessWidget {

  final SettingSelectionViewModel ViewModel;

  const SettingSelectionUI(this.ViewModel);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ViewModel.AppData.SelectedMode.AppBackground(),
      body: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          children: [

            SizedBox(height: height * 0.15),

            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  RawMaterialButton(
                    constraints: const BoxConstraints(), //set the min width and height to 0
                    onPressed: () => Navigator.pop(context),
                    highlightColor: Colors.transparent,
                    child: Image.asset(
                      ViewModel.AppData.SelectedMode.ArrowBackPath(),
                      height: 25,
                    )
                  ),
                  Text(
                    ViewModel.AppData.SelectedLanguage.SettingSelection_SettingBanner(),
                    style: TextStyle(color: ViewModel.AppData.SelectedMode.TextColor(), fontSize: 30, fontWeight: FontWeight.bold)
                  ),
                ],
              ) 
            ),

            SizedBox(height: height * 0.03),

            OptionWidget(ViewModel.AppData.SelectedMode, ViewModel.AppData.SelectedMode.ModePath(), ViewModel.AppData.SelectedLanguage.SettingSelection_Mode(ViewModel.ReadModeInString()), ViewModel.SwitchMode),
            OptionWidget(ViewModel.AppData.SelectedMode, ViewModel.AppData.SelectedMode.LangaugePath(), ViewModel.AppData.SelectedLanguage.SettingSelection_Language(), ViewModel.SwitchLangauge),
            OptionWidget(ViewModel.AppData.SelectedMode, ViewModel.AppData.SelectedMode.AboutPath(), ViewModel.AppData.SelectedLanguage.SettingSelection_About(), ViewModel.EnterAbout),
            OptionWidget(ViewModel.AppData.SelectedMode, ViewModel.AppData.SelectedMode.DeletePath(), ViewModel.AppData.SelectedLanguage.SettingSelection_DeleteAccount(), ViewModel.DeleteAccount),
            OptionWidget(ViewModel.AppData.SelectedMode, ViewModel.AppData.SelectedMode.LogoutPath(), ViewModel.AppData.SelectedLanguage.SettingSelection_Logout(), ViewModel.Logout)
          ],
        ),
      )
    );
  }
}