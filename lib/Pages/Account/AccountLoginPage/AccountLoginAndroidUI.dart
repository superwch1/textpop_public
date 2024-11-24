import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:textpop/Pages/Account/AccountLoginPage/Widget/ProviderWidget.dart';
import 'package:textpop/ViewModels/Account/AccountLoginViewModel.dart';


class AccountLoginAndroidUI extends StatelessWidget {

  final AccountLoginViewModel ViewModel;

  const AccountLoginAndroidUI(this.ViewModel);

  @override
  Widget build(BuildContext context) {
    
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        ListView( 
          children: [
            SizedBox(height: height * 0.16),

            Center(
              child: SizedBox(
                width: height * 0.31,
                height: height * 0.31,
                child: Image.asset(
                  ViewModel.SelectedMode.LoginCubePath(),
                  fit: BoxFit.contain
                )
              )
            ),

            SizedBox(height: height * 0.02),

            Center(
              child: SizedBox(
                height: height * 0.08,
                child: Text(ViewModel.SelectedLanguage.AccountLoginPage_WelcomeBanner(),
                    style: TextStyle(color: ViewModel.SelectedMode.TextColor(), fontSize: 48, fontWeight: FontWeight.w500)
                  )
              ),
            ),

            SizedBox(height: height * 0.06),

            Column(
              children: [
                ProviderWidget(ViewModel.SelectedMode.GoogleLogoPath(), "Google", 
                  ViewModel.LoginWithGoogle, ViewModel.SelectedLanguage, ViewModel.SelectedMode),
              ],
            ),
          ],
        ),
        Positioned(
          bottom: height * 0.05,
          left: width * 0.15,
          child: SizedBox(
            width: width * 0.7,
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(text: ViewModel.SelectedLanguage.AccountLoginPage_AcceptPolicyText(),
                style: TextStyle(fontSize: 14, color: ViewModel.SelectedMode.TextColor()),
                children: [
                  TextSpan(
                    text: ViewModel.SelectedLanguage.SettingAbout_TermsAndCondition(),
                    recognizer: TapGestureRecognizer()..onTap = () => ViewModel.ReadTermsAndCondition(context),
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: ViewModel.SelectedMode.AccountPolicyFontColor()
                    )
                  ),
                  TextSpan(
                    text: ViewModel.SelectedLanguage.AccountLoginPage_AndText()
                  ),
                  TextSpan(
                    text: ViewModel.SelectedLanguage.SettingAbout_PrivacyPolicy(),
                    recognizer: TapGestureRecognizer()..onTap = () => ViewModel.ReadPrivacyPolicy(context),
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: ViewModel.SelectedMode.AccountPolicyFontColor()
                    )
                  )
                ]
              ),
            ),
          ),
        )
      ],
    );
  }
}