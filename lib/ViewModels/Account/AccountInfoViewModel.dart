import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/Navigation/ChatNavigation.dart';
import 'package:textpop/Services/UsefulWidget/ToastBar.dart';
import 'package:textpop/Services/WebServer/AccountInfo.dart';

class AccountInfoViewModel extends ChangeNotifier {
  AppDataModel AppData;

  TextEditingController UsernameController;
  String ImageUri;

  //determine the image is loaded from device or server
  bool ImageUpdated = false;
  bool WaitingResponseFromServer = false;

  AccountInfoViewModel(this.AppData, this.UsernameController, this.ImageUri){
    UsernameController.text = AppData.MyUser.Username;
  }


  ///Update the user information and pushReplacement to ChatSelectionPage
  Future<void> UpdateAccountInfo(BuildContext context) async{
    WaitingResponseFromServer = true;
    
    String username = UsernameController.text;
    bool validateResult = ValidateUsername(username);

    if (validateResult == false){
      WaitingResponseFromServer = false;
      return;
    } 

    //no change in avatar have null imageUri
    Response<dynamic> response;
    if (ImageUpdated){
      response = await AccountInfo().UpdateUserInfo(username, ImageUri, AppData.AppToken);
    }
    else {
      response = await AccountInfo().UpdateUserInfo(username, null, AppData.AppToken);
    }

    if (response.statusCode == 417 || response.statusCode != 201){
      WaitingResponseFromServer = false;
      ToastBar.ShowMessage(AppData.SelectedLanguage.FailToConnectToServer());
      return;
    }

    ToastBar.ShowMessage(AppData.SelectedLanguage.AccountInfoPage_UserInfoUpdated());

    if(context.mounted){
      Navigator.of(context).popUntil((route) => route.isFirst); //pop the AccountInfoPage
      AppData.MyUser.Username = username;
      ChatNavigation.ChatSelectionPagePushReplacement(context, AppData, null, null); //update the username by reloading the page
    }
  }


  ///Choose the avatar from gallery
  Future<void> SelectAvatarFromDevice() async{

    ImagePicker picker = ImagePicker();
    XFile? imageFile = await picker.pickImage(source: ImageSource.gallery);

    if (imageFile == null) {
      return;
    }

    var croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          hideBottomControls: true,
          toolbarTitle: AppData.SelectedLanguage.AccountInfoPage_ChoosePhoto(),
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
        ),
        IOSUiSettings(
          title: AppData.SelectedLanguage.AccountInfoPage_ChoosePhoto(),
          rotateButtonsHidden: true,
          aspectRatioLockEnabled: true,
          resetButtonHidden: true,
          resetAspectRatioEnabled: false,
          aspectRatioPickerButtonHidden: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.square
          ]
        )
      ]
    );

    if (croppedImage != null){
      ImageUri = croppedImage.path;
      ImageUpdated = true; 
      notifyListeners();
    }
  }


  ///Validate the length, characters of username and path of image
  bool ValidateUsername(String username) {
    
    if (username.length < 4 || username.length > 10) {
      ToastBar.ShowMessage(AppData.SelectedLanguage.AccountInfoPage_UsernameLengthRequirement());
      return false;
    }

    const pattern = r'^[a-zA-Z0-9><@_.-]{4,10}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(username)) {
      ToastBar.ShowMessage(AppData.SelectedLanguage.AccountInfoPage_UsernameCharacterRequirement());
      return false;
    }

    return true;
  }
}