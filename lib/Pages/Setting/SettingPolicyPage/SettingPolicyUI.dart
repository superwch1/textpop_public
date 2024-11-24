import 'package:flutter/material.dart';
import 'package:textpop/ViewModels/Setting/SettingPolicyViewModel.dart';

class SettingPolicyUI extends StatelessWidget{
  
  final SettingPolicyViewModel ViewModel;

  const SettingPolicyUI(this.ViewModel);
  
  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ViewModel.SelectedMode.AppBackground(),
                    
      appBar: AppBar(
        toolbarHeight: height * 0.18,
        bottom: PreferredSize(
          preferredSize: Size.zero,
          child: Padding(
            padding: EdgeInsets.fromLTRB(width * 0.05, 0, 0, height * 0.02),
            child: Container(
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  RawMaterialButton(
                    constraints: const BoxConstraints(), //set the min width and height to 0
                    onPressed: () => Navigator.pop(context),
                    highlightColor: Colors.transparent,
                    child: Image.asset(
                      ViewModel.SelectedMode.ArrowBackPath(),
                      height: 25,
                    )
                  ),
                  Text(
                    ViewModel.Title, 
                    style: TextStyle(
                      color: ViewModel.SelectedMode.TextColor(),
                      fontSize: 30
                    )
                  ),
                ],
              )
            )
          )
        ),
        backgroundColor: ViewModel.SelectedMode.AppBackground(),
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
      ),

      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40), 
          topRight: Radius.circular(40)
        ),

        child: Container(
          constraints: const BoxConstraints.expand(),
          color: ViewModel.SelectedMode.ChatBackground(),
          padding: EdgeInsets.all(height * 0.02),
          child: Container(
            decoration: BoxDecoration(
              color: ViewModel.SelectedMode.PolicyBackground(),
              border: Border.all(
                color: ViewModel.SelectedMode.PolicyBorderColor()
              ),
              borderRadius: BorderRadius.all(Radius.circular(height * 0.03))
            ),          
            padding: EdgeInsets.all(height * 0.02),
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Text(
                  ViewModel.Text,
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: ViewModel.SelectedMode.TextColor()),
                )
              ),
            )
          )
        )
      )
    );
  }
}