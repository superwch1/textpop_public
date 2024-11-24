import 'package:signalr_core/signalr_core.dart';

class WebSocketModel {
  HubConnection Connection;

  List<Future<void> Function()> InitializeFunctionList = List.empty(growable: true);
  List<Future<void> Function()> TermianteFunctionList = List.empty(growable: true);
  List<Future<void> Function()> ReconnectFunctionList = List.empty(growable: true);

  WebSocketModel(this.Connection);
}