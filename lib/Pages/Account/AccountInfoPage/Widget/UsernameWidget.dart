import 'package:flutter/material.dart';
import 'package:textpop/ViewModels/Account/AccountInfoViewModel.dart';

class UsernameWidget extends StatefulWidget {

  final AccountInfoViewModel ViewModel;

  const UsernameWidget(this.ViewModel);
 
  @override
  State<StatefulWidget> createState() => UsernameState();
}


class UsernameState extends State<UsernameWidget> {

  @override
  void dispose(){
    widget.ViewModel.UsernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextFormField(
        controller: widget.ViewModel.UsernameController,
        maxLength: 10,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: widget.ViewModel.AppData.SelectedMode.TextColor(),
          fontSize: 18
        ),
        

        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.ViewModel.AppData.SelectedLanguage.AccountInfoPage_UsernameInput(),
          hintStyle: TextStyle(color: widget.ViewModel.AppData.SelectedMode.TextColor()),
          counterText: "",
        )  
      )
    );
  }
}
