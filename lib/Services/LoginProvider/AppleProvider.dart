import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleProvider {


  ///Get the apple token via apple login service
  Future<String?> ReadIdToken() async {
    try{
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [ AppleIDAuthorizationScopes.email ]
      );

      if (credential.identityToken != null){
        return credential.identityToken;
      }
      return null;
    }
    on Exception {
      return null;
    }
  }
}