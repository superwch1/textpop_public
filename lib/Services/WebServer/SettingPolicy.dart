import 'package:dio/dio.dart';
import 'package:textpop/Services/WebServer/ConnectionOption.dart';

class SettingPolicy extends ConnectionOption{
  ///Read Privacy Policy
  ///200 OK and 417 Exception
  Future<Response<dynamic>> ReadPrivacyPolicy(String language) async {
    try {
      Response<dynamic> response = await dio.get(
        PrivacyPolicyUrl,
        queryParameters: {
          "language": language
        }
      );
      return response;
    }
    on Exception {   
      return Response(requestOptions: RequestOptions(), statusCode: 417);
    }
  }

  ///Read Terms and Conditions
  ///200 Ok and 417 Exception.
  Future<Response<dynamic>> ReadTermsAndConditions(String language) async {
    try {
      Response<dynamic> response = await dio.get(
        TermsAndConditionsUrl,
        queryParameters: {
          "language": language
        }
      );
      return response;
    }
    on Exception {   
      return Response(requestOptions: RequestOptions(), statusCode: 417);
    }
  }
}