import 'dart:async';
import 'dart:io';
import 'package:eraser/eraser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as ChatUi;
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as Notification;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:textpop/Models/AppDataModel.dart';
import 'package:textpop/Models/UserInfoModel.dart';
import 'package:textpop/Models/WebSocketModel.dart';
import 'package:textpop/Navigation/ChatNavigation.dart';
import 'package:textpop/Repository/MessageRepository.dart';
import 'package:textpop/Services/UsefulWidget/MessageOption/OptionsBox.dart';
import 'package:textpop/Services/UsefulWidget/PhotoViewer.dart';
import 'package:textpop/Services/UsefulWidget/ToastBar.dart';
import 'package:textpop/Services/WebServer/ChatRoom.dart';
import 'dart:ui' as Ui;

class ChatRoomViewModel extends ChangeNotifier {
  
  AppDataModel AppData;
  UserInfoModel OtherUser;
  WebSocketModel WebSocket;
  
  ChatUi.InputTextFieldController TextController = ChatUi.InputTextFieldController();

  //used for countercheck the message after initialMessageId
  int InitialMessageId;
  List<Message> Messages = List.empty(growable: true);

  bool MessageEndReached = false;
  bool WaitingResponseFromReadingMessage = false;
  bool WaitingResponseFromCreatingMessage = false;

  ChatRoomViewModel(this.AppData, this.OtherUser, this.InitialMessageId, this.WebSocket);

  static Future<ChatRoomViewModel?> CreateViewModel(AppDataModel appData, UserInfoModel otherUser, WebSocketModel webSocket) async{
       
    var response = await ChatRoom().ReadLatestMessage(appData.AppToken, otherUser.Id);
    if (response.statusCode == 417 || response.statusCode != 200) {
      return null;
    }

  
    List<dynamic>? messagelist = response.data;
    int initialMessageId;
    if (messagelist!.isEmpty){
      initialMessageId = 0;
    }
    else {
      initialMessageId = messagelist.last["id"];
    } 
    
    var viewModel = ChatRoomViewModel(appData, otherUser, initialMessageId, webSocket);    

    viewModel.UpdateMessage(messagelist, false);
    await viewModel.InitializeWebSocket(false);
    await viewModel.HideNotification();

    webSocket.InitializeFunctionList.add(() async {
      await viewModel.InitializeWebSocket(true);
      await viewModel.HideNotification();
    });

    webSocket.TermianteFunctionList.add(() async {
      await viewModel.TerminateWebSocket();
    });

    webSocket.ReconnectFunctionList.add(() async {
      viewModel.CounterCheckMessage();
      await viewModel.WebSocket.Connection.invoke("EnterConversation", args: [viewModel.OtherUser.Id]);
      }
    );

    //input must be less than or equal to 300 letters
    viewModel.TextController.addListener(() {
      if (viewModel.TextController.text.length > 300) {
        viewModel.TextController.text = viewModel.TextController.text.substring(0, 300);
      }
    });

    return viewModel;
  }


  ///On ReceiveMessage, DeleteMessage and invoke EnterConversation, true for counter check message
  Future<void> InitializeWebSocket(bool counterCheckMessage) async{  
    WebSocket.Connection.on("ReceiveMessage", (message) {
      UpdateMessage(message, true); 
      }
    );

    WebSocket.Connection.on("DeleteMessage", (message) {
      DeleteMessage(message); 
      }
    );
    
    if (WebSocket.Connection.state == HubConnectionState.connected){
      await WebSocket.Connection.send(methodName: "EnterConversation", args: [OtherUser.Id]);
    }

    if (counterCheckMessage == true){
      CounterCheckMessage();
    }
  }
  

  ///Off ReceiveConversation, DeleteMessage and invoke ExitConversation
  Future<void> TerminateWebSocket() async{    
    WebSocket.Connection.off("ReceiveMessage");
    WebSocket.Connection.off("DeleteMessage");

    if (WebSocket.Connection.state == HubConnectionState.connected){
      await WebSocket.Connection.send(methodName: "ExitConversation");
    }
  }


  ///Hide notification after enter the chat room
  Future<void> HideNotification() async{
    var flutterLocalNotificationsPlugin = Notification.FlutterLocalNotificationsPlugin();
    var activeNotifications = await flutterLocalNotificationsPlugin.getActiveNotifications();

    if (Platform.isAndroid){
      MessageRepository.DeleteUnseenMessage(OtherUser.Id);

      Map<String, dynamic>? matched = activeNotifications
        .where((x) => x.tag == OtherUser.Id)
        .map((x) => {"NotificationId": x.id, "Tag": x.tag})
        .firstOrNull;

      if (matched != null){
        await flutterLocalNotificationsPlugin.cancel(matched["NotificationId"], tag: matched["Tag"]);
      }
    }

    else if (Platform.isIOS){
      var deletedNotification = Messages.take(50).toList();
      for(var message in deletedNotification){
        await Eraser.clearAppNotificationsByTag("${OtherUser.Id}_${message.id}");
      }
    }
  }


