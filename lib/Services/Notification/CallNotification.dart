import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CallNotification {
  static Future<void> ReceiveCall(RemoteMessage message) async{
    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var activeNotifications = await flutterLocalNotificationsPlugin.getActiveNotifications();
    int? matchedId;
    List<int?> matchedNotificationId = List.empty(growable: true);

    if (activeNotifications.isNotEmpty){
      matchedNotificationId = activeNotifications
        .where((x) => x.tag == "${message.data["OtherUserId"]}_call")
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

    var androidNotificationDetails = AndroidNotificationDetails("Call", "Call", tag: "${message.data["OtherUserId"]}_call");
        
    var notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(matchedId, message.data["OtherUserUsername"], 
      message.data["Text"], notificationDetails, payload: "${message.data["OtherUserId"]}_call");
  }
}