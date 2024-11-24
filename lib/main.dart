import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:textpop/AppLaunch.dart';
import 'package:textpop/Navigation/ChatNavigation.dart';
import 'package:textpop/Pages/Chat/ChatSelectionPage/ChatSelectionPage.dart';
import 'package:textpop/Services/Notification/CallNotification.dart';
import 'package:textpop/Services/Notification/MessageNotification.dart';
import 'package:textpop/ViewModels/Chat/ChatSelectionViewModel.dart';
import 'package:textpop/pages/Account/AccountLoginPage/AccountLoginPage.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  HttpOverrides.global = MyHttpOverrides();

  if (message.data["Type"] == "message" && Platform.isAndroid) {
    await MessageNotification.ReceiveMessage(message);
  }
  else if (message.data["Type"] == "call" && Platform.isAndroid) {
    await CallNotification.ReceiveCall(message);
  }
  else if (message.data["Type"] == "call" && Platform.isIOS) {
    //to be implemented
  }
}


//IOS not allow to run anything when the app is terminated
Future<void> main() async {

  HttpOverrides.global = MyHttpOverrides();
  
  var widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var navigatorKey = GlobalKey<NavigatorState>();

  await FirebaseMessaging.instance.requestPermission(); 
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);

  String? otherUserId;
  bool? navigateToVideoCall;
  if (Platform.isAndroid){
    //only android use flutter_local_notification package
    await MessageNotification.InitializePackage(navigatorKey);

    //check whether the app is launched from notification from flutter_local_notification
    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var appLaunchNotification = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (appLaunchNotification != null && appLaunchNotification.notificationResponse != null){

      //call notification
      if (appLaunchNotification.notificationResponse!.payload!.contains("_call")){
        otherUserId = appLaunchNotification.notificationResponse!.payload!.replaceAll("_call", "");
        navigateToVideoCall = true;
      }
      //message notification
      else {
        otherUserId = appLaunchNotification.notificationResponse!.payload!;
      }
    }  
  }

  else if (Platform.isIOS){
    FirebaseMessaging.onMessageOpenedApp.listen((message) async { 
      var appData = await AppLaunch.ReadAppDataModel();
      var viewModel = await ChatSelectionViewModel.CreateViewModel(appData);
      if (message.data["Type"] == "call"){
        ChatNavigation.ChatRoomPageFromNotification(navigatorKey.currentContext!, appData, viewModel, message.data["OtherUserId"], true);
      }
      else {
        ChatNavigation.ChatRoomPageFromNotification(navigatorKey.currentContext!, appData, viewModel, message.data["OtherUserId"], null);
      }
    });

    //check whether the app is launched from notification from firebase_notification
    //notification will not be deleted after message is deleted for ios platform
    var message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null && message.data["OtherUserId"] != null){
      otherUserId = message.data["OtherUserId"];
    }
    if (message != null && message.data["Type"] != null){
      navigateToVideoCall = true;
    }
  }

  runApp(MainApp(navigatorKey, otherUserId, navigateToVideoCall));
}


class MainApp extends StatelessWidget {

  final GlobalKey<NavigatorState> NavigatorKey;
  final String? OtherUserId;
  final bool? NavigateToVideoCall;
  const MainApp(this.NavigatorKey, this.OtherUserId, this.NavigateToVideoCall, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigatorKey,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: AppLaunch.ReadAppDataModel(),
        builder: (context, snapshot) {  
          if (snapshot.connectionState == ConnectionState.done){
            FlutterNativeSplash.remove();
            var appData = snapshot.data!;

            //no connection or not user data in database
            if (snapshot.data == null || appData.AppToken == "" || appData.MyUser.Id == "") {
              return AccountLoginPage(appData.SelectedLanguage, appData.SelectedMode);
            }

            //app is launched from notification
            else if (OtherUserId != null) {
              return ChatSelectionPage(appData, OtherUserId, NavigateToVideoCall);
            }

            //app is launched from clicking app icon
            else {
              return ChatSelectionPage(appData, null, null);
            }
          }
          //will not display since the splash screen is showing
          return const Scaffold();
        }
      )
    );
  }
}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
} 