  @override
  void dispose() {
    WebSocket.InitializeFunctionList.removeLast();
    WebSocket.TermianteFunctionList.removeLast();
    WebSocket.ReconnectFunctionList.removeLast();
    TerminateWebSocket(); //should be awaited
  
    super.dispose();
  }


  ///Counter check the messages after reconnected to siganlr
  Future<void> CounterCheckMessage() async{
    var response = await ChatRoom().ReadMessageAfterInitialMessage(AppData.AppToken, OtherUser.Id, InitialMessageId);
    if (response.statusCode == 417 || response.statusCode != 200) {
      return;
    }

    int count = response.data.where((x) => x["id"] >= InitialMessageId 
      && x["id"] <= int.parse(Messages.first.id)).length;

    //message deleted - most work done
    if (Messages.length != count){
      Messages.clear();
      UpdateMessage(response.data, true);
    }

    //message added
    else if (response.data.last["id"].toString() != Messages.first.id){
      UpdateMessage(response.data, true);
    } 
  }


  ///Read the historical message before the earliest message
  Future<void> ReadHistoricalMessage() async{  
    if (MessageEndReached == true || WaitingResponseFromReadingMessage == true){
      return;
    }
    
    WaitingResponseFromReadingMessage = true;
    var response = await ChatRoom().ReadMessageBeforeEarliestMessage(AppData.AppToken, int.parse(Messages.last.id), OtherUser.Id);
    
    if (response.statusCode == 417 || response.statusCode != 200) {
      WaitingResponseFromReadingMessage = false;
      return;
    }

    if(response.data.isEmpty){  
      MessageEndReached = true;  
    }
    else {
      InitialMessageId = (response.data as List<dynamic>)[0]["id"];
      UpdateMessage(response.data, true); 
    }

    WaitingResponseFromReadingMessage = false;
  }


  ///Send the text message
  Future<void> SendTextMessage(PartialText partialTextMessage) async {

    if (WaitingResponseFromCreatingMessage == true){
      return;
    }

    WaitingResponseFromCreatingMessage = true;
    FocusManager.instance.primaryFocus?.unfocus(); // toast cannot show when IOS keyboard is opened
    var response = await ChatRoom().SendTextMessage(AppData.AppToken, OtherUser.Id, partialTextMessage.text);
    WaitingResponseFromCreatingMessage = false;

    if (response.statusCode == 417 || response.statusCode != 201){
      ToastBar.ShowMessage(AppData.SelectedLanguage.ChatRoomViewMode_FailToSendMessage());
      return;
    }

    TextController.clear();
  }
  

  ///Send the image message
  Future<void> SendImageMessage() async {
    /* await Permission.photos.request(); it doesn't pop the request bubble
    if (!await Permission.photos.isGranted) {
      openAppSettings();
      return;
    }
    */

    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50
    );

    if (imageFile == null) {
      return;
    }

