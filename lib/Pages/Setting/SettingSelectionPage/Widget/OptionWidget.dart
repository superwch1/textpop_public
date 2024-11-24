import 'package:flutter/material.dart';
import 'package:textpop/Localisation/Mode/Mode.dart';

class OptionWidget extends StatelessWidget{

  final Mode SelectedMode;
  final String ImagePath;
  final String OptionName;
  final void Function (BuildContext context) EnterOption;
  
  const OptionWidget(this.SelectedMode, this.ImagePath, this.OptionName, this.EnterOption);

  @override
  Widget build(BuildContext context) {
    
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Center(
      child: Container( 
        margin: EdgeInsets.only(bottom: height * 0.025),
        height: height * 0.09,
        width: width * 0.9,
        child: OutlinedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
            backgroundColor: MaterialStateProperty.all(SelectedMode.ButtonBackground()),
            overlayColor: MaterialStateProperty.all(SelectedMode.ButtonFocusBackground()),
            side: MaterialStateProperty.all(const BorderSide(width: 0, color: Colors.transparent))
          ),                  
          onPressed: () => EnterOption(context),

          child: Row(
            children: [
              
              SizedBox( 
                width: width * 0.1,
                child: Center(
                  child: Image.asset(
                    ImagePath, 
                    height: height * 0.04,
                  ),
                ),
              ),

              SizedBox(width: width * 0.04),

              Text(
                OptionName, 
                style: TextStyle(
                  color: SelectedMode.TextColor(),
                  fontSize: 22
                )
              )
            ]
          ), 
        ),
      )
    );
  }
}