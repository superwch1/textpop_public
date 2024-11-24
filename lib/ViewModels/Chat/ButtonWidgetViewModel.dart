import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/ViewModels/Chat/VideoChatViewModel.dart';

class ButtonWidgetViewModel extends ChangeNotifier {
  
  VideoChatViewModel videoChatViewModel;
  bool isSwitching = false;

  // enable video / audio and switch camera cannot be initiate here by setting the value to true
  // since notifyListener in VideoChatViewModel will reset everything back to default

  late AppDataModel AppData;

  ButtonWidgetViewModel(this.videoChatViewModel) {
    AppData = videoChatViewModel.AppData;
  }

  Future<void> SwitchCamera() async {
    if (isSwitching == true) {
      return;
    }
    isSwitching = true;

    videoChatViewModel.FacingMode = !videoChatViewModel.FacingMode;
    if (videoChatViewModel.LocalStream != null) {
      for(var track in videoChatViewModel.LocalStream!.getVideoTracks()) {
        Helper.switchCamera(track);
      }
    }
    notifyListeners();

    // android device will crash if user switches camera so fast
    await Future.delayed(const Duration(seconds: 1));
    isSwitching = false;
  }

  
  Future<void> ToggleVideoTrack() async {

    videoChatViewModel.EnableVideo = !videoChatViewModel.EnableVideo;
    for(var track in videoChatViewModel.LocalStream!.getVideoTracks()) {
      track.enabled = videoChatViewModel.EnableVideo;
    }
    notifyListeners();
  }

  Future<void> ToggleAudioTrack() async {
    videoChatViewModel.EnableAudio = !videoChatViewModel.EnableAudio;
    for(var track in videoChatViewModel.LocalStream!.getAudioTracks()) {
      track.enabled = videoChatViewModel.EnableAudio;
    }
    notifyListeners();
  }
}

