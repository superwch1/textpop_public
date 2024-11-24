import 'package:google_sign_in/google_sign_in.dart';

class GoogleProvider {


  ///Get the google token via google login service
  Future<String?> ReadIdToken() async {
    try{
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null){
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        return googleAuth.idToken;
      }
      return null;
    }
    on Exception {
      return null;
    }
  }
}