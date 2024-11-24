import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:textpop/Localisation/Language/Langauge.dart';
import 'package:textpop/Localisation/Mode/Mode.dart';
import 'package:textpop/Services/UsefulWidget/ToastBar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:textpop/Services/WebServer/ChatRoom.dart';

class PhotoViewer extends StatelessWidget {

  final Language SelectedLanguage;
  final Mode SelectedMode;
  final String ImageUri;
  final String ImageName;
  final Map<String, String>? ImageHeader;

  const PhotoViewer(this.SelectedLanguage, this.SelectedMode, this.ImageUri, this.ImageName, {this.ImageHeader});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // hide backward button
        title: Row(
          children: [
            RawMaterialButton(
              constraints: const BoxConstraints(), //set the min width and height to 0
              onPressed: () => Navigator.pop(context),
              highlightColor: Colors.transparent,
              child: Image.asset(
                SelectedMode.ArrowBackPath(),
                height: 25,
              )
            ),
          ],
        ),
        backgroundColor: SelectedMode.AppBackground(),
      ),

      floatingActionButton: IconButton(
        icon: const Icon(
          Icons.save,
          color: Colors.white
        ),
        onPressed: () async {
          /* await Permission.photos.request(); it doesn't pop the request bubble
          if (!await Permission.photos.isGranted) {
            openAppSettings();
            return;
          }
          */

          var response = await ChatRoom().ReadImageFromUrl(ImageUri, ImageHeader);

          if (response.data != null){
            await ImageGallerySaver.saveImage(
            Uint8List.fromList(response.data),
            name: ImageName);

            ToastBar.ShowMessage(SelectedLanguage.Other_ImageSaved());
          }
          else {
            ToastBar.ShowMessage(SelectedLanguage.FailToConnectToServer());
          }
        },
      ),
      backgroundColor: SelectedMode.AppBackground(),
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40), 
          topRight: Radius.circular(40)
        ),
        child: Center(
          child: PhotoView(
            imageProvider: NetworkImage(ImageUri, headers: ImageHeader),
            initialScale: PhotoViewComputedScale.contained * 0.8,
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.contained * 3.0,
            backgroundDecoration: BoxDecoration(
              color: SelectedMode.ChatBackground()
            ),
            errorBuilder: (context, child, loadingProgress) => 
              ClipOval(
                child: Image.asset(
                  SelectedMode.AvatarPath(),
                  fit: BoxFit.cover,
                ),
              )
          )
        )
      )
    );
  }
}