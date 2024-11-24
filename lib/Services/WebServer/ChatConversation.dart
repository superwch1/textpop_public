import 'package:dio/dio.dart';
import 'package:textpop/Services/WebServer/ConnectionOption.dart';

class ChatConversation extends ConnectionOption{

  ///Get all conversation in response object.
  ///200 Ok and 417 Exception.
  Future<Response<dynamic>> ReadAllConversation(String appToken) async {
    try {
      Response<dynamic> response = await dio.get(
        ReadAllConversationUrl,
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

 
  ///Get unseen conversation only in response object.
  ///200 Ok and 417 Exception.
  Future<Response<dynamic>> ReadUnseenConversation(String appToken) async {
    try {
      Response<dynamic> response = await dio.get(
        ReadUnseenConversationUrl,
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