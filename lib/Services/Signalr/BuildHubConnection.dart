import 'package:textpop/Services/Signalr/ReconnectPolicy.dart';
import 'package:textpop/Services/WebServer/ConnectionOption.dart';
import 'package:signalr_core/signalr_core.dart';

class BuildHubConnection {

  ///Build the HubConnection instance
  ///return null when it cannot build the connection to server
  static Future<HubConnection?> BuildWebSocket(String appToken) async{
    try {
      var connection = HubConnectionBuilder()
      .withUrl(
        ConnectionOption().ChatHubUrl(), 
        HttpConnectionOptions(
          accessTokenFactory: () async => appToken,
          transport: HttpTransportType.webSockets
        )
      )
      .withAutomaticReconnect(ReconnectPolicy()) //reconnect every 5 seconds and never count as disconnected
      .build();
    await connection.start(); 
 
    connection.keepAliveIntervalInMilliseconds = 3000;
    connection.serverTimeoutInMilliseconds = 6000;

    return connection;
    }
    on Exception{
      return null;
    }
  }
}