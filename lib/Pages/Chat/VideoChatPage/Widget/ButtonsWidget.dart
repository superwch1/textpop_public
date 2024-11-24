import 'package:flutter/material.dart';
import 'package:textpop/ViewModels/Chat/ButtonWidgetViewModel.dart';

class ButtonWidget extends StatelessWidget {
  final ButtonWidgetViewModel ViewModel;
  final double width;
  final double height;

  const ButtonWidget(this.ViewModel, this.width, this.height);
  
  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        RawMaterialButton(
          constraints: const BoxConstraints(), //set the min width and height to 0
          shape: const CircleBorder(),
          fillColor: ViewModel.AppData.SelectedMode.VideoChatButtonBackground(),
          padding: const EdgeInsets.all(15),
          
          onPressed: ViewModel.ToggleVideoTrack,
          child: Builder(
            builder: (context) {
              if (ViewModel.videoChatViewModel.EnableVideo == true) {
                return Image.asset(
                  ViewModel.AppData.SelectedMode.VideoTrackOnPath(),
                  width: 40,
                  height: 40,
                );
              }
              else {
                return Image.asset(
                  ViewModel.AppData.SelectedMode.VideoTrackOffPath(),
                  width: 40,
                  height: 40,
                );
              }
            },
          )
        ),

        const SizedBox(width: 20),

        RawMaterialButton(
          constraints: const BoxConstraints(), //set the min width and height to 0
          shape: const CircleBorder(),
          fillColor: ViewModel.AppData.SelectedMode.VideoChatButtonBackground(),
          padding: const EdgeInsets.all(15),
          
          onPressed: ViewModel.SwitchCamera,
          child: Image.asset(
            ViewModel.AppData.SelectedMode.SwitchCameraPath(),
            width: 40,
            height: 40,
          )
        ),

        const SizedBox(width: 20),

        RawMaterialButton(
          constraints: const BoxConstraints(), //set the min width and height to 0
          shape: const CircleBorder(),
          fillColor: ViewModel.AppData.SelectedMode.VideoChatButtonBackground(),
          padding: const EdgeInsets.all(15),
          
          onPressed: ViewModel.ToggleAudioTrack,
          child: Builder(
            builder: (context) {
              if (ViewModel.videoChatViewModel.EnableAudio == true) {
                return Image.asset(
                  ViewModel.AppData.SelectedMode.AudioTrackOnPath(),
                  width: 40,
                  height: 40,
                );
              }
              else {
                return Image.asset(
                  ViewModel.AppData.SelectedMode.AudioTrackOffPath(),
                  width: 40,
                  height: 40,
                );
              }
            },
          )
        ),

        const SizedBox(width: 20),

        RawMaterialButton(
          constraints: const BoxConstraints(), //set the min width and height to 0
          shape: const CircleBorder(),
          fillColor: ViewModel.AppData.SelectedMode.LeaveVideoChatButtonBackground(),
          padding: const EdgeInsets.all(18),
          
          onPressed: () => Navigator.pop(context),
          child: Image.asset(
            ViewModel.AppData.SelectedMode.LeaveVideoChatPath(),
            width: 34, // 40 - (18 - 15) * 2, size of this image is bigger than others
            height: 34, // 40 - (18 - 15) * 2, size of this image is bigger than others
          ),
        ),
      ],
    );
  }
}