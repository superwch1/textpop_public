import 'dart:io';
import 'package:flutter/material.dart';
import 'package:textpop/ViewModels/Account/AccountInfoViewModel.dart';

class AvatarWidget extends StatelessWidget{

  final AccountInfoViewModel ViewModel;

  const AvatarWidget(this.ViewModel);

  @override
  Widget build(BuildContext context) {
  
    final double height = MediaQuery.of(context).size.height;

    //the size of Stack is set on AccountInfoUI
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Builder(
                builder:(context) {

                  if (ViewModel.ImageUpdated == false){
                    return Image.network(
                      ViewModel.ImageUri,
                      fit: BoxFit.cover,
                      errorBuilder: (context, child, loadingProgress) => Container(
                        color: ViewModel.AppData.SelectedMode.ButtonBackground(),
                      )
                    );
                  }

                  else {
                    return Image.file(
                      File(ViewModel.ImageUri),
                      fit: BoxFit.cover,
                      errorBuilder: (context, child, loadingProgress) => Container(
                        color: ViewModel.AppData.SelectedMode.ButtonBackground(),
                      )
                    );
                  }
                  
                },
              )
            ),
          )
        ),

        Positioned(
          bottom: height * 0.015,
          right: height * 0.015,
          child: GestureDetector(
            onTap: () => ViewModel.SelectAvatarFromDevice(),
            child: Container(
              height: height * 0.085,
              width: height * 0.085,  

              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,      
                color: ViewModel.AppData.SelectedMode.ConfirmButtonBackground(),   
                border: Border.all(
                  color: ViewModel.AppData.SelectedMode.BorderColor(),
                  width: 2.0,
                ),
              ),          
              child: SizedBox(
                height: height * 0.03,
                width: height * 0.03,
                child: Image.asset(ViewModel.AppData.SelectedMode.ImageIconPath()),
              ),
            ),
          )
        )
      ]
    );
  }
}