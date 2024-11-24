import 'package:dio/dio.dart';
import 'package:textpop/Services/WebServer/ConnectionOption.dart';

class SettingSelection extends ConnectionOption{
  ///Logout the user.
  ///200 OK and 417 Exception
  Future<Response<dynamic>> UserLogout(String appToken, String fcmToken) async {
    try {
      Response<dynamic> response = await dio.get(
        UserLogoutUrl,
        queryParameters: {
          "fcmToken": fcmToken
        },
        options: Options(headers: {
          "Authorization": "Bearer $appToken"
        })
      );
      return response;
    }
    on Exception {   
      return Response(requestOptions: RequestOptions(), statusCode: 417);
    }
  }


  ///Delete all message
  ///200 Ok and 417 Exception.
  Future<Response<dynamic>> DeleteAllMessage(String appToken) async {
    try {
      Response<dynamic> response = await dio.post(
        DeleteAllMessageUrl,
        options: Options(headers: {
          "Authorization": "Bearer $appToken"
        })
      );
      return response;
    }
    on Exception {   
      return Response(requestOptions: RequestOptions(), statusCode: 417);
    }
  }

  ///Delete all message
  ///200 Ok and 417 Exception.
  Future<Response<dynamic>> DeleteUser(String appToken) async {
    try {
      Response<dynamic> response = await dio.post(
        DeleteUserUrl,
        options: Options(headers: {
          "Authorization": "Bearer $appToken"
        })
      );
      return response;
    }
    on Exception {   
      return Response(requestOptions: RequestOptions(), statusCode: 417);
    }
  }
}