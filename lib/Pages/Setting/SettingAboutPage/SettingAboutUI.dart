import 'package:flutter/material.dart';
import 'package:textpop/Pages/Setting/SettingSelectionPage/Widget/OptionWidget.dart';
import 'package:textpop/ViewModels/Setting/SettingAboutViewModel.dart';

class SettingAboutUI extends StatelessWidget {

  final SettingAboutViewModel ViewModel;

  const SettingAboutUI(this.ViewModel);

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

            OptionWidget(ViewModel.AppData.SelectedMode, ViewModel.AppData.SelectedMode.PrivacyPolicyPath(), ViewModel.AppData.SelectedLanguage.SettingAbout_PrivacyPolicy(), ViewModel.ReadPrivacyPolicy),
            OptionWidget(ViewModel.AppData.SelectedMode, ViewModel.AppData.SelectedMode.TermsAndConditionPath(), ViewModel.AppData.SelectedLanguage.SettingAbout_TermsAndCondition(), ViewModel.ReadTermsAndCondition),
          ],
        ),
      )
    );
  }
}