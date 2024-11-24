import 'package:flutter/material.dart';
import 'package:textpop/ViewModels/Chat/ChatUserViewModel.dart';

class SearchBarWidget extends StatefulWidget{
  final ChatUserViewModel ViewModel;

  const SearchBarWidget(this.ViewModel);
 
  @override
  State<StatefulWidget> createState() => SearchBarState();
}


class SearchBarState extends State<SearchBarWidget> {

  @override
  void dispose(){
    widget.ViewModel.UsernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.06,
      decoration: BoxDecoration(
        color: widget.ViewModel.AppData.SelectedMode.InputBackground(),
        borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      child: Row(
        children: [
          SizedBox(width: width * 0.05),

          SizedBox(
            width: width * 0.72,
            child: TextFormField(
              controller: widget.ViewModel.UsernameController,
              onFieldSubmitted: (value) => widget.ViewModel.SearchUser(value),
              maxLength: 12,
              style: TextStyle(color: widget.ViewModel.AppData.SelectedMode.TextColor()),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.ViewModel.AppData.SelectedLanguage.ChatUserPage_SearchUser(),
                hintStyle: TextStyle(color: widget.ViewModel.AppData.SelectedMode.TextColor()),
                counterText: "",
              )      
            )
          ),
        ],
      )
    );
  }
}