import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:textpop/AppLaunch.dart';
import 'package:textpop/Localisation/Language/Chinese.dart';
import 'package:textpop/Localisation/Language/English.dart';
import 'package:textpop/Localisation/Language/Langauge.dart';
import 'package:textpop/Navigation/ChatNavigation.dart';
import 'package:textpop/Repository/MessageRepository.dart';
import 'package:textpop/Repository/UserDataRepository.dart';
import 'package:textpop/ViewModels/Chat/ChatSelectionViewModel.dart';


class MessageNotification {
  ///Set up the notification icon and request user permission
  static Future<void> InitializePackage(GlobalKey<NavigatorState> key) async{    
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('icon'); //android/app/src/main/res/drawable
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async => SelectNotification(details, key)
    );
  }



  static void SelectNotification(NotificationResponse notificaiton, GlobalKey<NavigatorState> key) async {
    if (key.currentContext != null && notificaiton.payload != null){
      var appData = await AppLaunch.ReadAppDataModel();
      var viewModel = await ChatSelectionViewModel.CreateViewModel(appData);
      var otherUserId = notificaiton.payload!.replaceAll("_call", "");

      //call notification
      if (notificaiton.payload!.contains("_call")){
        ChatNavigation.ChatRoomPageFromNotification(key.currentContext!, appData, viewModel, otherUserId, true);
      }
      //message notification
      else {
        ChatNavigation.ChatRoomPageFromNotification(key.currentContext!, appData, viewModel, otherUserId, null);
      }
      
    }
  }



  ///Show the notification on the mobile
  static Future<void> ReceiveMessage(RemoteMessage message) async{
    if(message.data["Function"] == "add"){
      await AddMessage(message);
    }
    else if (message.data["Function"] == "delete"){
      await DeleteMessage(message);
    }
  }


  static Future<void> DeleteMessage(RemoteMessage message) async {
    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(); 
    var activeNotifications = await flutterLocalNotificationsPlugin.getActiveNotifications();

    var data = await UserDataRepository.ReadLanguage();
    var selectedLanguage = ReadLanguage(data);

    List<Map<String, dynamic>> unseenMessages = List.from(await MessageRepository.ReadLastFiveRecords(message.data["OtherUserId"]));
    //deleted message maybe unseen and sorted in ranked 6th in notificaiton
    await MessageRepository.DeleteMessageWithMessageId(message.data["Id"]);

    //deleted message not in notification
    var deletedMessageIndex = unseenMessages.indexWhere((x) => x["MessageId"] == message.data["Id"]);   
    if (deletedMessageIndex == -1){ 
      return;
    }
    unseenMessages.removeAt(deletedMessageIndex);

    Map<String, dynamic>? matched;
    //no active notification
    if (activeNotifications.isEmpty){
      return;
    }

    else {
      matched = activeNotifications
        .where((x) => x.tag == message.data["OtherUserId"])
        .map((x) => {"NotificationId": x.id, "Tag": x.tag})
        .firstOrNull;
    }

    //no active notification from the other user
    if (matched == null){
      return;
    }

    //after the message is deleted, no more unseen message from other user
    int unseenMessageCount = await MessageRepository.ReadUnseenMessageCount(message.data["OtherUserId"]);
    if (unseenMessageCount == 0){
      await flutterLocalNotificationsPlugin.cancel(matched["NotificationId"], tag: matched["Tag"]);
    }
    
    else {
      List<String> notificationLines = unseenMessages.map((x) => "${x['Text']}").toList();
      
      var inboxStyleInformation = InboxStyleInformation(notificationLines);
      //channel Id and name allow user to have different action in setting such as mute
      //payload need to be the same for android to replace previous notification
      var androidNotificationDetails = AndroidNotificationDetails("Message", "Message", 
        styleInformation: inboxStyleInformation, tag: matched["Tag"]);
            
      var notificationDetails = NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.show(matched["NotificationId"], message.data["OtherUserUsername"], 
        selectedLanguage.Notification_NumberOfMessages(unseenMessageCount), notificationDetails, payload: matched["Tag"]);
    }
  }


  static Future<void> AddMessage(RemoteMessage message) async{
    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(); 

    var data = await UserDataRepository.ReadLanguage();
    var selectedLanguage = ReadLanguage(data);

    await MessageRepository.CreateUnseenMessage(
      message.data["Id"], message.data["OtherUserId"], message.data["OtherUserUsername"], message.data["Text"]);
  
    int unseenMessageCount = await MessageRepository.ReadUnseenMessageCount(message.data["OtherUserId"]);
    List<Map<String, dynamic>> unseenMessages = await MessageRepository.ReadLastFiveRecords(message.data["OtherUserId"]);

    var activeNotifications = await flutterLocalNotificationsPlugin.getActiveNotifications();
    int? matchedId;
    List<int?> matchedNotificationId = List.empty(growable: true);

    if (activeNotifications.isNotEmpty){
      matchedNotificationId = activeNotifications
        .where((x) => x.tag == message.data["OtherUserId"])
        .map((x) => x.id)
        .toList();
    }

    if (matchedNotificationId.length > 1){
      //delete any duplicate notifications
      for(var i = 1; i < matchedNotificationId.length; i++){
        if (matchedNotificationId[i] != null){
          await flutterLocalNotificationsPlugin.cancel(matchedNotificationId[i]!);
        }          
      }
    }
    else if (matchedNotificationId.length == 1){
      matchedId = matchedNotificationId.first;
    }

    matchedId = matchedId ?? DateTime.now().millisecondsSinceEpoch % (1<<31);

    List<String> notificationLines = unseenMessages.map((x) => "${x['Text']}").toList();
    
    var inboxStyleInformation = InboxStyleInformation(notificationLines);
    //channel Id and name allow user to have different action in setting such as mute
    //payload need to be the same for android to replace previous notification
    var androidNotificationDetails = AndroidNotificationDetails("Message", "Message", styleInformation: inboxStyleInformation, tag: message.data["OtherUserId"]);
        
    var notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(matchedId, message.data["OtherUserUsername"], 
      selectedLanguage.Notification_NumberOfMessages(unseenMessageCount), notificationDetails, payload: message.data["OtherUserId"]);
  }


  static Language ReadLanguage(String data) {  
    switch(data){
      case "Chinese":
        return Chinese();
      
      case "English":
        return English();

      default:
        return Chinese();
    }
  }
}