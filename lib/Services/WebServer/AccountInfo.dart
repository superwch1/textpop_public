import 'package:dio/dio.dart';
import 'package:textpop/Services/WebServer/ConnectionOption.dart';

class AccountInfo extends ConnectionOption{

  ///Update the user info.
  ///201 Created and 417 Exception
  Future<Response<dynamic>> UpdateUserInfo(String username, String? imageUri, String appToken) async {
    try {
      //convert the image file into stream when not null
      var image = imageUri == null ? null : await MultipartFile.fromFile(imageUri);

      FormData formData = FormData.fromMap({
        'image': image,
        'username': username
      });

      Response response = await dio.post(
        UpdateUserInfoUrl, 
        data: formData,
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


  ///Get the username and userId in Map object.
  ///200 OK and 417 Exception
  Future<Response<dynamic>> UserLogin(String appToken, String? fcmToken) async {
    try {
      Response<dynamic> response = await dio.get(
        UserLoginUrl,
        queryParameters: {'fcmToken': fcmToken},
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