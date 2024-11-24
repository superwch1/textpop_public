import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

class Option extends StatelessWidget {

  final Size DialogSize;
  final String Name;
  final int NumberOfOptions;
  final IconData IconPicture;
  final Message message;
  final Color FocusColor;
  final Future<void> Function(Message message, BuildContext context) OptionFunction;


  const Option(this.DialogSize, this.Name, this.NumberOfOptions, this.IconPicture, 
    this.OptionFunction, this.message, this.FocusColor);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: DialogSize.height / NumberOfOptions,
      child: RawMaterialButton(
        padding: const EdgeInsets.all(15),
        highlightColor: FocusColor,
        onPressed: () async => await OptionFunction(message, context),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Name, style: const TextStyle(fontSize: 16)),
              Icon(IconPicture)
            ],
          )
        ),
      ),
    );
  }
}