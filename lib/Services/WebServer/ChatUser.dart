import 'package:dio/dio.dart';
import 'package:textpop/Services/WebServer/ConnectionOption.dart';

class ChatUser extends ConnectionOption{

  ///Read user info containing the keywords
  ///200 Ok and 417 Exception.
  Future<Response<dynamic>> SearchUser(String appToken, String username) async {
    try {
      Response<dynamic> response = await dio.get(
        SearchUserUrl,
        queryParameters: {"username": username},
        options: Options(headers: {
          "Authorization": "Bearer $appToken"
        })
      );
      return response;
    }
    on Exception{
      return Response(requestOptions: RequestOptions(), statusCode: 417);
    }
  }
}