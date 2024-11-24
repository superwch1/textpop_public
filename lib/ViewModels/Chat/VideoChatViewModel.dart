import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eraser/eraser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/Models/UserInfoModel.dart';
import 'package:textpop/Models/WebSocketModel.dart';
import 'package:textpop/Services/UsefulWidget/ToastBar.dart';
import 'package:textpop/Services/WebServer/ChatRoom.dart';
import 'package:textpop/Services/WebServer/ConnectionOption.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class VideoChatViewModel extends ChangeNotifier {
  
  AppDataModel AppData;
  UserInfoModel OtherUser;
  WebSocketModel WebSocket;

  BigInt MyUserIdInBigInt;
  BigInt OtherUserIdInBigInt;

  late BuildContext Context; //create object after entering VideoChatUI
  late RTCPeerConnection PeerConnection;
  
  late MediaStream? LocalStream;
  RTCVideoRenderer LocalRenderer = RTCVideoRenderer();
  RTCVideoRenderer RemoteRenderer = RTCVideoRenderer();
  List<RTCIceCandidate> iceCandidates = List.empty(growable: true);

  bool FacingMode = true;
  bool EnableVideo = true;
  bool EnableAudio = true;

  double DraggableScreenPositionX = 25;
  double DraggableScreenPositionY = 25;
  late double DraggableScreenWidth;
  late double DraggableScreenHeight;

  VideoChatViewModel(this.AppData, this.OtherUser, this.WebSocket, this.MyUserIdInBigInt, this.OtherUserIdInBigInt);

  static Future<VideoChatViewModel?> CreateViewModel(AppDataModel appData, UserInfoModel otherUser, WebSocketModel webSocket) async {

    BigInt myUserIdInBigInt = BigInt.parse(appData.MyUser.Id.replaceAll("-", ""), radix: 16);
    BigInt otherUserIdInBigInt = BigInt.parse(otherUser.Id.replaceAll("-", ""), radix: 16);

    var response = await ChatRoom().CreateVideoCall(appData.AppToken, otherUser.Id);
    if (response.statusCode == 417 || response.statusCode != 201){
      ToastBar.ShowMessage(appData.SelectedLanguage.ChatRoomViewMode_FailToCreateCall());
      return null;
    }

    var viewModel = VideoChatViewModel(appData, otherUser, webSocket, myUserIdInBigInt, otherUserIdInBigInt);    

    await viewModel.LocalRenderer.initialize();
    await viewModel.RemoteRenderer.initialize();

    viewModel.InitializeWebSocket();

    webSocket.InitializeFunctionList.add(() async {
      viewModel.InitializeWebSocket();
    });

    webSocket.TermianteFunctionList.add(() async {
      viewModel.TerminateWebSocket();
    });

    //capturing media need to be placed before creating peer connetion to have local stream
    await viewModel.CapturingMedia();
    await viewModel.CreatePeerConnection();
    await viewModel.HideNotification();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      viewModel.CreateOfferPeriodically();
    });

    await WakelockPlus.enable();

    return viewModel;
  }


  Future<void> CreatePeerConnection() async {
    Map<String, dynamic> configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
        {'urls': 'stun:stun1.l.google.com:19302'},
        {"urls": 'turn:${ConnectionOption.TurnServerDomain}',"username":"textpop","credential":"Aa123456"},
      ]
    };

    final Map<String, dynamic> sdpConstraints = {
      'mandatory': {
        'OfferToReceiveAudio': true,
        'OfferToReceiveVideo': true,
      },
      'optional': [],
    };

    PeerConnection = await createPeerConnection(configuration, sdpConstraints);

    //it is used for sending media track to another device using PeerConnectino
    for (var track in LocalStream!.getTracks()){
      await PeerConnection.addTrack(track, LocalStream!);
    }

    PeerConnection.onIceCandidate = (RTCIceCandidate candidate) {
      iceCandidates.add(candidate);
    };

    //using .onAddTrack will have white screen on ios after connection
    PeerConnection.onAddStream = (MediaStream stream) {
      RemoteRenderer.srcObject = stream;
    };

    PeerConnection.onConnectionState = (RTCPeerConnectionState state) async {
      //StateFailed: connection lost and unable to reconnect afterwards
      //StateClosed: user close the connection manually
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
        CreateOfferPeriodically();
      }

      else if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected){
        notifyListeners(); //swap the displaying widget of local renderer and remote renderer
      }
    };
  }

  Future<void> CapturingMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,

      //high value of width and height lead to freeze in android remote stream after few minutes
      //https://stackoverflow.com/questions/53540515/native-web-rtc-video-call-freeze-on-android-when-call-from-ios-app
      'video': {
        'mandatory': {
          'minWidth': '640',
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': FacingMode == true ? 'user' : 'environment',
        'optional': [],
      },
    };

    LocalStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    LocalRenderer.srcObject = LocalStream; 
  } 

  ///On ReceiveMessage, DeleteMessage and invoke EnterConversation, true for counter check message
  void InitializeWebSocket() {  
    WebSocket.Connection.on("ReceiveSdpOffer", (message) => ReceiveSdpOffer(message![0], message[1]));
    WebSocket.Connection.on("ReceiveSdpAnswer", (message) => ReceivecSdpAnswer(message![0], message[1])); 
    WebSocket.Connection.on("ReceiveIceCandidate", (message) => ReceiveIceCandidate(message![0], message[1]));
    WebSocket.Connection.on("GiveIceCandidate", (message) => GiveIceCandidate(message![0]));
  }
  

  ///Off ReceiveSdpOffer and ReceiveIceCandidate
  void TerminateWebSocket() async{    
    WebSocket.Connection.off("ReceiveSdpOffer");
    WebSocket.Connection.off("ReceiveSdpAnswer");
    WebSocket.Connection.off("ReceiveIceCandidate");
    WebSocket.Connection.off("GiveIceCandidate");
  }


  Future CreateOffer() async {
    if (PeerConnection.connectionState == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
      return;
    }

    if (PeerConnection.connectionState == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected ||
        PeerConnection.connectionState == RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
      //offer returned by the next call will trigger ICE restart on both devices
      PeerConnection.restartIce();
    }

    RTCSessionDescription description = await PeerConnection.createOffer();
    PeerConnection.setLocalDescription(description);
    
    try {
      await WebSocket.Connection.invoke("SendSdpOffer", args: [OtherUser.Id, description.sdp]);
    }
    on Exception{}
  }


  // Function to handle offer received from signaling server
  Future ReceiveSdpOffer(String otherUserId, String sdp) async {
    if (otherUserId != OtherUser.Id || PeerConnection.connectionState == RTCPeerConnectionState.RTCPeerConnectionStateConnected
        || PeerConnection.connectionState == RTCPeerConnectionState.RTCPeerConnectionStateClosed) {
      return;
    }

    await PeerConnection.setRemoteDescription(RTCSessionDescription(sdp, "offer"));
    await SendSdpAnswer(); 
  }


  Future SendSdpAnswer() async {
    RTCSessionDescription description = await PeerConnection.createAnswer();
    PeerConnection.setLocalDescription(description);

    try {
      await WebSocket.Connection.invoke("SendSdpAnswer", args: [OtherUser.Id, description.sdp]);
    }
    on Exception{}
  }


  Future ReceivecSdpAnswer(String otherUserId, String sdp) async {
    if (otherUserId != OtherUser.Id || PeerConnection.connectionState == RTCPeerConnectionState.RTCPeerConnectionStateConnected
        || PeerConnection.connectionState == RTCPeerConnectionState.RTCPeerConnectionStateClosed) {
      return;
    }

    await PeerConnection.setRemoteDescription(RTCSessionDescription(sdp, "answer"));
    await SendIceCandidate();
    await AskIceCandidate();
  }

  Future SendIceCandidate() async {
    String jsonString = jsonEncode(iceCandidates.map((candidate) => {
      'candidate': candidate.candidate,
      'sdpMid': candidate.sdpMid,
      'sdpMLineIndex': "${candidate.sdpMLineIndex}", //int needs to enclose with ""
    }).toList());
    
    try {
      WebSocket.Connection.invoke("SendIceCandidate", args: [OtherUser.Id, jsonString]);
    }
    on Exception{
      ToastBar.ShowMessage(AppData.SelectedLanguage.FailToConnectToServer());
    }
  }


  Future AskIceCandidate() async {
    try {
      await WebSocket.Connection.invoke("AskIceCandidate", args: [OtherUser.Id]);
    }
    on Exception{
      ToastBar.ShowMessage(AppData.SelectedLanguage.FailToConnectToServer());
    }
  }


  Future GiveIceCandidate(String otherUserId) async {
    if (otherUserId != OtherUser.Id) {
      return;
    }
    await SendIceCandidate();
  }

  // Function to handle ICE candidate received from signaling server
  Future ReceiveIceCandidate(String otherUserId, String jsonString) async {
    if (otherUserId != OtherUser.Id) {
      return;
    }

    final List<dynamic> jsonList = jsonDecode(jsonString);
    List<RTCIceCandidate> candidates = jsonList.map((item) {
      return RTCIceCandidate(item['candidate'], item['sdpMid'], int.parse(item['sdpMLineIndex']));
    }).toList();

    for (RTCIceCandidate candidate in candidates) {
      await PeerConnection.addCandidate(candidate);
    }
  }

  Future CreateOfferPeriodically () async {

    iceCandidates.clear();
    //The UserIdInInt with bigger number create offer
    if (MyUserIdInBigInt > OtherUserIdInBigInt) {
      await CreateOffer();
    }
    
    Timer? reconnectTimer;
    Stopwatch stopwatch = Stopwatch()..start();

    reconnectTimer = Timer.periodic(const Duration(seconds: 3), (timer) async { 
      
      //It needs to be in this order
      //Since user may left chat already and PeerConnection is null, Context.mounted can be used for the check
      if (!Context.mounted || PeerConnection.connectionState == RTCPeerConnectionState.RTCPeerConnectionStateConnected){
        reconnectTimer!.cancel();
        stopwatch.stop();
        return;
      }
      
      //after 20 seconds, it will leave chat when it does not have a connection   
      else if (stopwatch.elapsed > const Duration(seconds: 20) && PeerConnection.connectionState != RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        if (Context.mounted) {
          ToastBar.ShowMessage(AppData.SelectedLanguage.VideoChatPage_ConnectionLost());
          Navigator.pop(Context);
        }
          
        reconnectTimer!.cancel();
        stopwatch.stop();
        return;
      }

      iceCandidates.clear();
      //The UserIdInInt with bigger number create offer
      if (MyUserIdInBigInt > OtherUserIdInBigInt) {
        await CreateOffer();
      }
    });
  }

  void DragEnd(DraggableDetails details, Size size) {
    if (details.offset.dy < 0) {
      DraggableScreenPositionY = 0;
    }
    else if (details.offset.dy + DraggableScreenHeight > size.height) {
      DraggableScreenPositionY = size.height - DraggableScreenHeight;
    }
    else {
      DraggableScreenPositionY = details.offset.dy;
    }


    if (details.offset.dx < 0) {
      DraggableScreenPositionX = 0;
    }
    else if (details.offset.dx + DraggableScreenWidth > size.width) {
      DraggableScreenPositionX = size.width - DraggableScreenWidth;
    }
    else {
      DraggableScreenPositionX = details.offset.dx;
    }
    notifyListeners();
  }



  @override
  void dispose() {
    if (LocalStream != null) {
      //close audio and video capturing
      LocalStream!.getTracks().forEach((track) {
        track.stop();
      });
    }
    LocalRenderer.dispose();
    RemoteRenderer.dispose();

    PeerConnection.close();
    TerminateWebSocket();

    WakelockPlus.disable();

    super.dispose();
  }


  ///Hide notification after enter the video chat
  Future<void> HideNotification() async{
    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var activeNotifications = await flutterLocalNotificationsPlugin.getActiveNotifications();

    if (Platform.isAndroid){
      Map<String, dynamic>? matched = activeNotifications
        .where((x) => x.tag == "${OtherUser.Id}_call")
        .map((x) => {"NotificationId": x.id, "Tag": x.tag})
        .firstOrNull;

      if (matched != null){
        await flutterLocalNotificationsPlugin.cancel(matched["NotificationId"], tag: matched["Tag"]);
      }
    }

    else if (Platform.isIOS){
      await Eraser.clearAppNotificationsByTag("${OtherUser.Id}_call");
    }
  }
}

/* Test Cases
1. Both device enter video chat at same time
  Only the UserId with bigger number will send the offer


2. Android device switch into other applications and later join back
  Android will continue to capture video and send to another device
  10 seconds okay, 30 seconds okay, 60 seconds okay


3. IOS device switch into other applications and later join back
  IOS will stop capturing video and send to another device
  10 seconds okay, 30 seconds okay, 
  If IOS device rejoin in the time of disconnected from Android device, it will reconnect back
  40 seconds Android PeerConnectionState is disconnected then later closed
  60 seconds IOS PeerConnectionState is disconnected then later closed


4. device A switch into other application, device B leave chat, device A switch network and join back
  No error is found in the process

5. One device swtich the network from WiFi to Mobile Data
  No error is found in the process

6. IOS device video chat with Android device more than 10 minutes
  No error is found in the process
*/