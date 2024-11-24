import 'package:dio/dio.dart';
import 'package:textpop/Services/WebServer/ConnectionOption.dart';

//404 also counted as exception
class ChatRoom extends ConnectionOption{

  ///Get message before earliest message.
  ///200 Ok and 417 Exception.
  Future<Response<dynamic>> ReadMessageBeforeEarliestMessage(String appToken, int earliestMessageId, String OtherUserId) async {
    try {
      Response<dynamic> response = await dio.get(
        ReadMessageBeforeEarliestMessageUrl,
        queryParameters: {"earliestMessageId": earliestMessageId, "OtherUserId" : OtherUserId},
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


  ///Get the latest message.
  ///200 Ok and 417 Excpetion.
  Future<Response<dynamic>> ReadLatestMessage(String appToken, String OtherUserId) async {
    try {
      Response<dynamic> response = await dio.get(
        ReadLatestMessageUrl,
        queryParameters: {"OtherUserId" : OtherUserId},
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


  ///Counter check the messages after initial message.
  ///200 Ok and 417 Exception.
  Future<Response<dynamic>> ReadMessageAfterInitialMessage(String appToken, String OtherUserId, int initialMessageId) async {
    try {
      Response<dynamic> response = await dio.get(
        ReadMessageAfterInitialMessageUrl,
        queryParameters: {"OtherUserId" : OtherUserId, "initialMessageId": initialMessageId},
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


  ///Send text messagae.
  ///201 Created and 417 Exception.
  Future<Response<dynamic>> SendTextMessage(String appToken, String OtherUserId, String text) async {
    try {
      Response<dynamic> response = await dio.post(
        SendTextMessageUrl,
        data: { "ReceiverUserId" : OtherUserId, "Text" : text },
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


  ///Send image message.
  ///201 Created and 417 Exception.
  Future<Response<dynamic>> SendImageMessage(String appToken, String OtherUserId, String imagePath) async {
    try {
      Dio dio = Dio(
        BaseOptions(headers: {'Content-Type': 'multipart/form-data'})
      );

      var image = await MultipartFile.fromFile(imagePath);

      FormData formData = FormData.fromMap({
        'image': image,
        'message': { "ReceiverUserId": OtherUserId,  } 
      });

      Response<dynamic> response = await dio.post(
        SendImageMessageUrl, 
        data: formData, options: 
        Options(headers: {
          "Authorization": "Bearer $appToken"
        }));
      return response;
    }
    on Exception {
      return Response(requestOptions: RequestOptions(), statusCode: 417);
    }
  }


  ///Send text messagae.
  ///201 Created and 417 Exception.
  Future<Response<dynamic>> ReportMessage(String appToken, String senderId, String messageId) async {
    try {
      Response<dynamic> response = await dio.post(
        ReportMessageUrl,
        queryParameters: { "senderId" : senderId, "messageId" : messageId },
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


  ///Send text messagae.
  ///200 Ok (unblock user), 201 Created (block user) and 417 Exception.
  Future<Response<dynamic>> BlockOrUnblockUser(String appToken, String blockedUserId) async {
    try {
      Response<dynamic> response = await dio.post(
        BlockOrUnblockUserUrl,
        queryParameters: { "blockedUserId" : blockedUserId },
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


  ///Create video call.
  ///201 Created and 417 Exception.
  Future<Response<dynamic>> CreateVideoCall(String appToken, String OtherUserId) async {
    try {
      Response<dynamic> response = await dio.post(
        CreateVideoCallUrl,
        queryParameters: { "otherUserId" : OtherUserId},
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


  ///Get image from website.
  ///200 Ok and 417 Exception.
  Future<Response<dynamic>> ReadImageFromUrl(String url, Map<String, String>? ImageHeader) async {
    try {
      Response<dynamic> response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          headers: ImageHeader)
      );
      return response;
    }
    on Exception {   
      return Response(requestOptions: RequestOptions(), statusCode: 417);
    }
  }


  ///Get image from website.
  ///200 Ok and 417 Exception.
  Future<Response<dynamic>> ReadImageMessage(String appToken, String messageId) async {
    try {
      Response<dynamic> response = await dio.get(
        ReadImageFromMessageUrl(messageId),
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            "Authorization": "Bearer $appToken"
        })
      );
      return response;
    }
    on Exception {   
      return Response(requestOptions: RequestOptions(), statusCode: 417);
    }
  }


  ///Get image from website.
  ///200 Ok and 417 Exception.
  Future<Response<dynamic>> DeleteMessage(String appToken, String messageId) async {
    try {
      Response<dynamic> response = await dio.post(
        DeleteMessageUrl,
        queryParameters: {"messageId": messageId},
        options: Options(
          headers: {
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