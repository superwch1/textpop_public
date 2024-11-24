import 'dart:ui' as Ui;
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/Services/UsefulWidget/MessageOption/Option.dart';

class OptionsBox {
  static Future ShowOptionWidget(double screenHeight, double messageTopPosition, Size messageSize, 
    Ui.Image messageBubbleImage, Size widgetSize, double widgetLeftPosition, Message message, 
    BuildContext messageBubbleContext, AppDataModel appData,
    Future<void> Function(Message message, BuildContext context) copyOption,
    Future<void> Function(Message message, BuildContext context) downloadOption,
    Future<void> Function(Message message, BuildContext context) shareOption,
    Future<void> Function(Message message, BuildContext context) deleteOption,
    Future<void> Function(Message message, BuildContext context) reportOption,
    ) async {
    await showDialog(
      barrierColor: Colors.black54.withOpacity(0.9),
      context: messageBubbleContext, 
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Stack(
            children: [
              Positioned(
                top: messageTopPosition,
                left: 0,
                child: SizedBox(
                  height: messageSize.height,
                  child: RawImage(
                    alignment: Alignment.topCenter,
                    image: messageBubbleImage,
                    width: messageSize.width,
                    fit: BoxFit.fitWidth,
                  ),
                )
              ),
              
              Positioned(
                top: messageTopPosition + messageSize.height,
                left: widgetLeftPosition,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: appData.SelectedMode.ChatMessageOptionBackground(),
                    ),
                    width: widgetSize.width,
                    height: widgetSize.height, //need to be fine tune or else have height gap
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: <Widget>[                      
                        Builder(builder:(context) {
                          if(message is TextMessage){
                            return Option(widgetSize, appData.SelectedLanguage.ChatRoomPage_CopyOption(), 
                              4, Icons.copy_outlined, copyOption, message, appData.SelectedMode.ChatMessageOptionFocus());
                          }
                          else {
                            return Option(widgetSize, appData.SelectedLanguage.ChatRoomPage_DownloadOption(), 
                              4, Icons.download, downloadOption, message, appData.SelectedMode.ChatMessageOptionFocus());
                          }
                        }),
                        Option(widgetSize, appData.SelectedLanguage.ChatRoomPage_ShareOption(), 
                          4, Icons.share_outlined, shareOption, message, appData.SelectedMode.ChatMessageOptionFocus()),
                        Option(widgetSize, appData.SelectedLanguage.ChatRoomPage_DeleteOption(), 
                          4, Icons.delete_outline, deleteOption, message, appData.SelectedMode.ChatMessageOptionFocus()),
                        Option(widgetSize, appData.SelectedLanguage.ChatRoomPage_ReportOption(), 
                          4, Icons.report_problem, reportOption, message, appData.SelectedMode.ChatMessageOptionFocus())
                      ],
                    ),
                  ),
                )
              )
            ],
          )
        );
      },
    );
  }
}