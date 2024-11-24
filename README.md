# textpop
Firebase installation
1. Create project in Firebase website (https://console.firebase.google.com/)
2. Install the Firebase CLI (https://firebase.google.com/docs/cli#setup_update_cli)
3. Install the Node.js (https://nodejs.org/en/download)
4. Setup the firebase (https://firebase.google.com/docs/flutter/setup?platform=android)
9. Download google-service.json and place inside android/app/src
10. Download GoogleService-Info.plist and place inside ios/Runner
11. Add the SHA-1 & SHA-256 to firebase fingerprint for FCM (debug, release, Google SignIn)
12. Setup push notification and upload certificate in Xcode for FCM (https://firebase.google.com/docs/cloud-messaging/flutter/client)
13. Revisit the package (firebase, FCM, google_sign_in, image_picker, notification, splash screen, icon, sign_in_with_apple, url_launcher, flutter_webrtc with proguard-rules.pro) for configurations
14. Add Usage Description in info.plist for IOS (NSPhotoLibraryAddUsageDescription &　NSPhotoLibraryUsageDescription)
15. Resolve with Pods and Runner issues in Xcode
16. Remember to update Keys - textpop APNs for FCM if necessary
17. The TURN server use my server with (credentials - textpop: Aa123456)

Deploy to App Store
1. Update the Version CFBundleShortVersionString (CFBundleVersion) in Info.plist inside Runner
2. Open ios folder in Xcode, choose Any iOS devices (arm64), choose Product -> Archive -> Distribute to testflight
3. Naviagte to Distribution in App Store Connect, Add new version on top left corner, choose package then submit 
https://docs.flutter.dev/deployment/ios

Deploy to Play Store
1. Update the Version versionName (versionCode) in build.gradle inside app, the version code need to be difference on each release
2. command line to build apk: flutter build apk --split-per-abi 
3. command line to build aab (play store): flutter build appbundle
4. open Google play console -> Production -> Create new release -> drag .aab file into window -> 
https://docs.flutter.dev/deployment/android
 
Switch Development between Production
1. Change the ServerDomain in lib/Services/WebServer/ConnectionOptions
2. Remove HttpOverrides.global = MyHttpOverrides(); in main.dart
3. Update the SHA-1, SHA-256 (used in Google play console) in firebase for android
