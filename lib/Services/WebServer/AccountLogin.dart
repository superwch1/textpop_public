import 'package:dio/dio.dart';
import 'package:textpop/Services/WebServer/ConnectionOption.dart';

class AccountLogin extends ConnectionOption { 

  ///Get appToken, username and userId in Response object.
  ///202 Accepted (User found) & 201 Created (User created) and 417 Exception.
  Future<Response<dynamic>> LoginWithAppleToken(String appleToken, String fcmToken) async {
    try {
      Response<dynamic> response = await dio.get(AppleLoginUrl, queryParameters: {
        'appleToken': appleToken, 'fcmToken': fcmToken });
      return response;
    }
    on Exception {   
      return Response(requestOptions: RequestOptions(), statusCode: 417);
    }
  }


  ///Get appToken, username and userId in Response object.
  ///202 Accepted (User found) & 201 Created (User created) and 417 Exception.
  Future<Response<dynamic>> LoginWithFacebookToken(String facebookToken, String fcmToken) async {
    try {
      Response<dynamic> response = await dio.get(FacebookLoginUrl, queryParameters: {
        'facebookToken': facebookToken, 'fcmToken': fcmToken });
      return response;
    }
    on Exception {   
      return Response(requestOptions: RequestOptions(), statusCode: 417);
    }
  }


  ///Get appToken, username and userId in Response object. 
  ///202 Accepted (User found) & 201 Created (User created) and 417 Exception.
  Future<Response<dynamic>> LoginWithGoogleToken(String googleToken, String fcmToken) async {
    try {
      Response<dynamic> response = await dio.get(GoogleLoginUrl, queryParameters: {
        "googleToken" : googleToken, 'fcmToken': fcmToken });
      return response;
    }
    on Exception {
      return Response(requestOptions: RequestOptions(), statusCode: 417);
    }
  }
}