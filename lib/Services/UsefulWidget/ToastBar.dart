import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastBar {
  ///Display a toast bar in the center with text message
  static void ShowMessage(String message){
    Fluttertoast.cancel();

    Fluttertoast.showToast(
      msg: message,
      timeInSecForIosWeb: 1,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 14.0
    );  
  }
}