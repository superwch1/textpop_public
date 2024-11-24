import 'package:flutter/material.dart';
import 'package:textpop/Localisation/Language/Langauge.dart';
import 'package:textpop/Localisation/Mode/Mode.dart';

class ProviderWidget extends StatelessWidget {

  final String ImagePath;
  final String ProviderName;
  final Future<void> Function(BuildContext context) LoginWithProvider;
  final Language SelectedLanguage;
  final Mode SelectedMode;

  const ProviderWidget(this.ImagePath, this.ProviderName, this.LoginWithProvider, this.SelectedLanguage, this.SelectedMode);

  @override
  Widget build(BuildContext context) {
    
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height * 0.09,
      width: width * 0.8,
      child: OutlinedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(height * 0.1))),
          backgroundColor: MaterialStateProperty.all(SelectedMode.ButtonBackground()),
          side: MaterialStateProperty.all(const BorderSide(color: Colors.transparent, width: 0)),
          overlayColor: MaterialStateProperty.all(SelectedMode.ButtonFocusBackground()),
        ),                  
        onPressed: () => LoginWithProvider(context),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImagePath, width: height * 0.05),

            SizedBox(width: width * 0.04),

            SizedBox(
              width: width * 0.55,
              child: Text(
                SelectedLanguage.AccountLoginPage_LoginProvider(ProviderName),
                style: TextStyle(color: SelectedMode.TextColor(), fontSize: 18),
              )
            )
          ]
        ), 
      ),
    );
  }
}