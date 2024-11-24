/*
class FacebookProvider{

  ///Get the facebook token via facebook login service
  Future<String?> ReadIdToken() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success){
        // Once signed in, return the UserCredential
        return loginResult.accessToken!.token; 
      }

      return null;           
    }
    on Exception {
      return null;
    }
  }
}
*/