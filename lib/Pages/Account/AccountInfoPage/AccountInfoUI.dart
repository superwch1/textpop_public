import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:textpop/Pages/Account/AccountInfoPage/Widget/AvatarWidget.dart';
import 'package:textpop/Pages/Account/AccountInfoPage/Widget/UsernameWidget.dart';
import 'package:textpop/ViewModels/Account/AccountInfoViewModel.dart';
import 'package:provider/provider.dart';

class AccountInfoUI extends StatelessWidget {

  final AccountInfoViewModel ViewModel;

  const AccountInfoUI(this.ViewModel);

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(height: height * 0.06),

          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: width * 0.6,
              height: height * 0.09,
              decoration: BoxDecoration(
                color: ViewModel.AppData.SelectedMode.BannerBackground(),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(30))
              ),

              child: Container(
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
                    ViewModel.AppData.SelectedLanguage.AccountInfoPage_UpdateInfoBanner(),
                    style: TextStyle(
                      color: ViewModel.AppData.SelectedMode.TextColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                    ),
                  ),
                ],
              ) 
              )
            ),
          ),

          SizedBox(height: height * 0.05),     

          Center(
            child: SizedBox(
              width: height * 0.4,
              height: height * 0.4,
              child: ChangeNotifierProvider(
                create: (context) => ViewModel,
                child: Consumer<AccountInfoViewModel>(
                  builder:(context, viewModel, child) {
                    return AvatarWidget(viewModel);
                  }
                )
              )
            )
          ),

          SizedBox(height: height * 0.08),

          Center(
            child: Container(
              height: height * 0.07,
              width: width * 0.85,
              padding: EdgeInsets.fromLTRB(width * 0.07, 0, width * 0.07, 0),
              decoration: BoxDecoration(
                color: ViewModel.AppData.SelectedMode.InputBackground(),
                borderRadius: BorderRadius.all(Radius.circular(height * 0.05))
              ),
              child: UsernameWidget(ViewModel),
            )
          ),
                
          SizedBox(height: height * 0.05),


          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => ViewModel.UpdateAccountInfo(context),
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, width * 0.1, 0),
                height: height * 0.083,
                width: height * 0.083,  

                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,      
                  color: ViewModel.AppData.SelectedMode.MiscBButtonBackground(),   
                ),          
                child: SizedBox(
                  height: height * 0.038,
                  width: height * 0.038,
                  child: Image.asset(ViewModel.AppData.SelectedMode.RightArrowPath()),
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}