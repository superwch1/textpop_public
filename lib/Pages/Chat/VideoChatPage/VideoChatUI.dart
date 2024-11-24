import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import 'package:textpop/Pages/Chat/VideoChatPage/Widget/ButtonsWidget.dart';
import 'package:textpop/ViewModels/Chat/ButtonWidgetViewModel.dart';
import 'package:textpop/ViewModels/Chat/VideoChatViewModel.dart';

class VideoChatUI extends StatelessWidget {
  final VideoChatViewModel ViewModel;

  const VideoChatUI(this.ViewModel);
  
  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    ViewModel.Context = context;
    ViewModel.DraggableScreenWidth = width * 0.35;
    ViewModel.DraggableScreenHeight = width  * 0.35 * 4 / 3;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Builder(
              builder: (context) {
                if(ViewModel.PeerConnection.connectionState == null || ViewModel.PeerConnection.connectionState != RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
                  return RTCVideoView(
                    ViewModel.LocalRenderer, mirror: true,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover, 
                  );
                }
                else {
                  return RTCVideoView(
                    ViewModel.RemoteRenderer, mirror: true,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover, 
                  );
                }
              }
            ),
          ),
          Positioned(
            top: ViewModel.DraggableScreenPositionY,
            left: ViewModel.DraggableScreenPositionX,
            child: Draggable(
              childWhenDragging: const SizedBox(),
              onDragEnd: (details) => ViewModel.DragEnd(details, MediaQuery.of(context).size),
              feedback: SizedBox(
                height: ViewModel.DraggableScreenHeight,
                width: ViewModel.DraggableScreenWidth,
                child: Builder(
                  builder: (context) {
                    if(ViewModel.PeerConnection.connectionState == null || ViewModel.PeerConnection.connectionState != RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
                      return const SizedBox();
                    }
                    else {
                      return RTCVideoView(
                        ViewModel.LocalRenderer, mirror: true,
                        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover, 
                      );
                    }
                  }
                ),
              ),
              child: SizedBox(
                height: ViewModel.DraggableScreenHeight,
                width: ViewModel.DraggableScreenWidth,
                child: Builder(
                  builder: (context) {
                    if(ViewModel.PeerConnection.connectionState == null || ViewModel.PeerConnection.connectionState != RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
                      return const SizedBox();
                    }
                    else {
                      return RTCVideoView(
                        ViewModel.LocalRenderer, mirror: true,
                        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover, 
                      );
                    }
                  }
                ),
              ),
            )
          ),
          Positioned(
            top: height * 0.85,
              child: ChangeNotifierProvider(
              create: (context) => ButtonWidgetViewModel(ViewModel),
              child: Consumer<ButtonWidgetViewModel>(
                builder:(context, viewModel, child) {
                  return ButtonWidget(viewModel, width, height);
                }
              )
            )
          )
        ],
      ),
    );
  }
}