    var croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: AppData.SelectedLanguage.ChatRoomPage_ChoosePhoto(),
          hideBottomControls: true,
          lockAspectRatio: false
        ),
        IOSUiSettings(
          title: AppData.SelectedLanguage.ChatRoomPage_ChoosePhoto(),
          resetButtonHidden: true,
          aspectRatioPickerButtonHidden: true
        ),
      ],
    );

    if (croppedImage != null){
      var response = await ChatRoom().SendImageMessage(AppData.AppToken, OtherUser.Id, croppedImage.path);
      if (response.statusCode == 417 || response.statusCode != 201){
        ToastBar.ShowMessage(AppData.SelectedLanguage.ChatRoomViewMode_FailToSendMessage());
      }
    }  
  }


  ///Delete message
  void DeleteMessage(List<dynamic>? messagesList){
    if (messagesList == null){
      return;
    }

    if(!((messagesList[0]["receiverUserId"] == AppData.MyUser.Id && messagesList[0]["senderUserId"] == OtherUser.Id) || 
         (messagesList[0]["receiverUserId"] == OtherUser.Id && messagesList[0]["senderUserId"] == AppData.MyUser.Id))) {
      return;
    }

    var index = Messages.indexWhere((x) => x.id == messagesList[0]["id"].toString());
    if (index != -1){
      Messages.removeAt(index);
      notifyListeners();
    }
  }


  ///Update with list of message and sort with latest message in the end
  void UpdateMessage(List<dynamic>? messagesList, bool rebuildScreen) {
    if (messagesList == null){
      return;
    }

    List<Message> messageTemp = List.empty(growable: true);

    for(Map<String, dynamic> message in messagesList){
      //MyUserId is sender and OtherUserId is receiver or vice versa
      //otherwise loop return to avoid adding irrelvant users' messages 
      if(!((message["receiverUserId"] == AppData.MyUser.Id && message["senderUserId"] == OtherUser.Id) || 
           (message["receiverUserId"] == OtherUser.Id && message["senderUserId"] == AppData.MyUser.Id))) {
        return;
      }

      if(message["messageType"] == "Text"){
        messageTemp.add(TextMessage(id: message["id"].toString(), author: User(id: message["senderUserId"]), 
            createdAt: message["createdAt"], text: message["text"]));
      }
      else{
        String imageUri = ChatRoom().ReadImageFromMessageUrl(message["id"].toString());
        messageTemp.add(
          ImageMessage(id: message["id"].toString(), author: User(id: message["senderUserId"]), createdAt: message["createdAt"], 
            size: message["imageSize"], uri: imageUri, name: message["imageName"]));
      } 
    }

    for(var message in messageTemp){
      if (Messages.isEmpty){
        Messages.insert(0, message);
      }
      else{
        for(var messageIndex = 0; messageIndex < Messages.length; messageIndex++){ 
          //message has already appeared in chat
          if(int.parse(message.id) == int.parse(Messages[messageIndex].id)){
            break;
          }

          //message is recieved after the Messages[messageIndex]
          if(int.parse(message.id) > int.parse(Messages[messageIndex].id)){
            Messages.insert(messageIndex, message);
            break;
          }

          //reach the end of the meesage list, message should be earliest in chat
          if(messageIndex + 1 == Messages.length){
            Messages.add(message);
            break;
          }
        }
      }    
    } 

    if (rebuildScreen == true){
      notifyListeners();
    }
  }


  ///Tap and open the image in fullscreen
  void ShowFullScreenImage(BuildContext context, imageUri, imageName, {imageHeader}){
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => PhotoViewer(AppData.SelectedLanguage, AppData.SelectedMode, imageUri, imageName, ImageHeader: imageHeader,)
      ),
    );
  }


  ///Block or unblockUser
  Future BlockOrUnblockUser() async{
    FocusManager.instance.primaryFocus?.unfocus(); // toast cannot show when IOS keyboard is opened
    var response = await ChatRoom().BlockOrUnblockUser(AppData.AppToken, OtherUser.Id);
    
    if (response.statusCode == 200) {
      ToastBar.ShowMessage(AppData.SelectedLanguage.ChatRoomPage_UserUnblocked());
    }
    else if (response.statusCode == 201) {
      ToastBar.ShowMessage(AppData.SelectedLanguage.ChatRoomPage_UserBlocked());
    }
    else {
      ToastBar.ShowMessage(AppData.SelectedLanguage.FailToConnectToServer());
    }
  }


  ///Display the time of message: dd/MM/yyyy(not today), hh:mm(today)
  String DisplayTimeText(DateTime time){
    
    var today = DateTime.now();
    if (today.year == time.year && today.month == time.month && today.day == time.day){
      return DateFormat("HH:mm").format(time);
    }
    else{
      return DateFormat("dd/MM  HH:mm").format(time);
    }
  }

  void HandlePreviewDataFetched(TextMessage message, PreviewData? previewData) {
    final index = Messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (Messages[index] as TextMessage).copyWith(
      previewData: previewData
    );

    Messages[index] = updatedMessage;
    notifyListeners();
  }

  //Start a online video chat with other user
  Future EnterVideoChat(BuildContext context) async {
    await Permission.camera.request();
    await Permission.microphone.request();
    if (!await Permission.camera.isGranted || !await Permission.microphone.isGranted) {
      openAppSettings();
      return;
    }

    if (context.mounted){
      ChatNavigation.VideoChatPagePush(context, AppData, OtherUser, WebSocket);
    }
  }



  ///Long press the message to select
  Future SelectMessage(BuildContext chatScreenContext, BuildContext messageBubbleContext, Message message) async{
    FocusManager.instance.primaryFocus?.unfocus();
    
    //wait 300 milliseconds to close the keyboard before showing the option widget
    await Future.delayed(const Duration(milliseconds: 300),() async {

      var naivgationBarHeight = MediaQuery.of(messageBubbleContext).size.height * 0.08;

      var screenHeight = naivgationBarHeight + (chatScreenContext.findRenderObject() as RenderBox).size.height;
      var screenWidth = MediaQuery.of(messageBubbleContext).size.width;

      //constant value of the gap between y-coordinate of message bubble and real position
      var messageGap = -50;
      
      var messageTopPosition = messageGap + (messageBubbleContext.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dy;
      var messageSize = (messageBubbleContext.findRenderObject() as RenderBox).size;

      //create a separate display and convert it into an object of Image Class
      var boundary = messageBubbleContext.findAncestorRenderObjectOfType<RenderRepaintBoundary>()!;
      Ui.Image messageBubbleImage = await boundary.toImage(pixelRatio: 2.0);

      //set the size of the option widget
      var widgetSize = const Size(120, 200);

      //top position of the message bubble higher than the navigation bar
      if (messageTopPosition < naivgationBarHeight){
        messageTopPosition = naivgationBarHeight;
      }
      //bottom position of the message bubble lower than the screen
      else if ((messageTopPosition + messageSize.height + widgetSize.height + 20) > screenHeight){
        messageTopPosition = screenHeight -  messageSize.height - widgetSize.height - 20;
      }

      double widgetLeftPosition;
      if (message.author.id != OtherUser.Id || OtherUser.Id == AppData.MyUser.Id){
        widgetLeftPosition = screenWidth - 16.5 - widgetSize.width;  
      }
      else {
        widgetLeftPosition = 20;
      }

      //height of message bubble and option height longer than the screen size
      if ((messageSize.height + widgetSize.height) > (screenHeight - naivgationBarHeight)) {
        var ratio = (screenHeight - widgetSize.height - naivgationBarHeight - 20) / messageSize.height;
        messageSize = Size(messageSize.width, messageSize.height * ratio);
        messageTopPosition = naivgationBarHeight;
      }

      //give a little bit vibration for the response
      await HapticFeedback.lightImpact();

      if (messageBubbleContext.mounted){
        await OptionsBox.ShowOptionWidget(screenHeight, messageTopPosition, messageSize, messageBubbleImage, 
        widgetSize, widgetLeftPosition, message, messageBubbleContext, AppData, CopyOption, DownloadOption, 
        ShareOption, DeleteOption, ReportOption);
      }
    });
  }


  Future<void> CopyOption(Message message, BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: (message as TextMessage).text));
    ToastBar.ShowMessage(AppData.SelectedLanguage.ChatRoomPage_MessageCopied());

    if (context.mounted){
      Navigator.pop(context);
    }
  }

  Future<void> DownloadOption(Message message, BuildContext context) async {
    var response = await ChatRoom().ReadImageMessage(AppData.AppToken, message.id);

    if (response.data != null){
      await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      name: DateFormat('dd/MM/yyyy, hh:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(message.createdAt!)));

      ToastBar.ShowMessage(AppData.SelectedLanguage.Other_ImageSaved());
    }
    else {
      ToastBar.ShowMessage(AppData.SelectedLanguage.FailToConnectToServer());
    }

    if (context.mounted){
      Navigator.pop(context);
    }
  }


  Future<void> ShareOption(Message message, BuildContext context) async {
    if (message is TextMessage){
      await Share.share(message.text);
    }
    else {
      message = message as ImageMessage;
      var response = await ChatRoom().ReadImageMessage(AppData.AppToken, message.id);
      
      if (response.data != null){
        var directory = await getTemporaryDirectory();

        var imagePath = '${directory.path}/share_image.jpg';
        var imageFile = File(imagePath);

        await imageFile.writeAsBytes(response.data);
        var xfile = XFile(imagePath);

        // Share the image file.
        await Share.shareXFiles([xfile]);
      }
      else {
        ToastBar.ShowMessage(AppData.SelectedLanguage.FailToConnectToServer());
      }
    }

    if (context.mounted){
      Navigator.pop(context);
    }
  }


  Future<void> DeleteOption(Message message, BuildContext context) async {
    var response = await ChatRoom().DeleteMessage(AppData.AppToken, message.id);
    if (response.statusCode == 200){
      ToastBar.ShowMessage(AppData.SelectedLanguage.ChatRoomPage_MessageDeleted());
    }
    else {
      ToastBar.ShowMessage(AppData.SelectedLanguage.FailToConnectToServer());
    }

    if (context.mounted){
      Navigator.pop(context);
    }
  }


  Future<void> ReportOption(Message message, BuildContext context) async {
    ToastBar.ShowMessage(AppData.SelectedLanguage.ChatRoomPage_SendingReport()); 
     
    var response = await ChatRoom().ReportMessage(AppData.AppToken, message.author.id, message.id);
    if (response.statusCode == 201){
      ToastBar.ShowMessage(AppData.SelectedLanguage.ChatRoomPage_MessageReported());
    }
    else {
      ToastBar.ShowMessage(AppData.SelectedLanguage.FailToConnectToServer());
    }

    if (context.mounted){
      Navigator.pop(context);
    }
  }
}